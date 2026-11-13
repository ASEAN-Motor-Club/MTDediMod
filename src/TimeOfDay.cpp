// TimeOfDay — the one supported way to read or set the Motor Town world clock.
//
// WHY NATIVE
// ----------
// The world hour is a plain C++ float on a clock-owner object. It has no
// UPROPERTY (nothing in the ~900-file type dump exposes a live clock), so every
// reflected route is dead:
//   - no SetTimeOfDay UFUNCTION,
//   - FMTSaveGameWorld.TimeOfDay is a save struct with no owning object,
//   - AMTTimeOfDayConfig governs the boot hour only (a runtime-spawned config
//     actor is stored but inert: writes read back and the clock ignores them),
//   - the Cheat_TimeOfDay / Cheat_TimeOfDaySpeed family does nothing on a dedi,
//   - MTSunSky.SolarTime is a per-frame mirror of the clock: writing it is
//     overwritten within 200 ms.
//
// THE CHAIN (live-verified on the shuto build, 2026-11-13)
// --------------------------------------------------------
//   GetTimeOfDay wrapper   rva 0x4a40b30
//     call 0x144c154f0                       ; clock getter
//   clock getter           rva 0x4c154f0
//     call 0x144bc3ee0                       ; owner = resolve(world_context)
//     movss xmm0,[rax + <field>]             ; the world hour
//
// Writing that float holds and the clock runs forward from the new hour
// (measured: wrote 22.0 into a 10.041 clock -> +1 s = 22.008 -> reflected
// GetTimeOfDay = 22.74 and climbing).
//
// GUARDS
// ------
// The two RVAs are per game build. Before anything is read or written the getter
// prologue is compared against known bytes; the field displacement is then
// *derived* by scanning that getter for the movss, so a patch that only moves the
// field still works. On any mismatch every function returns an error string and
// nothing is written — a wrong build must fail loudly, never corrupt the clock.

#define NOMINMAX
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include <cstdint>
#include <cstdio>
#include <cstring>
#include <string>

#include <DynamicOutput/DynamicOutput.hpp>
#include <Unreal/UObject.hpp>
#include <Unreal/UObjectGlobals.hpp>

#include "TimeOfDay.h"

using namespace RC;
using namespace RC::Unreal;

namespace
{
	// Per-build anchors.
	constexpr uintptr_t kRvaClockGetter = 0x4c154f0;
	constexpr uintptr_t kRvaResolveOwner = 0x4bc3ee0;

	// sub rsp,0x28 / call rel32  (the rest of the prologue is not load-bearing)
	constexpr uint8_t kGetterPrologue[] = {0x48, 0x83, 0xEC, 0x28, 0xE8};
	constexpr size_t kGetterPrologueLen = sizeof(kGetterPrologue);

	// F3 0F 10 80 <disp32> = movss xmm0,[rax+disp32]
	constexpr uint8_t kFieldSignature[] = {0xF3, 0x0F, 0x10, 0x80};
	constexpr size_t kFieldSignatureLen = sizeof(kFieldSignature);
	constexpr size_t kGetterScanBytes = 64;

	enum class ClockState
	{
		Ok,
		NoImageBase,
		PrologueMismatch,
		FieldNotFound,
		NoWorldContext,
		OwnerUnresolved,
	};

	auto StateText(ClockState state) -> const char*
	{
		switch (state)
		{
		case ClockState::Ok: return "ok";
		case ClockState::NoImageBase: return "no_image_base";
		case ClockState::PrologueMismatch: return "rva_mismatch";
		case ClockState::FieldNotFound: return "field_not_found";
		case ClockState::NoWorldContext: return "no_world_context";
		case ClockState::OwnerUnresolved: return "owner_unresolved";
		}
		return "unknown";
	}

	struct Clock
	{
		ClockState state{ClockState::NoImageBase};
		uint32_t field_offset{0};
		float* field{nullptr};
	};

