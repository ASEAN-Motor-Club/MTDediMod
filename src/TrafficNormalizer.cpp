#include "TrafficNormalizer.h"

#pragma push_macro("check")
#undef check
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#pragma pop_macro("check")

#include <atomic>
#include <cmath>
#include <cstdarg>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <unordered_map>
#include <vector>

namespace
{
    struct FVec3
    {
        double x;
        double y;
        double z;
    };

    // Runtime-resolved config
    bool g_enabled = true;
    double g_cell_cm = 25000.0;
    double g_active_radius_cm = 100000.0; // 1 km player neighborhood
    int32_t g_local_cap = 8;
    double g_cap_radius_cm = 40000.0;     // 400 m local cap neighborhood

    // Live AMTAIVehicleSpawnSystem* cached by Hook 2 for reading player clusters (+0x340)
    std::atomic<void*> g_spawn_sys{nullptr};

    // Dynamically extracted offsets (from binary disassembly at init — zero version hardcoding)
    uint32_t g_nav_graph_off = 0;   // AMotorTownNavigation -> GraphData* (0x358 on 0.7.19, 0x3d0 on 0.7.20)
    uint32_t g_node_stride = 0;     // sizeof(FMTRoadGraphNode) (0xa8 on 0.7.19, 0xb0 on 0.7.20)
    uint32_t g_node_pos_off = 0x20; // FVector Location inside FMTRoadGraphNode
    uint32_t g_node_road_off = 0x0; // AMTRoad* inside FMTRoadGraphNode
    uint32_t g_road_flags_off = 0;  // RoadFlags uint32 inside AMTRoad (0x2d0 on 0.7.19, 0x2d4 on 0.7.20)
    uint32_t g_agent_stride = 0;    // sizeof(FVirtualTrafficAgent) (0xd0 on 0.7.19, 0x130 on 0.7.20)

    // Function types
    using NavGetRandomRoadNodeFn = bool(__fastcall*)(
        void* nav,
        FVec3* center,
        float min_dist,
        float max_dist,
        void* out_node,
        uint32_t node_flag_mask,
        uint32_t road_flag_mask);

    using TrafficCanMaterializeFn = bool(__fastcall*)(
        void* agent,
        bool bWarmup,
        void* spawnSys);

    // GetAgentPosition(void* agent, FVec3* out_pos) -> FVec3*
    using GetAgentPositionFn = FVec3*(__fastcall*)(void* agent, FVec3* out_pos);

    NavGetRandomRoadNodeFn g_orig_nav = nullptr;
    TrafficCanMaterializeFn g_orig_mat = nullptr;
    GetAgentPositionFn g_get_agent_pos = nullptr;

    // Inline detour records
    struct InlineHook
    {
        uint8_t* target = nullptr;
        uint8_t* trampoline = nullptr;
        uint8_t orig_bytes[32]{};
        size_t stolen_len = 0;
        bool installed = false;
    };

    InlineHook g_hook_nav{};
    InlineHook g_hook_mat{};
    bool g_initialized = false;

    // Spatial grid cache (rebuilt only when nav pointer or node count changes)
    struct GridCell
    {
        double cx = 0.0;
        double cy = 0.0;
        std::vector<int32_t> indices;
    };

    struct SpatialGrid
    {
        void* nav_ptr = nullptr;
        int32_t node_count = 0;
        std::vector<GridCell> cells;
    };

    CRITICAL_SECTION g_grid_lock{};
    bool g_grid_lock_ready = false;
    SpatialGrid g_grid{};

    // Telemetry counters
    std::atomic<uint64_t> g_stat_strat_hits{0};
    std::atomic<uint64_t> g_stat_local_hits{0};
    std::atomic<uint64_t> g_stat_strat_fallbacks{0};
    std::atomic<uint64_t> g_stat_cap_allowed{0};
    std::atomic<uint64_t> g_stat_cap_rejected{0};
    std::atomic<uint64_t> g_stat_cap_errors{0};
    std::atomic<uint64_t> g_last_report_ms{0};

    // Logging to MotorTown\Saved\ServerLog\amc_traffic_norm.log (never touches Output::send)
    CRITICAL_SECTION g_log_lock{};
    bool g_log_lock_ready = false;
    char g_log_path[MAX_PATH]{};

    void init_log_path()
    {
        if (g_log_path[0]) return;
        char exe_path[MAX_PATH]{};
        DWORD len = GetModuleFileNameA(nullptr, exe_path, MAX_PATH);
        if (len > 0 && len < MAX_PATH)
        {
            const char* marker = strstr(exe_path, "\\Binaries\\");
            if (marker)
            {
                size_t prefix = static_cast<size_t>(marker - exe_path);
                if (prefix + 48 < MAX_PATH)
                {
                    memcpy(g_log_path, exe_path, prefix);
                    strcpy(g_log_path + prefix, "\\Saved\\ServerLog\\amc_traffic_norm.log");
                    return;
                }
            }
        }
        strcpy(g_log_path, "amc_traffic_norm.log");
    }

