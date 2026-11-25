#include "TickProfiler.h"
#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>

// Workaround against multiple check definitions
#pragma push_macro("check")
#undef check
#include <windows.h>
#pragma pop_macro("check")

#include <cstdio>
#include <cstring>
#include <ctime>
#include <fstream>
#include <string>

using namespace RC;

TickProfiler& TickProfiler::Get()
{
	static TickProfiler instance;
	return instance;
}

int TickProfiler::GetOpenFdCount()
{
	// Under Wine/Proton, the Linux /proc filesystem is mapped to Z:\proc.
	// Enumerate Z:\proc\self\fd to count open file descriptors.
	// This is critical because Wine's socket layer uses select() which
	// aborts when fd >= FD_SETSIZE (1024).
	int count = 0;
	WIN32_FIND_DATAA findData;
	HANDLE hFind = FindFirstFileA("Z:\\proc\\self\\fd\\*", &findData);
	if (hFind == INVALID_HANDLE_VALUE)
	{
		// Fallback: try the Linux path directly (for native Linux builds)
		hFind = FindFirstFileA("/proc/self/fd/*", &findData);
		if (hFind == INVALID_HANDLE_VALUE) return -1;
	}
	do {
		++count;
	} while (FindNextFileA(hFind, &findData));
	FindClose(hFind);
	// Subtract . and .. directory entries
	return count >= 2 ? count - 2 : count;
}

std::string TickProfiler::GetFdLimitString()
{
	// Try Wine-mapped path first, then native Linux path.
	const char* paths[] = {"Z:\\proc\\self\\limits", "/proc/self/limits"};
	for (const char* path : paths)
	{
		std::ifstream limits(path);
		if (limits.is_open())
		{
			std::string line;
			while (std::getline(limits, line))
			{
				if (line.find("Max open files") != std::string::npos)
				{
					return line;
				}
			}
		}
	}
	return "unknown";
}

void TickProfiler::Start()
{
	if (m_started.exchange(true))
		return;

	using namespace RC::Unreal::Hook;

	// Pre-tick hook: non-readonly so it runs before the readonly hooks
	// (LuaHttpServer, LocationSampler).  Records tick start time and
	// resets per-tick mod accumulators.
	auto pre_cb = [this](TCallbackIterationData<void>&, RC::Unreal::UEngine*, float, bool) {
		OnPreTick();
	};
	m_pre_tick_id = RegisterEngineTickPreCallback(
		pre_cb,
		FCallbackOptions{
			.bOnce = false,
			.bReadonly = false, // run BEFORE readonly hooks
			.OwnerModName = STR("MotorTownMods"),
			.HookName = STR("TickProfilerPre")
		}
	);

	// Post-tick hook: runs after UEngine::Tick and all post-callbacks.
	auto post_cb = [this](TCallbackIterationData<void>&, RC::Unreal::UEngine*, float, bool) {
		OnPostTick();
	};
	m_post_tick_id = RegisterEngineTickPostCallback(
		post_cb,
		FCallbackOptions{
			.bOnce = false,
			.bReadonly = false,
			.OwnerModName = STR("MotorTownMods"),
			.HookName = STR("TickProfilerPost")
		}
	);

	if (m_pre_tick_id == ERROR_ID || m_post_tick_id == ERROR_ID)
	{
		Output::send<LogLevel::Error>(
			STR("[TickProfiler] Failed to register tick hooks (pre={}, post={})\n"),
			m_pre_tick_id, m_post_tick_id);
		m_started = false;
		return;
	}

	// Background hang watchdog (safe to start after hooks registered).
	StartWatchdog();

	Output::send<LogLevel::Verbose>(
		STR("[TickProfiler] Started (pre={}, post={}, window={} ticks)\n"),
		m_pre_tick_id, m_post_tick_id, WINDOW_SIZE);
}

void TickProfiler::Stop()
{
	if (!m_started.exchange(false))
		return;

	// Stop the watchdog FIRST so it cannot capture against unregistered hooks.
	StopWatchdog();

	if (m_pre_tick_id != RC::Unreal::Hook::ERROR_ID)
	{
		RC::Unreal::Hook::UnregisterCallback(m_pre_tick_id);
		m_pre_tick_id = RC::Unreal::Hook::ERROR_ID;
	}
	if (m_post_tick_id != RC::Unreal::Hook::ERROR_ID)
	{
		RC::Unreal::Hook::UnregisterCallback(m_post_tick_id);
		m_post_tick_id = RC::Unreal::Hook::ERROR_ID;
	}

	// Flush remaining window.
	if (m_window_idx > 0)
		LogSummary();
}