	auto ResolveClock() -> Clock
	{
		Clock out{};

		const uintptr_t base = reinterpret_cast<uintptr_t>(GetModuleHandleW(nullptr));
		if (base == 0)
		{
			out.state = ClockState::NoImageBase;
			return out;
		}

		const auto* getter = reinterpret_cast<const uint8_t*>(base + kRvaClockGetter);
		if (std::memcmp(getter, kGetterPrologue, kGetterPrologueLen) != 0)
		{
			out.state = ClockState::PrologueMismatch;
			return out;
		}

		for (size_t i = 0; i + kFieldSignatureLen + 4 <= kGetterScanBytes; ++i)
		{
			if (std::memcmp(getter + i, kFieldSignature, kFieldSignatureLen) == 0)
			{
				std::memcpy(&out.field_offset, getter + i + kFieldSignatureLen, sizeof(out.field_offset));
				break;
			}
		}
		if (out.field_offset == 0)
		{
			out.state = ClockState::FieldNotFound;
			return out;
		}

		RC::Unreal::UObject* context = RC::Unreal::UObjectGlobals::FindFirstOf(STR("MTSunSky"));
		if (!context) context = RC::Unreal::UObjectGlobals::FindFirstOf(STR("MotorTownGameState"));
		if (!context)
		{
			out.state = ClockState::NoWorldContext;
			return out;
		}

		using ResolveFn = void* (*)(void*);
		auto resolve_owner = reinterpret_cast<ResolveFn>(base + kRvaResolveOwner);
		void* owner = resolve_owner(context);
		if (!owner)
		{
			out.state = ClockState::OwnerUnresolved;
			return out;
		}

		out.field = reinterpret_cast<float*>(reinterpret_cast<uintptr_t>(owner) + out.field_offset);
		out.state = ClockState::Ok;
		return out;
	}
}  // namespace

namespace TimeOfDay
{
	auto RegisterLuaFunctions(LuaMadeSimple::Lua& lua) -> void
	{
		lua.register_function("MTTimeGetHour", [](const LuaMadeSimple::Lua& l) -> int {
			Clock clock = ResolveClock();
			if (clock.state != ClockState::Ok || !clock.field)
			{
				l.set_number(-1.0);
				l.set_string(std::string(StateText(clock.state)));
				return 2;
			}
			l.set_number(static_cast<double>(*clock.field));
			l.set_string(std::string("ok"));
			return 2;
		});

		lua.register_function("MTTimeSetHour", [](const LuaMadeSimple::Lua& l) -> int {
			if (l.get_stack_size() < 1)
			{
				l.set_number(-1.0);
				l.set_number(-1.0);
				l.set_string(std::string("missing_hour"));
				return 3;
			}

			const double hour = l.get_number();
			// The game wraps at 24; accept the full day only, so a caller that
			// computed an offset can check its own arithmetic instead of getting a
			// silently modded clock back.
			if (!(hour >= 0.0 && hour < 24.0))
			{
				l.set_number(-1.0);
				l.set_number(-1.0);
				l.set_string(std::string("hour_out_of_range"));
				return 3;
			}

			Clock clock = ResolveClock();
			if (clock.state != ClockState::Ok || !clock.field)
			{
				l.set_number(-1.0);
				l.set_number(-1.0);
				l.set_string(std::string(StateText(clock.state)));
				return 3;
			}

			const float before = *clock.field;
			*clock.field = static_cast<float>(hour);
			const float after = *clock.field;

			Output::send<LogLevel::Normal>(STR("[TimeOfDay] set hour {} (was {})\n"),
				static_cast<double>(after), static_cast<double>(before));

			l.set_number(static_cast<double>(before));
			l.set_number(static_cast<double>(after));
			l.set_string(std::string("ok"));
			return 3;
		});

		lua.register_function("MTTimeStatus", [](const LuaMadeSimple::Lua& l) -> int {
			Clock clock = ResolveClock();
			char buf[128]{};
			std::snprintf(buf, sizeof(buf), "%s;offset=0x%x", StateText(clock.state), clock.field_offset);
			l.set_string(std::string(buf));
			return 1;
		});

		// Prove the guards at load time rather than at the first request: an
		// unpatched game build shows up in the log, not in a 06:00 surprise.
		Clock clock = ResolveClock();
		if (clock.state == ClockState::Ok)
		{
			Output::send<LogLevel::Normal>(STR("[TimeOfDay] clock bridge ready (offset=0x{x})\n"),
				static_cast<uint64_t>(clock.field_offset));
		}
		else
		{
			const std::string reason{StateText(clock.state)};
			Output::send<LogLevel::Warning>(STR("[TimeOfDay] clock bridge UNAVAILABLE: {}\n"),
				StringType(reason.begin(), reason.end()));
		}
	}
}  // namespace TimeOfDay
