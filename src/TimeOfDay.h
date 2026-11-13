#pragma once

#include <LuaMadeSimple/LuaMadeSimple.hpp>

namespace TimeOfDay
{
	// Registers the native world-clock bridge on the mod's own Lua state:
	//
	//   hour, err          = MTTimeGetHour()
	//   before, after, err = MTTimeSetHour(hour)
	//   status             = MTTimeStatus()
	//
	// The world hour is a plain float with no UPROPERTY anywhere in the reflected
	// API, so no Lua property write, RPC or config actor can reach it. This module
	// is the only supported write path; see TimeOfDay.cpp for the native chain and
	// the per-build guards.
	auto RegisterLuaFunctions(RC::LuaMadeSimple::Lua& lua) -> void;
}