void TickProfiler::ReportModTime(Component comp, int64_t us)
{
	m_mod_us[comp] += us;
}

void TickProfiler::OnPreTick()
{
	m_tick_start = std::chrono::steady_clock::now();

	// Hang-watchdog heartbeat (~3 relaxed atomic stores, nanoseconds/tick).
	uint32_t expected_tid = 0;
	if (m_game_thread_id.compare_exchange_strong(expected_tid, GetCurrentThreadId(),
			std::memory_order_relaxed) && expected_tid != 0)
	{
		// A different game thread took over (should not happen) — keep the new id.
	}
	m_in_tick.store(true, std::memory_order_release);
	m_last_tick_ms.store(
		std::chrono::duration_cast<std::chrono::milliseconds>(
			m_tick_start.time_since_epoch()).count(),
		std::memory_order_relaxed);

	// Reset per-tick accumulators.
	for (int i = 0; i < COMP_COUNT; ++i)
		m_mod_us[i] = 0;
}

void TickProfiler::OnPostTick()
{
	auto now = std::chrono::steady_clock::now();
	int64_t tick_us = std::chrono::duration_cast<std::chrono::microseconds>(
		now - m_tick_start).count();

	// Hang-watchdog heartbeat: tick completed.
	m_in_tick.store(false, std::memory_order_release);
	m_last_tick_ms.store(
		std::chrono::duration_cast<std::chrono::milliseconds>(
			now.time_since_epoch()).count(),
		std::memory_order_relaxed);
	m_tick_seq.fetch_add(1, std::memory_order_relaxed);

	m_w_total_tick_us += tick_us;
	if (tick_us > m_w_max_tick_us)
		m_w_max_tick_us = tick_us;
	if (tick_us > BUDGET_US)
		++m_w_over_budget;

	for (int i = 0; i < COMP_COUNT; ++i)
	{
		m_w_mod_us[i] += m_mod_us[i];
		if (m_mod_us[i] > 0)
			++m_w_mod_calls[i];
	}

	if (++m_window_idx >= WINDOW_SIZE)
	{
		LogSummary();
		// Reset window.
		m_window_idx = 0;
		m_w_total_tick_us = 0;
		m_w_max_tick_us = 0;
		m_w_over_budget = 0;
		for (int i = 0; i < COMP_COUNT; ++i)
		{
			m_w_mod_us[i] = 0;
			m_w_mod_calls[i] = 0;
		}
	}
}

// ===========================================================================
// HangWatchdog
//
// Detects GameThread stalls >= MOD_HANG_WATCHDOG_MS (default 5000; 0 = off)
// from a background thread and captures module+0xRVA stack traces.
//
// CRITICAL DEADLOCK SAFETY (Wine/Proton):
//   While the GameThread is suspended (SuspendThread -> ResumeThread) we call
//   ONLY GetThreadContext and ReadProcessMemory into buffers that were
//   allocated BEFORE the suspend.  Zero heap allocation, zero logging, zero
//   VirtualQuery/DbgHelp/Output::send while suspended — any of those could
//   take a lock the suspended GameThread holds and deadlock the server.
//   Module resolution, unwinding and all I/O happen strictly AFTER
//   ResumeThread.
// ===========================================================================

