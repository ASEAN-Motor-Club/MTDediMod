#pragma once

#include <Unreal/Hooks/Hooks.hpp>
#include <atomic>
#include <chrono>
#include <cstdint>
#include <string>
#include <thread>

// Lightweight game-thread tick profiler.
//
// Registers a pre-tick and post-tick engine hook to measure total wall-clock
// tick time.  Other components (LuaHttpServer, LocationSampler, HookManager)
// report their own execution time via ReportModTime().  The profiler
// aggregates over a sliding window and logs a summary every WINDOW_SIZE ticks.
//
// The game-thread state (tick start, mod accumulators, window aggregates) is
// accessed exclusively from the game thread — no locks needed.  The HangWatchdog
// heartbeat fields below are the only cross-thread state: written on the game
// thread, read from the background watchdog thread, all via atomics.
class TickProfiler
{
public:
	static TickProfiler& Get();

	void Start();
	void Stop();

	// Called by LuaHttpServer, LocationSampler, and UFunction hooks to
	// accumulate per-component mod time within the current tick.
	// |us| is the elapsed microseconds of the component.
	enum Component : int { COMP_HTTP = 0, COMP_LOCATION = 1, COMP_UFUNCTION = 2, COMP_COUNT };
	void ReportModTime(Component comp, int64_t us);

	// RAII scoped timer — reports elapsed time to the profiler on destruction.
	struct ScopedTimer
	{
		std::chrono::steady_clock::time_point start;
		Component comp;
		explicit ScopedTimer(Component c)
			: start(std::chrono::steady_clock::now()), comp(c) {}
		~ScopedTimer()
		{
			auto us = std::chrono::duration_cast<std::chrono::microseconds>(
				std::chrono::steady_clock::now() - start).count();
			Get().ReportModTime(comp, us);
		}
		ScopedTimer(const ScopedTimer&) = delete;
		ScopedTimer& operator=(const ScopedTimer&) = delete;
	};

	// Return current open fd count for this process (reads /proc/self/fd).
	// Returns -1 on error.
	static int GetOpenFdCount();

	// Return a brief string describing the process's fd limit (from /proc/self/limits).
	static std::string GetFdLimitString();

private:
	TickProfiler() = default;

	void OnPreTick();
	void OnPostTick();
	void LogSummary();

	// --- Hang watchdog ---
	// Detects GameThread stalls (>= MOD_HANG_WATCHDOG_MS, default 5000 ms; 0
	// disables) from a background thread and captures module+0xRVA stack
	// traces of the GameThread.  Capture safety: while the GameThread is
	// suspended, ONLY GetThreadContext + ReadProcessMemory into pre-allocated
	// buffers run (zero heap allocation, zero logging, zero VirtualQuery /
	// DbgHelp); module resolution, unwinding and all I/O happen after the
	// thread is resumed.  Rate-limited to 4 snapshots per stall (5/15/30/60 s).
	void StartWatchdog();
	void StopWatchdog();
	void WatchdogLoop();
	void CaptureGameThreadStack(int64_t stalled_ms, bool in_tick);

	std::atomic<bool> m_started{false};
	uint64_t m_pre_tick_id = RC::Unreal::Hook::ERROR_ID;
	uint64_t m_post_tick_id = RC::Unreal::Hook::ERROR_ID;

	// Current tick start (set in pre-tick, read in post-tick).
	std::chrono::steady_clock::time_point m_tick_start;

	// Per-tick mod time accumulators (reset in OnPreTick).
	int64_t m_mod_us[COMP_COUNT] = {};

	// Aggregation window.
	static constexpr int WINDOW_SIZE = 300; // ~10 s at 30 Hz
	static constexpr int64_t BUDGET_US = 33333; // 33.3 ms = 30 Hz budget

	int m_window_idx = 0;

	// Per-window accumulators.
	int64_t m_w_total_tick_us = 0;
	int64_t m_w_max_tick_us = 0;
	int m_w_over_budget = 0;
	int64_t m_w_mod_us[COMP_COUNT] = {};
	int m_w_mod_calls[COMP_COUNT] = {};

	// Watchdog heartbeat state (written on game thread, read on watchdog thread).
	std::atomic<uint32_t> m_game_thread_id{0};
	std::atomic<int64_t>  m_last_tick_ms{0};     // steady_clock ms since epoch
	std::atomic<bool>     m_in_tick{false};      // true between OnPreTick and OnPostTick
	std::atomic<uint64_t> m_tick_seq{0};         // monotonic tick counter
	std::atomic<bool>     m_watchdog_stop{false};
	std::atomic<int64_t>  m_hang_threshold_ms{5000}; // MOD_HANG_WATCHDOG_MS (0 = disabled)
	std::thread           m_watchdog_thread;
};
