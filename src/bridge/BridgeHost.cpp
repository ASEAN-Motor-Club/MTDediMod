// BridgeHost.cpp — the Lua side of the native overlay bridge.
//
// Registered Lua globals (documented contract with OverlayBridge.lua):
//   RegisterBridgeHandler(fn)     -- fn(command_json_string); stored by
//                                    registry reference, invoked on the game
//                                    thread from the engine tick callback
//                                    (NEVER from the RHI/UI thread that
//                                    calls mt_bridge_submit).
//   PushBridgeState(json_string)  -- forwards to mt_bridge_set_state so the
//                                    Rust overlay can mt_bridge_get_state it
//                                    every frame.
//   PushBridgeEvent(name)         -- forwards to the ALREADY-LOADED
//                                    mt_overlay.dll via GetProcAddress
//                                    ("mt_overlay_event"); no-op (logged)
//                                    when the overlay is not loaded. The
//                                    call happens on the game thread, which
//                                    is where Lua runs.
//
// Dispatch is event-driven: mt_bridge_submit (any thread) → mutex queue →
// engine tick pre-callback drains the queue → Lua handler. No timers, no
// pipes, no 50 ms loop.

#include "BridgeHost.h"

#include <windows.h>

#include <atomic>
#include <string>

#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>
#include <LuaMadeSimple/LuaMadeSimple.hpp>
#include <Unreal/Hooks/Hooks.hpp>
#include <Unreal/UEngine.hpp>

#include "mt_bridge.h"

using namespace RC;
using namespace RC::Unreal;

namespace
{
    // The Lua state that called RegisterBridgeHandler and the registry
    // reference to its handler function. The state pointer is ONLY deref-
    // erenced from the game thread (tick callback) — Lua itself guarantees
    // that no other thread touches it.
    lua_State* g_lua = nullptr;
    int g_handler_ref = LUA_NOREF;
    std::atomic<bool> g_tick_registered{false};
    RC::Unreal::Hook::GlobalCallbackId g_tick_callback_id = RC::Unreal::Hook::ERROR_ID;

    // Commands are tiny JSON objects; 8 KiB is generous. Bound the drain so
    // a burst from the UI thread can never starve a frame.
    constexpr int kCommandBufferBytes = 8192;
    constexpr int kMaxDrainPerTick = 32;

    // ── mt_overlay.dll event forward ──────────────────────────────────────
    // mt_overlay.dll is loaded by Lua (package.loadlib "*"). Resolve the
    // export lazily; re-resolve the module every call so a hot-reloaded
    // overlay picks up automatically. Calling into the overlay from the game
    // thread is safe: mt_overlay_event only flips an atomic (documented
    // contract); it never touches D3D objects.
    using OverlayEventFn = void(__stdcall*)(const char* name, int len);

    void* g_overlay_proc = nullptr;
    HMODULE g_overlay_module = nullptr;

    bool forward_overlay_event(const std::string& name)
    {
        HMODULE mod = GetModuleHandleW(L"mt_overlay.dll");
        if (!mod)
        {
            Output::send<LogLevel::Verbose>(
                STR("[MTBridgeHost] PushBridgeEvent: mt_overlay.dll not loaded\\n"));
            return false;
        }
        if (!g_overlay_proc || mod != g_overlay_module)
        {
            g_overlay_module = mod;
            g_overlay_proc = reinterpret_cast<void*>(
                GetProcAddress(mod, "mt_overlay_event"));
            if (!g_overlay_proc)
            {
                Output::send<LogLevel::Warning>(
                    STR("[MTBridgeHost] mt_overlay.dll has no mt_overlay_event export\\n"));
                return false;
            }
        }
        auto fn = reinterpret_cast<OverlayEventFn>(g_overlay_proc);
        fn(name.c_str(), static_cast<int>(name.size()));
        return true;
    }

    // ── game-thread queue drain ───────────────────────────────────────────
    void DrainQueue()
    {
        if (!g_lua || g_handler_ref == LUA_NOREF) return;

        char buf[kCommandBufferBytes];
        for (int drained = 0; drained < kMaxDrainPerTick; ++drained)
        {
            int n = mt_bridge_internal_pop(buf, sizeof(buf));
            if (n <= 0) break; // 0 = queue empty; <0 = bad args/dropped
            if (n > static_cast<int>(sizeof(buf))) continue;

            lua_rawgeti(g_lua, LUA_REGISTRYINDEX, g_handler_ref);
            lua_pushlstring(g_lua, buf, static_cast<size_t>(n));
            // pcall, not a bare call: a Lua error inside the handler must
            // never longjmp through C++ frames (that would unwind past the
            // engine tick hook and kill the callback).
            if (lua_pcall(g_lua, 1, 0, 0) != LUA_OK)
            {
                const char* err = lua_tostring(g_lua, -1);
                Output::send<LogLevel::Error>(
                    STR("[MTBridgeHost] Lua bridge handler failed: {}\\n"),
                    to_wstring(err ? err : "unknown error"));
                lua_pop(g_lua, 1);
            }
        }
    }