namespace {

// Capture schedule per stall: 5 s, 15 s, 30 s, 60 s (max 4 snapshots).
constexpr int64_t kCaptureThresholdsMs[4] = {5000, 15000, 30000, 60000};
constexpr SIZE_T kStackCaptureBytes = 16 * 1024;

int64_t steady_now_ms()
{
	return std::chrono::duration_cast<std::chrono::milliseconds>(
		std::chrono::steady_clock::now().time_since_epoch()).count();
}

// ntdll Rtl* unwind helpers, resolved dynamically so nothing extra needs
// linking (works identically under real Windows and Wine/Proton).
typedef PVOID (*RtlLookupFunctionEntry_t)(DWORD64 ControlPc, PDWORD64 ImageBase,
	PVOID HistoryTable);
typedef PVOID (*RtlVirtualUnwind_t)(ULONG HandlerType, DWORD64 ImageBase,
	DWORD64 ControlPc, PVOID FunctionEntry, PCONTEXT Context,
	PULONG* HandlerData, PDWORD64 EstablisherFrame, PVOID ContextPointers);

struct RtlFns
{
	RtlLookupFunctionEntry_t lookup = nullptr;
	RtlVirtualUnwind_t unwind = nullptr;
};

RtlFns LoadRtlFns()
{
	RtlFns f;
	HMODULE ntdll = GetModuleHandleA("ntdll.dll");
	if (ntdll)
	{
		f.lookup = reinterpret_cast<RtlLookupFunctionEntry_t>(
			reinterpret_cast<void*>(GetProcAddress(ntdll, "RtlLookupFunctionEntry")));
		f.unwind = reinterpret_cast<RtlVirtualUnwind_t>(
			reinterpret_cast<void*>(GetProcAddress(ntdll, "RtlVirtualUnwind")));
	}
	return f;
}

// POD capture result — filled by the SEH-protected unwind core, consumed
// (and stringified) afterwards by the logging path.
struct HangFrame
{
	uint64_t pc;
	wchar_t text[96]; // "module.dll+0x1234"
};

struct HangCapture
{
	int frame_count = 0;
	HangFrame frames[32] = {};
	uint64_t rip = 0;
	uint64_t rsp = 0;
	bool context_ok = false;
	bool stack_ok = false;
};

// Resolve a PC into "basename+0xRVA".  Must ONLY be called with the GameThread
// RUNNING (after ResumeThread): VirtualQuery + GetModuleFileNameA are not
// suspend-safe here.
void ResolvePC(uint64_t pc, wchar_t* out, size_t out_len)
{
	MEMORY_BASIC_INFORMATION mbi = {};
	if (!VirtualQuery(reinterpret_cast<LPCVOID>(pc), &mbi, sizeof(mbi)) ||
		!mbi.AllocationBase)
	{
		_snwprintf(out, out_len, L"?+0x%llx", static_cast<unsigned long long>(pc));
		return;
	}
	char modpath[MAX_PATH + 1] = {};
	if (!GetModuleFileNameA(reinterpret_cast<HMODULE>(mbi.AllocationBase),
			modpath, MAX_PATH))
	{
		_snwprintf(out, out_len, L"?+0x%llx", static_cast<unsigned long long>(pc));
		return;
	}
	const char* base = modpath;
	for (const char* p = modpath; *p; ++p)
		if (*p == '\\' || *p == '/')
			base = p + 1;
	const unsigned long long rva =
		pc - reinterpret_cast<unsigned long long>(mbi.AllocationBase);
	wchar_t wide[MAX_PATH + 1] = {};
	size_t i = 0;
	for (; base[i] && i < MAX_PATH; ++i)
		wide[i] = static_cast<wchar_t>(static_cast<unsigned char>(base[i]));
	wide[i] = L'\0';
	_snwprintf(out, out_len, L"%s+0x%llx", wide,
		static_cast<unsigned long long>(rva));
}

// Unwind up to 32 frames from the COPIED context/stack buffer.  PODs only and
// SEH-guarded so a wild PC can never take the server down.  Called strictly
// AFTER the GameThread has been resumed.
//
// Note on fidelity: RtlVirtualUnwind pops return addresses from the stack at
// Context.Rsp.  Above the suspended thread's own Rsp the caller frames are
// unchanged by resumption (the thread only pushes below its Rsp), so unwinding
// the copied register state yields the frozen frame chain; the leaf-fallback
// pop below reads strictly from the copied 16 KB buffer.
bool __try_unwind_core(PCONTEXT ctx, const uint8_t* stack, SIZE_T stack_bytes,
	HangCapture* out)
{
	__try
	{
		RtlFns rtl = LoadRtlFns();
		if (!rtl.lookup || !rtl.unwind)
			return false;

		out->rip = ctx->Rip;
		out->rsp = ctx->Rsp;
		out->context_ok = true;
		out->stack_ok = stack != nullptr && stack_bytes >= 16;

		const uint64_t stack_lo = ctx->Rsp;
		const uint64_t stack_hi = ctx->Rsp + stack_bytes;
		CONTEXT c = *ctx;

		for (int frame = 0; frame < 32; ++frame)
		{
			const uint64_t pc = c.Rip;
			if (pc == 0)
				break;

			HangFrame& f = out->frames[out->frame_count];
			f.pc = pc;
			ResolvePC(pc, f.text, sizeof(f.text) / sizeof(f.text[0]));
			++out->frame_count;

			DWORD64 imgbase = 0;
			PVOID entry = rtl.lookup(pc, &imgbase, nullptr);
			if (entry)
			{
				ULONG* handler_data = nullptr;
				DWORD64 establisher_frame = 0;
				rtl.unwind(0 /* UNW_FLAG_NHANDLER */, imgbase, pc, entry, &c,
					&handler_data, &establisher_frame, nullptr);
			}
			else
			{
				// Leaf function (or no unwind info): the return address sits
				// at [Rsp] — read it strictly from the COPIED stack buffer.
				if (c.Rsp < stack_lo || c.Rsp + 8 > stack_hi)
					break;
				uint64_t ret = 0;
				std::memcpy(&ret, stack + (c.Rsp - stack_lo), 8);
				if (ret == 0)
					break;
				c.Rip = ret;
				c.Rsp += 8;
			}
			if (c.Rip == pc)
				break; // no progress — stop rather than loop forever
		}
		return true;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		return false;
	}
}

// SEH cannot wrap functions with unwinding objects, hence the tiny wrapper.
bool UnwindCopy(const CONTEXT& ctx, const uint8_t* stack, SIZE_T stack_bytes,
	HangCapture* out)
{
	return __try_unwind_core(const_cast<PCONTEXT>(&ctx), stack, stack_bytes, out);
}

// Persistent trace file: <game_root>/MotorTown/Saved/ServerLog/hang_traces.log
// Derived from GetModuleFileNameA(NULL) so it is independent of the CWD.
std::string& TraceFilePath()
{
	static std::string path;
	return path;
}

void InitTraceFilePath()
{
	char exe[MAX_PATH + 1] = {};
	if (GetModuleFileNameA(nullptr, exe, MAX_PATH) == 0)
		return;
	std::string dir(exe);
	size_t slash = dir.find_last_of("\\/");
	if (slash == std::string::npos)
		return;
	dir.resize(slash);
	const char* components[] = {"MotorTown", "Saved", "ServerLog"};
	std::string accum = dir;
	for (const char* comp : components)
	{
		accum += "\\";
		accum += comp;
		CreateDirectoryA(accum.c_str(), nullptr);
	}
	TraceFilePath() = accum + "\\hang_traces.log";
}

// UTC timestamp prefix for the trace file.
void UtcTimestamp(char* out, size_t len)
{
	time_t t = time(nullptr);
	tm tmv = {};
#ifdef _WIN32
	gmtime_s(&tmv, &t);
#else
	gmtime_r(&t, &tmv);
#endif
	strftime(out, len, "%Y-%m-%dT%H:%M:%SZ", &tmv);
}

// Narrow -> wide (module paths are ASCII; any byte >=128 becomes '?').
std::wstring Widen(const std::string& s)
{
	std::wstring w;
	w.reserve(s.size());
	for (char c : s)
		w.push_back(static_cast<unsigned char>(c) < 128 ? static_cast<wchar_t>(c) : L'?');
	return w;
}

} // namespace