    void logf_file(const char* fmt, ...)
    {
        char buf[1024];
        va_list ap;
        va_start(ap, fmt);
        vsnprintf(buf, sizeof(buf), fmt, ap);
        va_end(ap);

        if (g_log_lock_ready) EnterCriticalSection(&g_log_lock);
        init_log_path();
        if (FILE* f = fopen(g_log_path, "a"))
        {
            SYSTEMTIME st{};
            GetSystemTime(&st);
            fprintf(f, "[%04u-%02u-%02u %02u:%02u:%02u.%03u] %s\n",
                    st.wYear, st.wMonth, st.wDay,
                    st.wHour, st.wMinute, st.wSecond, st.wMilliseconds, buf);
            fclose(f);
        }
        if (g_log_lock_ready) LeaveCriticalSection(&g_log_lock);
    }

    int read_env_int(const char* name, int def_val)
    {
        const char* v = getenv(name);
        if (!v || !*v) return def_val;
        char* end = nullptr;
        long parsed = strtol(v, &end, 10);
        if (end == v) return def_val;
        return static_cast<int>(parsed);
    }

    // Fast xorshift64* PRNG (thread-local)
    uint64_t next_rand()
    {
        static thread_local uint64_t s = 0;
        if (s == 0)
        {
            s = static_cast<uint64_t>(GetTickCount64()) ^ (static_cast<uint64_t>(GetCurrentThreadId()) << 32) ^ 0x9E3779B97F4A7C15ULL;
            if (s == 0) s = 0xDEADBEEFCAFEBABEULL;
        }
        s ^= s >> 12;
        s ^= s << 25;
        s ^= s >> 27;
        return s * 0x2545F4914F6CDD1DULL;
    }

    // SEH-safe raw memory helpers (noinline + volatile + /EHa so hardware AVs are actually caught)
    __declspec(noinline) bool seh_read_ptr(const void* addr, void** out)
    {
        __try
        {
            *out = *reinterpret_cast<void* const volatile*>(addr);
            return true;
        }
        __except (EXCEPTION_EXECUTE_HANDLER)
        {
            return false;
        }
    }

    __declspec(noinline) bool seh_read_u32(const void* addr, uint32_t* out)
    {
        __try
        {
            *out = *reinterpret_cast<const volatile uint32_t*>(addr);
            return true;
        }
        __except (EXCEPTION_EXECUTE_HANDLER)
        {
            return false;
        }
    }

    __declspec(noinline) bool seh_read_u8(const void* addr, uint8_t* out)
    {
        __try
        {
            *out = *reinterpret_cast<const volatile uint8_t*>(addr);
            return true;
        }
        __except (EXCEPTION_EXECUTE_HANDLER)
        {
            return false;
        }
    }

    __declspec(noinline) bool seh_read_vec3(const void* addr, FVec3* out)
    {
        __try
        {
            const volatile double* p = reinterpret_cast<const volatile double*>(addr);
            out->x = p[0];
            out->y = p[1];
            out->z = p[2];
            return true;
        }
        __except (EXCEPTION_EXECUTE_HANDLER)
        {
            return false;
        }
    }

    __declspec(noinline) bool seh_get_agent_pos(void* agent, FVec3* out)
    {
        __try
        {
            g_get_agent_pos(agent, out);
            return true;
        }
        __except (EXCEPTION_EXECUTE_HANDLER)
        {
            return false;
        }
    }

    // PE .text section locator
    bool get_main_text_section(uint8_t** base_out, uint8_t** text_out, size_t* text_size_out)
    {
        HMODULE mod = GetModuleHandleA(nullptr);
        if (!mod) return false;
        auto* base = reinterpret_cast<uint8_t*>(mod);
        auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(base);
        if (dos->e_magic != IMAGE_DOS_SIGNATURE) return false;
        auto* nt = reinterpret_cast<IMAGE_NT_HEADERS64*>(base + dos->e_lfanew);
        if (nt->Signature != IMAGE_NT_SIGNATURE) return false;
        auto* sec = IMAGE_FIRST_SECTION(nt);
        for (WORD i = 0; i < nt->FileHeader.NumberOfSections; ++i)
        {
            if (memcmp(sec[i].Name, ".text", 5) == 0)
            {
                *base_out = base;
                *text_out = base + sec[i].VirtualAddress;
                *text_size_out = sec[i].Misc.VirtualSize;
                return true;
            }
        }
        return false;
    }

    // AOB pattern scan: mask 'x' = match, '?' = wildcard
    std::vector<uint8_t*> scan_aob(const uint8_t* start, size_t len, const uint8_t* pat, const char* mask)
    {
        std::vector<uint8_t*> hits;
        size_t plen = strlen(mask);
        if (plen == 0 || plen > len) return hits;
        size_t end = len - plen;
        for (size_t i = 0; i <= end; ++i)
        {
            bool ok = true;
            for (size_t j = 0; j < plen; ++j)
            {
                if (mask[j] == 'x' && start[i + j] != pat[j])
                {
                    ok = false;
                    break;
                }
            }
            if (ok) hits.push_back(const_cast<uint8_t*>(start + i));
        }
        return hits;
    }

