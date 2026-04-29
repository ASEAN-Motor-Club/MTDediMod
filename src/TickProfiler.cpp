#include "TickProfiler.h"
#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>

using namespace RC;

TickProfiler& TickProfiler::Get()
{
	static TickProfiler instance;
	return instance;
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
}