void TickProfiler::StartWatchdog()
{
	char buf[32] = {};
	DWORD n = GetEnvironmentVariableA("MOD_HANG_WATCHDOG_MS", buf, sizeof(buf));
	int64_t threshold = 5000;
	if (n > 0 && n < sizeof(buf))
	{
		char* end = nullptr;
		long long v = strtoll(buf, &end, 10);
		if (end != buf && *end == '\0' && v >= 0)
			threshold = v;
	}
	m_hang_threshold_ms.store(threshold, std::memory_order_relaxed);

	InitTraceFilePath();

	if (threshold == 0)
	{
		Output::send<LogLevel::Verbose>(
			STR("[HangWatchdog] Disabled (MOD_HANG_WATCHDOG_MS=0)\n"));
		return;
	}

	m_watchdog_stop.store(false, std::memory_order_relaxed);
	m_watchdog_thread = std::thread([this] { WatchdogLoop(); });

	Output::send<LogLevel::Verbose>(
		STR("[HangWatchdog] Started (threshold={}ms, trace={})\n"),
		static_cast<int64_t>(threshold), Widen(TraceFilePath()));
}

void TickProfiler::StopWatchdog()
{
	m_watchdog_stop.store(true, std::memory_order_relaxed);
	if (m_watchdog_thread.joinable())
		m_watchdog_thread.join();
}

void TickProfiler::WatchdogLoop()
{
	uint64_t last_captured_seq = 0;
	int stage = 0; // index into kCaptureThresholdsMs

	while (!m_watchdog_stop.load(std::memory_order_relaxed))
	{
		Sleep(500);
		if (m_watchdog_stop.load(std::memory_order_relaxed))
			break;

		const int64_t threshold = m_hang_threshold_ms.load(std::memory_order_relaxed);
		if (threshold <= 0)
			continue;
		if (m_game_thread_id.load(std::memory_order_relaxed) == 0)
			continue; // never saw a tick yet

		const uint64_t seq = m_tick_seq.load(std::memory_order_relaxed);
		if (seq != last_captured_seq)
			stage = 0; // ticks resumed since the last capture — new stall budget

		const int64_t stalled_ms = steady_now_ms() - m_last_tick_ms.load(std::memory_order_relaxed);
		if (stalled_ms < threshold)
			continue;
		if (stage >= 4)
			continue;
		if (stalled_ms < kCaptureThresholdsMs[stage])
			continue;

		const bool in_tick = m_in_tick.load(std::memory_order_relaxed);
		CaptureGameThreadStack(stalled_ms, in_tick);

		last_captured_seq = m_tick_seq.load(std::memory_order_relaxed);
		++stage;
	}
}