    // Minimal x86-64 instruction length decoder for function prologues (covers all MSVC/UE5 prologues)
    size_t decode_x64_insn_len(const uint8_t* p)
    {
        size_t i = 0;
        bool has_66 = false;
        while (p[i] == 0x66 || p[i] == 0x67 || p[i] == 0xF2 || p[i] == 0xF3 || p[i] == 0x2E || p[i] == 0x3E)
        {
            if (p[i] == 0x66) has_66 = true;
            ++i;
        }
        uint8_t rex = 0;
        if ((p[i] & 0xF0) == 0x40)
        {
            rex = p[i++];
        }
        uint8_t op = p[i++];
        if ((op >= 0x50 && op <= 0x5F) || op == 0x90 || op == 0xC3)
        {
            return i;
        }
        if (op == 0x0F)
        {
            uint8_t op2 = p[i++];
            if (op2 >= 0x80 && op2 <= 0x8F) return i + 4;
            if (op2 == 0x10 || op2 == 0x11 || op2 == 0x28 || op2 == 0x29 || op2 == 0xB6 || op2 == 0xB7 || op2 == 0xAF || op2 == 0x1F)
            {
                uint8_t modrm = p[i++];
                uint8_t mod = (modrm >> 6) & 3;
                uint8_t rm = modrm & 7;
                if (mod != 3 && rm == 4) ++i;
                if (mod == 1) i += 1;
                else if (mod == 2 || (mod == 0 && rm == 5)) i += 4;
                return i;
            }
            return 0;
        }
        if (op == 0xE8 || op == 0xE9) return i + 4;
        if (op == 0xEB || (op >= 0x70 && op <= 0x7F)) return i + 1;
        if (op >= 0xB8 && op <= 0xBF) return i + ((rex & 8) ? 8 : (has_66 ? 2 : 4));
        if (op == 0x81 || op == 0x83 || op == 0x85 || op == 0x89 || op == 0x8B || op == 0x8D ||
            op == 0x33 || op == 0x39 || op == 0x3B || op == 0x63 || op == 0xC7 || op == 0x80 ||
            op == 0x88 || op == 0x8A || op == 0x69 || op == 0x6B)
        {
            uint8_t modrm = p[i++];
            uint8_t mod = (modrm >> 6) & 3;
            uint8_t rm = modrm & 7;
            if (mod != 3 && rm == 4) ++i;
            if (mod == 1) i += 1;
            else if (mod == 2 || (mod == 0 && rm == 5)) i += 4;
            if (op == 0x83 || op == 0x80 || op == 0x6B) i += 1;
            else if (op == 0x81 || op == 0xC7 || op == 0x69) i += 4;
            return i;
        }
        return 0;
    }