    void RegisterTickHook()
    {
        if (g_tick_registered.exchange(true))
        {
            return; // already registered (double on_lua_start guard)
        }

        using namespace RC::Unreal::Hook;

        auto callback = [](TCallbackIterationData<void>&, UEngine*, float, bool) {
            DrainQueue();
        };

        g_tick_callback_id = RegisterEngineTickPreCallback(
            callback,
            FCallbackOptions{
                .bOnce = false,
                .bReadonly = true,
                .OwnerModName = STR("MTBridgeHost"),
                .HookName = STR("BridgeCommandDrain")
            }
        );

        if (g_tick_callback_id == ERROR_ID)
        {
            g_tick_registered = false;
            Output::send<LogLevel::Error>(
                STR("[MTBridgeHost] Failed to register engine tick drain hook\\n"));
            return;
        }

        Output::send<LogLevel::Verbose>(
            STR("[MTBridgeHost] engine tick drain registered (callback_id={})\\n"),
            g_tick_callback_id);
    }

    void UnregisterTickHook()
    {
        if (g_tick_registered.exchange(false) &&
            g_tick_callback_id != RC::Unreal::Hook::ERROR_ID)
        {
            RC::Unreal::Hook::UnregisterCallback(g_tick_callback_id);
            g_tick_callback_id = RC::Unreal::Hook::ERROR_ID;
        }
    }
} // namespace

MTDediBridgeHost::MTDediBridgeHost()
    : CppUserModBase()
{
    ModName = STR("MTBridgeHost");
    ModVersion = STR("1.0.0");
    ModDescription = STR("Native Lua<->overlay bridge host for MotorTownClientMod");
    ModAuthors = STR("ASEAN Motor Club");

    Output::send<LogLevel::Verbose>(STR("[{}] mod loaded\\n"), ModName);
}

MTDediBridgeHost::~MTDediBridgeHost()
{
    UnregisterTickHook();
    // Deliberately do NOT luaL_unref here: the Lua state that owns the
    // reference may already be gone (UE4SS destroys Lua before mod DLLs on
    // shutdown), and touching it would crash. The registry entry dies with
    // its state.
    g_handler_ref = LUA_NOREF;
    g_lua = nullptr;
}

auto MTDediBridgeHost::on_lua_start(
    LuaMadeSimple::Lua& lua,
    LuaMadeSimple::Lua& main_lua,
    LuaMadeSimple::Lua& async_lua,
    std::vector<LuaMadeSimple::Lua*>& hook_luas) -> void
{
    (void)main_lua;
    (void)async_lua;
    (void)hook_luas;

    RegisterTickHook();

    // RegisterBridgeHandler(fn)
    // Store the game-thread command dispatcher. Called ONCE by OverlayBridge
    // at init; a re-registration (hot reload of the Lua scripts on the same
    // state) replaces the previous reference.
    lua.register_function("RegisterBridgeHandler", [](const LuaMadeSimple::Lua& lua_net) -> int {
        lua_State* L = lua_net.get_lua_state();
        if (lua_gettop(L) < 1 || !lua_isfunction(L, -1))
        {
            lua_net.throw_error("RegisterBridgeHandler requires 1 argument: handler function");
        }
        // Unref a PREVIOUS handler only when it lives on the same state —
        // after a Lua reload the old state may already be destroyed, and
        // unref-ing through a dead lua_State is a crash.
        if (g_handler_ref != LUA_NOREF && g_lua == L)
        {
            luaL_unref(L, LUA_REGISTRYINDEX, g_handler_ref);
        }
        g_handler_ref = static_cast<int>(luaL_ref(L, LUA_REGISTRYINDEX)); // pops the function
        g_lua = L;
        Output::send<LogLevel::Verbose>(
            STR("[MTBridgeHost] Lua bridge handler registered (ref={})\\n"), g_handler_ref);
        lua_net.set_bool(true);
        return 1;
    });

    // PushBridgeState(json_string) → mt_bridge_set_state
    lua.register_function("PushBridgeState", [](const LuaMadeSimple::Lua& lua_net) -> int {
        if (lua_net.get_stack_size() < 2)
        {
            lua_net.throw_error("PushBridgeState requires 1 argument: json string");
        }
        std::string state_json = std::string(lua_net.get_string());
        int rc = mt_bridge_set_state(state_json.data(), static_cast<int>(state_json.size()));
        lua_net.set_bool(rc == 0);
        return 1;
    });

    // PushBridgeEvent(name) → mt_overlay.dll!mt_overlay_event(name, len)
    lua.register_function("PushBridgeEvent", [](const LuaMadeSimple::Lua& lua_net) -> int {
        if (lua_net.get_stack_size() < 2)
        {
            lua_net.throw_error("PushBridgeEvent requires 1 argument: event name");
        }
        std::string name = std::string(lua_net.get_string());
        bool ok = forward_overlay_event(name);
        lua_net.set_bool(ok);
        return 1;
    });

#ifdef MT_BRIDGE_ADMIN
    Output::send<LogLevel::Verbose>(STR("[MTBridgeHost] admin build\\n"));
#endif

    Output::send<LogLevel::Verbose>(STR("[MTBridgeHost] bridge Lua functions registered\\n"));
}