void TickProfiler::CaptureGameThreadStack(int64_t stalled_ms, bool in_tick)
{
	const uint32_t tid = m_game_thread_id.load(std::memory_order_relaxed);
	if (tid == 0)
		return;

	// Capture buffers, allocated ONCE up front so nothing is allocated while
	// the GameThread is suspended.
	static CONTEXT s_ctx = {};
	static uint8_t s_stack[kStackCaptureBytes];
	s_ctx.ContextFlags = 0;
	std::memset(s_stack, 0, sizeof(s_stack));

	HANDLE hThread = OpenThread(THREAD_SUSPEND_RESUME | THREAD_GET_CONTEXT |
		THREAD_QUERY_INFORMATION, FALSE, tid);
	if (!hThread)
	{
		Output::send<LogLevel::Error>(
			STR("[HangWatchdog] OpenThread({}) failed gle={} stall={}ms in_tick={}\n"),
			tid, GetLastError(), stalled_ms, in_tick);
		return;
	}

	// ---- SUSPENDED WINDOW: ONLY these two calls, then resume. ----
	if (SuspendThread(hThread) == static_cast<DWORD>(-1))
	{
		CloseHandle(hThread);
		return;
	}
	s_ctx.ContextFlags = CONTEXT_CONTROL | CONTEXT_INTEGER;
	const BOOL ctx_ok = GetThreadContext(hThread, &s_ctx);
	SIZE_T got = 0;
	const BOOL stack_ok = ctx_ok && ReadProcessMemory(GetCurrentProcess(),
		reinterpret_cast<LPCVOID>(s_ctx.Rsp), s_stack, sizeof(s_stack), &got) &&
		got > 0;
	ResumeThread(hThread);
	CloseHandle(hThread);
	// ---- GameThread is running again; everything below is unrestricted. ----

	if (!ctx_ok)
	{
		Output::send<LogLevel::Error>(
			STR("[HangWatchdog] GetThreadContext failed gle={} stall={}ms in_tick={}\n"),
			GetLastError(), stalled_ms, in_tick);
		return;
	}

	HangCapture capture;
	const bool unwound = UnwindCopy(s_ctx, stack_ok ? s_stack : nullptr,
		stack_ok ? got : 0, &capture);

	// Build the log text.
	std::wstring trace = STR("[HangWatchdog] GameThread stall");
	trace += STR(" stall=") + std::to_wstring(stalled_ms) + L"ms";
	trace += STR(" in_tick=") + std::to_wstring(in_tick ? 1 : 0);
	trace += STR(" tid=") + std::to_wstring(tid);
	trace += STR(" rip=0x") + [&] {
		wchar_t tmp[32];
		_snwprintf(tmp, 32, L"%llx", static_cast<unsigned long long>(capture.rip));
		return std::wstring(tmp);
	}();
	if (!unwound)
		trace += STR(" (unwind unavailable)");
	for (int i = 0; i < capture.frame_count; ++i)
	{
		wchar_t idx[8];
		_snwprintf(idx, 8, L"%02d", i);
		trace += STR("\n  #") + std::wstring(idx) + L" " + capture.frames[i].text;
	}
	if (capture.frame_count == 0 && unwound)
		trace += STR("\n  (no frames resolved)");

	// UE4SS.log via Output::send — safe now, GameThread is running.
	Output::send<LogLevel::Error>(STR("{}\n"), trace);

	// Persistent append-only file (survives restarts).
	const std::string& path = TraceFilePath();
	if (!path.empty())
	{
		std::ofstream file(path, std::ios::app | std::ios::binary);
		if (file.is_open())
		{
			char ts[40] = {};
			UtcTimestamp(ts, sizeof(ts));
			std::string narrow;
			narrow.reserve(trace.size());
			for (wchar_t wc : trace)
				narrow.push_back(wc >= 0 && wc < 128 ? static_cast<char>(wc) : '?');
			file << ts << ' ' << narrow << '\n';
		}
	}
}