    // Allocate RWX trampoline page within ±2 GB of target (for 5-byte JMP or 14-byte FF 25 JMP)
    uint8_t* alloc_near_trampoline(uint8_t* target)
    {
        uintptr_t base = reinterpret_cast<uintptr_t>(target);
        uintptr_t lo = (base > 0x70000000ULL) ? (base - 0x70000000ULL) : 0x10000ULL;
        uintptr_t hi = base + 0x70000000ULL;
        for (uintptr_t addr = (base & ~0xFFFFULL) - 0x10000ULL; addr >= lo; addr -= 0x10000ULL)
        {
            void* p = VirtualAlloc(reinterpret_cast<void*>(addr), 4096, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
            if (p) return reinterpret_cast<uint8_t*>(p);
            if (addr < 0x10000ULL) break;
        }
        for (uintptr_t addr = (base & ~0xFFFFULL) + 0x10000ULL; addr < hi; addr += 0x10000ULL)
        {
            void* p = VirtualAlloc(reinterpret_cast<void*>(addr), 4096, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
            if (p) return reinterpret_cast<uint8_t*>(p);
        }
        return reinterpret_cast<uint8_t*>(VirtualAlloc(nullptr, 4096, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));
    }

    // Install a 14-byte absolute indirect jump detour (FF 25 00 00 00 00 <8-byte addr>)
    bool install_inline_hook(InlineHook* hk, uint8_t* target, void* detour, void** orig_out)
    {
        if (!target || !detour || !orig_out) return false;
        constexpr size_t kPatchLen = 14;
        size_t total = 0;
        while (total < kPatchLen)
        {
            size_t len = decode_x64_insn_len(target + total);
            if (len == 0)
            {
                logf_file("install_inline_hook: undecodable opcode 0x%02X at +%zu", target[total], total);
                return false;
            }
            if (target[total] == 0xE8 || target[total] == 0xE9 || target[total] == 0xEB ||
                (target[total] >= 0x70 && target[total] <= 0x7F))
            {
                logf_file("install_inline_hook: RIP-relative branch at +%zu not supported", total);
                return false;
            }
            total += len;
            if (total > sizeof(hk->orig_bytes)) return false;
        }

        uint8_t* tramp = alloc_near_trampoline(target);
        if (!tramp) return false;

        memcpy(hk->orig_bytes, target, total);
        memcpy(tramp, target, total);

        uint8_t* ret_site = target + total;
        tramp[total + 0] = 0xFF;
        tramp[total + 1] = 0x25;
        uint32_t zero = 0;
        memcpy(tramp + total + 2, &zero, 4);
        memcpy(tramp + total + 6, &ret_site, 8);

        DWORD old_prot = 0;
        if (!VirtualProtect(target, total, PAGE_EXECUTE_READWRITE, &old_prot))
        {
            VirtualFree(tramp, 0, MEM_RELEASE);
            return false;
        }

        target[0] = 0xFF;
        target[1] = 0x25;
        memcpy(target + 2, &zero, 4);
        memcpy(target + 6, &detour, 8);
        for (size_t i = kPatchLen; i < total; ++i) target[i] = 0x90;

        DWORD dummy = 0;
        VirtualProtect(target, total, old_prot, &dummy);
        FlushInstructionCache(GetCurrentProcess(), target, total);
        FlushInstructionCache(GetCurrentProcess(), tramp, total + 14);

        hk->target = target;
        hk->trampoline = tramp;
        hk->stolen_len = total;
        hk->installed = true;
        *orig_out = tramp;
        return true;
    }

    void remove_inline_hook(InlineHook* hk)
    {
        if (!hk || !hk->installed) return;
        DWORD old_prot = 0;
        if (VirtualProtect(hk->target, hk->stolen_len, PAGE_EXECUTE_READWRITE, &old_prot))
        {
            memcpy(hk->target, hk->orig_bytes, hk->stolen_len);
            DWORD dummy = 0;
            VirtualProtect(hk->target, hk->stolen_len, old_prot, &dummy);
            FlushInstructionCache(GetCurrentProcess(), hk->target, hk->stolen_len);
        }
        if (hk->trampoline)
        {
            VirtualFree(hk->trampoline, 0, MEM_RELEASE);
            hk->trampoline = nullptr;
        }
        hk->installed = false;
    }

    void maybe_log_stats()
    {
        uint64_t now = GetTickCount64();
        uint64_t prev = g_last_report_ms.load(std::memory_order_relaxed);
        if (now - prev < 60000ULL) return;
        if (!g_last_report_ms.compare_exchange_strong(prev, now)) return;

        size_t cells = 0;
        int32_t nodes = 0;
        if (g_grid_lock_ready)
        {
            EnterCriticalSection(&g_grid_lock);
            cells = g_grid.cells.size();
            nodes = g_grid.node_count;
            LeaveCriticalSection(&g_grid_lock);
        }

        logf_file("stats: grid_cells=%zu grid_nodes=%d strat_hits=%llu local_hits=%llu strat_fallbacks=%llu cap_allowed=%llu cap_rejected=%llu cap_errors=%llu",
                  cells, nodes,
                  static_cast<unsigned long long>(g_stat_strat_hits.load()),
                  static_cast<unsigned long long>(g_stat_local_hits.load()),
                  static_cast<unsigned long long>(g_stat_strat_fallbacks.load()),
                  static_cast<unsigned long long>(g_stat_cap_allowed.load()),
                  static_cast<unsigned long long>(g_stat_cap_rejected.load()),
                  static_cast<unsigned long long>(g_stat_cap_errors.load()));
    }

    bool rebuild_grid_locked(void* nav, uint8_t* nodes_data, int32_t nodes_num)
    {
        if (g_grid.nav_ptr != nav)
        {
            g_spawn_sys.store(nullptr, std::memory_order_release);
        }
        g_grid.nav_ptr = nav;
        g_grid.node_count = nodes_num;
        g_grid.cells.clear();

        if (!nodes_data || nodes_num <= 0 || nodes_num > 500000 || g_node_stride < 0x40) return false;

        std::unordered_map<int64_t, size_t> cell_map;
        cell_map.reserve(1024);

        const double inv_cell = 1.0 / g_cell_cm;
        int32_t valid_nodes = 0;

        for (int32_t i = 0; i < nodes_num; ++i)
        {
            const uint8_t* node = nodes_data + static_cast<size_t>(i) * g_node_stride;
            // Pre-filter basic non-AI road/node flags (0x64 / 0x9); runtime caller masks
            // (e.g. 0x464 / 0x400) are still enforced identically by g_orig_nav().
            uint32_t nflags = 0;
            if (!seh_read_u32(node + 0x7c, &nflags)) continue;
            if ((nflags & 0x64u) != 0) continue;

            void* road_ptr = nullptr;
            if (!seh_read_ptr(node + g_node_road_off, &road_ptr) || !road_ptr) continue;
            if (g_road_flags_off != 0)
            {
                uint32_t rflags = 0;
                if (!seh_read_u32(reinterpret_cast<uint8_t*>(road_ptr) + g_road_flags_off, &rflags)) continue;
                if ((rflags & 9u) != 0) continue;
            }

            FVec3 pos{};
            if (!seh_read_vec3(node + g_node_pos_off, &pos)) continue;
            if (!std::isfinite(pos.x) || !std::isfinite(pos.y)) continue;

            int32_t cx = static_cast<int32_t>(std::floor(pos.x * inv_cell));
            int32_t cy = static_cast<int32_t>(std::floor(pos.y * inv_cell));
            int64_t key = (static_cast<int64_t>(cx) << 32) | static_cast<uint32_t>(cy);

            auto it = cell_map.find(key);
            if (it == cell_map.end())
            {
                size_t cid = g_grid.cells.size();
                cell_map.emplace(key, cid);
                GridCell cell{};
                cell.cx = (static_cast<double>(cx) + 0.5) * g_cell_cm;
                cell.cy = (static_cast<double>(cy) + 0.5) * g_cell_cm;
                cell.indices.push_back(i);
                g_grid.cells.push_back(std::move(cell));
            }
            else
            {
                g_grid.cells[it->second].indices.push_back(i);
            }
            ++valid_nodes;
        }

        logf_file("spatial grid built: nav=%p total_nodes=%d valid_nodes=%d occupied_cells=%zu cell_cm=%.0f",
                  nav, nodes_num, valid_nodes, g_grid.cells.size(), g_cell_cm);
        return !g_grid.cells.empty();
    }

    // Hook 1: Nav_GetRandomRoadNode
    bool __fastcall hook_nav_get_random_road_node(
        void* nav,
        FVec3* center,
        float min_dist,
        float max_dist,
        void* out_node,
        uint32_t node_flag_mask,
        uint32_t road_flag_mask)
    {
        maybe_log_stats();

        if (!g_enabled || g_cell_cm <= 0.0 || !nav || max_dist > 0.0f || g_nav_graph_off == 0)
        {
            return g_orig_nav(nav, center, min_dist, max_dist, out_node, node_flag_mask, road_flag_mask);
        }

        void* graph_ptr = nullptr;
        if (!seh_read_ptr(reinterpret_cast<uint8_t*>(nav) + g_nav_graph_off, &graph_ptr) || !graph_ptr)
        {
            return g_orig_nav(nav, center, min_dist, max_dist, out_node, node_flag_mask, road_flag_mask);
        }

        void* nodes_data = nullptr;
        uint32_t nodes_num_u = 0;
        if (!seh_read_ptr(reinterpret_cast<uint8_t*>(graph_ptr) + 0x10, &nodes_data) ||
            !seh_read_u32(reinterpret_cast<uint8_t*>(graph_ptr) + 0x18, &nodes_num_u))
        {
            return g_orig_nav(nav, center, min_dist, max_dist, out_node, node_flag_mask, road_flag_mask);
        }
        int32_t nodes_num = static_cast<int32_t>(nodes_num_u);
        if (!nodes_data || nodes_num <= 0 || nodes_num > 500000)
        {
            return g_orig_nav(nav, center, min_dist, max_dist, out_node, node_flag_mask, road_flag_mask);
        }

        const bool has_min_dist = (min_dist > 0.0f && center != nullptr);
        const double min_sq = has_min_dist ? (static_cast<double>(min_dist) * static_cast<double>(min_dist)) : 0.0;

        constexpr int kMaxAttempts = 12;
        for (int attempt = 0; attempt < kMaxAttempts; ++attempt)
        {
            FVec3 picked_pos{};
            bool have_pick = false;
            bool picked_local = false;

            // Read live player cluster positions from cached AMTAIVehicleSpawnSystem* (+0x340)
            // FPlayerCluster (0x40 stride): +0x11 bStopped, +0x20 ActiveCount, +0x28 FVector Location
            FVec3 player_pos{};
            bool have_player = false;
            if (g_active_radius_cm > 0.0)
            {
                void* sp = g_spawn_sys.load(std::memory_order_acquire);
                void* cl_data = nullptr;
                uint32_t cl_num_u = 0;
                if (sp &&
                    seh_read_ptr(reinterpret_cast<const uint8_t*>(sp) + 0x340, &cl_data) &&
                    seh_read_u32(reinterpret_cast<const uint8_t*>(sp) + 0x348, &cl_num_u) &&
                    cl_data && cl_num_u > 0 && cl_num_u <= 128)
                {
                    uint32_t pick_cl = static_cast<uint32_t>(next_rand() % cl_num_u);
                    const uint8_t* cl = reinterpret_cast<const uint8_t*>(cl_data) + static_cast<size_t>(pick_cl) * 0x40;
                    if (seh_read_vec3(cl + 0x28, &player_pos))
                    {
                        have_player = true;
                        static std::atomic<int> s_logged_cl{0};
                        if (s_logged_cl.fetch_add(1) == 0)
                        {
                            logf_file("local_player_cluster: num=%u pos=(%.1f,%.1f,%.1f)",
                                      cl_num_u, player_pos.x, player_pos.y, player_pos.z);
                        }
                    }
                }
            }

            if (g_grid_lock_ready) EnterCriticalSection(&g_grid_lock);
            if (g_grid.nav_ptr != nav || g_grid.node_count != nodes_num)
            {
                rebuild_grid_locked(nav, reinterpret_cast<uint8_t*>(nodes_data), nodes_num);
            }
            if (!g_grid.cells.empty())
            {
                size_t cell_idx = 0;
                if (have_player)
                {
                    const double ar_sq = g_active_radius_cm * g_active_radius_cm;
                    uint32_t match_count = 0;
                    size_t chosen = 0;
                    for (size_t ci = 0; ci < g_grid.cells.size(); ++ci)
                    {
                        const auto& c = g_grid.cells[ci];
                        double dx = c.cx - player_pos.x;
                        double dy = c.cy - player_pos.y;
                        if (dx * dx + dy * dy <= ar_sq)
                        {
                            ++match_count;
                            if ((next_rand() % match_count) == 0) chosen = ci;
                        }
                    }
                    if (match_count > 0)
                    {
                        cell_idx = chosen;
                        picked_local = true;
                    }
                    else
                    {
                        cell_idx = static_cast<size_t>(next_rand() % g_grid.cells.size());
                    }
                }
                else
                {
                    cell_idx = static_cast<size_t>(next_rand() % g_grid.cells.size());
                }

                const auto& bucket = g_grid.cells[cell_idx].indices;
                if (!bucket.empty())
                {
                    int32_t node_idx = bucket[static_cast<size_t>(next_rand() % bucket.size())];
                    if (node_idx >= 0 && node_idx < nodes_num)
                    {
                        const uint8_t* node = reinterpret_cast<uint8_t*>(nodes_data) + static_cast<size_t>(node_idx) * g_node_stride;
                        if (seh_read_vec3(node + g_node_pos_off, &picked_pos))
                        {
                            have_pick = true;
                        }
                    }
                }
            }
            if (g_grid_lock_ready) LeaveCriticalSection(&g_grid_lock);

            if (!have_pick) break;

            if (has_min_dist)
            {
                double dx = picked_pos.x - center->x;
                double dy = picked_pos.y - center->y;
                double dz = picked_pos.z - center->z;
                if (dx * dx + dy * dy + dz * dz < min_sq) continue;
            }

            // Delegate to original with a tight 5 m window around the picked node
            // so original performs all flag checks and FMTRoadGraphNode struct copy.
            bool ok = g_orig_nav(nav, &picked_pos, 0.0f, 500.0f, out_node, node_flag_mask, road_flag_mask);
            if (ok)
            {
                g_stat_strat_hits.fetch_add(1, std::memory_order_relaxed);
                if (picked_local) g_stat_local_hits.fetch_add(1, std::memory_order_relaxed);
                return true;
            }
        }

        g_stat_strat_fallbacks.fetch_add(1, std::memory_order_relaxed);
        return g_orig_nav(nav, center, min_dist, max_dist, out_node, node_flag_mask, road_flag_mask);
    }

    // Hook 2: Traffic_CanMaterialize
    bool __fastcall hook_traffic_can_materialize(void* agent, bool bWarmup, void* spawnSys)
    {
        if (spawnSys) g_spawn_sys.store(spawnSys, std::memory_order_release);
        bool ok = g_orig_mat(agent, bWarmup, spawnSys);
        if (!ok || !g_enabled || g_local_cap <= 0 || !agent || !spawnSys || !g_get_agent_pos || g_agent_stride == 0)
        {
            return ok;
        }

        FVec3 cand_pos{};
        if (!seh_get_agent_pos(agent, &cand_pos))
        {
            g_stat_cap_errors.fetch_add(1, std::memory_order_relaxed);
            return true;
        }

        // Virtual-agent TSparseArray at spawnSys + 0x2d8:
        //   +0x2d8: Data* (element array, stride g_agent_stride)
        //   +0x2e0: ArrayNum (int32)
        //   +0x2e8: AllocationFlags.InlineData[4] (128 bits inline)
        //   +0x2f8: AllocationFlags.SecondaryData* (heap bits when NumBits > 128)
        //   +0x300: AllocationFlags.NumBits (int32)
        const uint8_t* sys = reinterpret_cast<const uint8_t*>(spawnSys);
        void* data_ptr = nullptr;
        uint32_t arr_num_u = 0;
        uint32_t max_bits_u = 0;
        if (!seh_read_ptr(sys + 0x2d8, &data_ptr) ||
            !seh_read_u32(sys + 0x2e0, &arr_num_u) ||
            !seh_read_u32(sys + 0x300, &max_bits_u))
        {
            g_stat_cap_errors.fetch_add(1, std::memory_order_relaxed);
            return true;
        }

        int32_t arr_num = static_cast<int32_t>(arr_num_u);
        int32_t num_bits = static_cast<int32_t>(max_bits_u);
        if (!data_ptr || arr_num <= 0 || arr_num > 100000 || num_bits <= 0)
        {
            g_stat_cap_errors.fetch_add(1, std::memory_order_relaxed);
            return true;
        }
        if (num_bits < arr_num) arr_num = num_bits;

        void* secondary_bits = nullptr;
        if (!seh_read_ptr(sys + 0x2f8, &secondary_bits))
        {
            g_stat_cap_errors.fetch_add(1, std::memory_order_relaxed);
            return true;
        }
        const uint8_t* bits_base = (secondary_bits != nullptr)
            ? reinterpret_cast<const uint8_t*>(secondary_bits)
            : (sys + 0x2e8);

        const double cap_r_sq = g_cap_radius_cm * g_cap_radius_cm;
        int32_t active_nearby = 0;

        for (int32_t i = 0; i < arr_num; ++i)
        {
            uint32_t word = 0;
            if (!seh_read_u32(bits_base + (static_cast<size_t>(i >> 5) * 4), &word)) break;
            if (((word >> (i & 31)) & 1u) == 0) continue;

            uint8_t* other = reinterpret_cast<uint8_t*>(data_ptr) + static_cast<size_t>(i) * g_agent_stride;
            if (other == agent) continue;

            uint8_t b_is_virtual = 1;
            if (!seh_read_u8(other + 0x24, &b_is_virtual)) continue;
            if (b_is_virtual != 0) continue;

            FVec3 other_pos{};
            if (!seh_get_agent_pos(other, &other_pos)) continue;

            double dx = other_pos.x - cand_pos.x;
            double dy = other_pos.y - cand_pos.y;
            double dz = other_pos.z - cand_pos.z;
            if (dx * dx + dy * dy + dz * dz <= cap_r_sq)
            {
                ++active_nearby;
                if (active_nearby >= g_local_cap)
                {
                    g_stat_cap_rejected.fetch_add(1, std::memory_order_relaxed);
                    return false;
                }
            }
        }

        g_stat_cap_allowed.fetch_add(1, std::memory_order_relaxed);
        return true;
    }

    // Dynamically extract struct offsets from Nav_GetRandomRoadNode machine code
    bool extract_nav_offsets(const uint8_t* fn)
    {
        for (size_t i = 0; i < 64; ++i)
        {
            if (fn[i] == 0x48 && fn[i + 1] == 0x8B && fn[i + 2] == 0x99 && fn[i + 5] == 0x00 && fn[i + 6] == 0x00)
            {
                uint32_t disp = 0;
                memcpy(&disp, fn + i + 3, 4);
                g_nav_graph_off = disp;
                break;
            }
        }
        if (g_nav_graph_off == 0) return false;

        for (size_t i = 0; i < 384; ++i)
        {
            if (fn[i] == 0x69 && (fn[i + 1] & 0xC0) == 0xC0)
            {
                uint32_t imm = 0;
                memcpy(&imm, fn + i + 2, 4);
                if (imm >= 0x80 && imm <= 0x200 && (imm & 7) == 0)
                {
                    g_node_stride = imm;
                    break;
                }
            }
        }
        if (g_node_stride == 0) g_node_stride = 0xb0;

        for (size_t i = 0; i < 640; ++i)
        {
            if ((fn[i] == 0x85 || fn[i] == 0xF7) && i >= 6)
            {
                for (size_t k = 1; k <= 12 && k <= i; ++k)
                {
                    if ((fn[i - k] == 0x8B || fn[i - k] == 0xF7) && (fn[i - k + 1] & 0xC0) == 0x80)
                    {
                        uint32_t disp = 0;
                        memcpy(&disp, fn + i - k + 2, 4);
                        if (disp >= 0x280 && disp <= 0x340 && (disp & 3) == 0)
                        {
                            g_road_flags_off = disp;
                            break;
                        }
                    }
                }
                if (g_road_flags_off) break;
            }
        }
        if (g_road_flags_off == 0) g_road_flags_off = (g_node_stride >= 0xb0) ? 0x2d4 : 0x2d0;

        g_node_pos_off = 0x20;
        g_node_road_off = 0x00;
        return true;
    }

    // Dynamically extract FVirtualTrafficAgent stride from Traffic_CanMaterialize machine code
    bool extract_agent_stride(const uint8_t* mat_fn)
    {
        for (size_t i = 0; i < 200; ++i)
        {
            if (mat_fn[i] == 0x0F && mat_fn[i + 1] == 0x2F && mat_fn[i + 2] == 0x83)
            {
                uint32_t dist_off = 0;
                memcpy(&dist_off, mat_fn + i + 3, 4);
                if (dist_off == 0xa8) { g_agent_stride = 0xd0; return true; }
                if (dist_off == 0x108) { g_agent_stride = 0x130; return true; }
            }
        }
        g_agent_stride = (g_node_stride >= 0xb0) ? 0x130 : 0xd0;
        return true;
    }
}

namespace TrafficNormalizer
{
    bool Install()
    {
        if (g_initialized) return true;

        InitializeCriticalSection(&g_grid_lock);
        g_grid_lock_ready = true;
        InitializeCriticalSection(&g_log_lock);
        g_log_lock_ready = true;

        g_enabled = (read_env_int("MOD_TRAFFIC_NORM_ENABLE", 1) != 0);
        g_cell_cm = static_cast<double>(read_env_int("MOD_TRAFFIC_CELL_CM", 25000));
        g_active_radius_cm = static_cast<double>(read_env_int("MOD_TRAFFIC_ACTIVE_RADIUS_CM", 100000));
        g_local_cap = read_env_int("MOD_TRAFFIC_LOCAL_CAP", 8);
        g_cap_radius_cm = static_cast<double>(read_env_int("MOD_TRAFFIC_CAP_RADIUS_CM", 40000));

        logf_file("init: enable=%d cell_cm=%.0f active_radius_cm=%.0f local_cap=%d cap_radius_cm=%.0f",
                  g_enabled ? 1 : 0, g_cell_cm, g_active_radius_cm, g_local_cap, g_cap_radius_cm);

        if (!g_enabled)
        {
            logf_file("disabled via MOD_TRAFFIC_NORM_ENABLE=0");
            g_initialized = true;
            return true;
        }

        uint8_t* base = nullptr;
        uint8_t* text = nullptr;
        size_t text_size = 0;
        if (!get_main_text_section(&base, &text, &text_size))
        {
            logf_file("ERROR: failed to locate .text section");
            return false;
        }

        // 1. Hook Nav_GetRandomRoadNode (cross-version AOB: 1 hit on 0.7.19 & 0.7.20)
        if (g_cell_cm > 0.0)
        {
            const uint8_t nav_anchor[] = {
                0x48, 0x85, 0xDB, 0x0F, 0x84, 0x00, 0x00, 0x00, 0x00,
                0x8B, 0x5B, 0x18, 0x85, 0xDB, 0x0F, 0x84, 0x00, 0x00, 0x00, 0x00
            };
            const char* nav_mask = "xxxxx????xxxxxxx????";
            auto hits = scan_aob(text, text_size, nav_anchor, nav_mask);

            uint8_t* nav_entry = nullptr;
            for (uint8_t* h : hits)
            {
                for (size_t back = 12; back <= 48 && h - back >= text; ++back)
                {
                    uint8_t* q = h - back;
                    if (q[0] == 0x48 && q[1] == 0x8B && q[2] == 0x99 && q[5] == 0x00 && q[6] == 0x00)
                    {
                        for (size_t b2 = 1; b2 <= 40 && q - b2 >= text; ++b2)
                        {
                            uint8_t* e = q - b2;
                            if (e[0] == 0x48 && e[1] == 0x8B && e[2] == 0xC4)
                            {
                                nav_entry = e;
                                break;
                            }
                        }
                        break;
                    }
                }
                if (nav_entry) break;
            }

            if (!nav_entry)
            {
                logf_file("ERROR: Nav_GetRandomRoadNode AOB not found (anchor hits=%zu)", hits.size());
            }
            else
            {
                extract_nav_offsets(nav_entry);
                void* orig_ptr = nullptr;
                if (install_inline_hook(&g_hook_nav, nav_entry, reinterpret_cast<void*>(&hook_nav_get_random_road_node), &orig_ptr))
                {
                    g_orig_nav = reinterpret_cast<NavGetRandomRoadNodeFn>(orig_ptr);
                    logf_file("Hook 1 OK: Nav_GetRandomRoadNode RVA=0x%llx graph_off=0x%x stride=0x%x pos_off=0x%x road_off=0x%x rflags_off=0x%x",
                              static_cast<unsigned long long>(nav_entry - base),
                              g_nav_graph_off, g_node_stride, g_node_pos_off, g_node_road_off, g_road_flags_off);
                }
                else
                {
                    logf_file("ERROR: failed to install Hook 1 at RVA=0x%llx",
                              static_cast<unsigned long long>(nav_entry - base));
                }
            }
        }

        // 2. Hook Traffic_CanMaterialize + locate GetAgentPosition (needed for LocalCap and/or live spawnSys pointer)
        if (g_local_cap > 0 || g_active_radius_cm > 0.0)
        {
            const uint8_t mat_pat[] = {
                0x48, 0x89, 0x5C, 0x24, 0x08, 0x48, 0x89, 0x6C, 0x24, 0x10, 0x48, 0x89, 0x74, 0x24, 0x18, 0x57,
                0x48, 0x81, 0xEC, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x29, 0x74, 0x24, 0x00, 0x48, 0x8B, 0xD9, 0x0F,
                0x29, 0x7C, 0x24, 0x00, 0x48, 0x83, 0xC1, 0x14, 0x44, 0x0F, 0x29, 0x44, 0x24, 0x00, 0x49, 0x8B,
                0xF8, 0x0F, 0xB6, 0xF2, 0xE8, 0x00, 0x00, 0x00, 0x00, 0x80, 0x7B, 0x24, 0x00, 0x0F, 0x84
            };
            const char* mat_mask =
                "xxxxxxxxxxxxxxxx"
                "xxx????xxxx?xxxx"
                "xxx?xxxxxxxxx?xx"
                "xxxxx????xxxxxx";

            // Cross-version GetAgentPosition AOB: byte 5 is 0x50 on 0.7.19, 0x40 on 0.7.20
            const uint8_t pos_pat[] = {
                0x40, 0x53, 0x48, 0x83, 0xEC, 0x00, 0x80, 0x79, 0x24, 0x00, 0x48, 0x8B, 0xDA, 0x74, 0x1A, 0x0F,
                0x10, 0x41, 0x28, 0x48, 0x8B, 0xC2, 0xF2, 0x0F, 0x10, 0x49, 0x38
            };
            const char* pos_mask = "xxxxx?xxxxxxxxxxxxxxxxxxxxx";

            auto mat_hits = scan_aob(text, text_size, mat_pat, mat_mask);
            auto pos_hits = scan_aob(text, text_size, pos_pat, pos_mask);

            if (mat_hits.size() != 1)
            {
                logf_file("ERROR: Traffic_CanMaterialize AOB hits=%zu (expected 1)", mat_hits.size());
            }
            else if (pos_hits.size() != 1)
            {
                logf_file("ERROR: GetAgentPosition AOB hits=%zu (expected 1)", pos_hits.size());
            }
            else
            {
                g_get_agent_pos = reinterpret_cast<GetAgentPositionFn>(pos_hits[0]);
                extract_agent_stride(mat_hits[0]);
                void* orig_ptr = nullptr;
                if (install_inline_hook(&g_hook_mat, mat_hits[0], reinterpret_cast<void*>(&hook_traffic_can_materialize), &orig_ptr))
                {
                    g_orig_mat = reinterpret_cast<TrafficCanMaterializeFn>(orig_ptr);
                    logf_file("Hook 2 OK: Traffic_CanMaterialize RVA=0x%llx GetAgentPosition RVA=0x%llx agent_stride=0x%x",
                              static_cast<unsigned long long>(mat_hits[0] - base),
                              static_cast<unsigned long long>(pos_hits[0] - base),
                              g_agent_stride);
                }
                else
                {
                    logf_file("ERROR: failed to install Hook 2 at RVA=0x%llx",
                              static_cast<unsigned long long>(mat_hits[0] - base));
                }
            }
        }

        g_initialized = true;
        return g_hook_nav.installed || g_hook_mat.installed;
    }

    void Uninstall()
    {
        if (!g_initialized) return;
        remove_inline_hook(&g_hook_nav);
        remove_inline_hook(&g_hook_mat);
        g_spawn_sys.store(nullptr, std::memory_order_release);
        g_orig_nav = nullptr;
        g_orig_mat = nullptr;
        g_get_agent_pos = nullptr;
        if (g_grid_lock_ready)
        {
            DeleteCriticalSection(&g_grid_lock);
            g_grid_lock_ready = false;
        }
        if (g_log_lock_ready)
        {
            DeleteCriticalSection(&g_log_lock);
            g_log_lock_ready = false;
        }
        g_initialized = false;
    }
}
