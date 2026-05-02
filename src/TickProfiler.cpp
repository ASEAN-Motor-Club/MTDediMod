#include "TickProfiler.h"
#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>

// Workaround against multiple check definitions
#pragma push_macro("check")
#undef check
#include <windows.h>
#pragma pop_macro("check")

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

	Output::send<LogLevel::Verbose>(
		STR("[TickProfiler] Started (pre={}, post={}, window={} ticks)\n"),
		m_pre_tick_id, m_post_tick_id, WINDOW_SIZE);
}

void TickProfiler::Stop()
{
	if (!m_started.exchange(false))
		return;

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
	// Reset per-tick accumulators.
	for (int i = 0; i < COMP_COUNT; ++i)
		m_mod_us[i] = 0;
}

void TickProfiler::OnPostTick()
{
	auto now = std::chrono::steady_clock::now();
	int64_t tick_us = std::chrono::duration_cast<std::chrono::microseconds>(
		now - m_tick_start).count();

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

// Format integer milliseconds with one decimal from microseconds.
// e.g. 12345 us -> "12.3"
static std::wstring ms_fmt(int64_t us)
{
	int whole = static_cast<int>(us / 1000);
	int frac = static_cast<int>((us % 1000) / 100);
	return std::to_wstring(whole) + L"." + std::to_wstring(frac);
}

void TickProfiler::LogSummary()
{
	int ticks = m_window_idx;
	if (ticks == 0) return;

	// All values in microseconds — convert to display strings.
	int64_t avg_tick_us = m_w_total_tick_us / ticks;
	int64_t max_tick_us = m_w_max_tick_us;
	int over_pct = static_cast<int>((m_w_over_budget * 100) / ticks);

	// Component breakdown.
	int64_t total_mod_us = 0;
	for (int i = 0; i < COMP_COUNT; ++i)
		total_mod_us += m_w_mod_us[i];
	int64_t avg_mod_us = total_mod_us / ticks;
	int64_t unaccounted_us = m_w_total_tick_us - total_mod_us;
	int64_t avg_unaccounted_us = unaccounted_us / ticks;

	const wchar_t* comp_names[COMP_COUNT] = {L"LuaHttp", L"Location", L"UFuncHooks"};

	Output::send<LogLevel::Warning>(
		STR("[TickProfiler] {} ticks: avg={}ms max={}ms over_33ms={} ({}%)\n"),
		ticks, ms_fmt(avg_tick_us), ms_fmt(max_tick_us), m_w_over_budget, over_pct);

	Output::send<LogLevel::Warning>(
		STR("[TickProfiler]   mod_total={}ms avg={}ms/tick ({}={}ms/{} {}={}ms/{} {}={}ms/{})\n"),
		ms_fmt(total_mod_us), ms_fmt(avg_mod_us),
		comp_names[0], ms_fmt(m_w_mod_us[0]), m_w_mod_calls[0],
		comp_names[1], ms_fmt(m_w_mod_us[1]), m_w_mod_calls[1],
		comp_names[2], ms_fmt(m_w_mod_us[2]), m_w_mod_calls[2]);

	Output::send<LogLevel::Warning>(
		STR("[TickProfiler]   unaccounted={}ms avg={}ms/tick (engine+UE4SS)\n"),
		ms_fmt(unaccounted_us), ms_fmt(avg_unaccounted_us));

	// --- File descriptor monitoring ---
	// Log fd count every window (~10s). Warn at 80% of FD_SETSIZE (1024).
	// The Wine/Proton socket layer uses select() which fails at fd >= 1024.
	int fd_count = GetOpenFdCount();
	if (fd_count >= 0)
	{
		constexpr int FD_SETSIZE_WARN = 820;   // ~80% of 1024
		constexpr int FD_SETSIZE_CRIT = 950;    // ~93% of 1024

		if (fd_count >= FD_SETSIZE_CRIT)
		{
			Output::send<LogLevel::Error>(
				STR("[TickProfiler]   ⚠ FD CRITICAL: {} open fds (Wine select() limit: 1024)\n"),
				fd_count);
		}
		else if (fd_count >= FD_SETSIZE_WARN)
		{
			Output::send<LogLevel::Warning>(
				STR("[TickProfiler]   ⚠ FD WARNING: {} open fds (Wine select() limit: 1024)\n"),
				fd_count);
		}
		else
		{
			Output::send<LogLevel::Warning>(
				STR("[TickProfiler]   fds={}\n"),
				fd_count);
		}
	}

	// Log fd limits once (first window only).
	static bool logged_fd_limits = false;
	if (!logged_fd_limits)
	{
		auto limits = GetFdLimitString();
		Output::send<LogLevel::Warning>(
			STR("[TickProfiler]   {}\n"),
			to_wstring(limits));
		logged_fd_limits = true;
	}
}
