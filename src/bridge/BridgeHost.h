#pragma once

#include <Mod/CppUserModBase.hpp>

using namespace RC;
using namespace RC::Unreal;

// MTDediBridgeHost — tiny UE4SS C++ mod that hosts the Lua side of the
// native overlay bridge (see mt_bridge.h). It registers three global Lua
// functions from on_lua_start and drains the Rust command queue on the game
// thread from an engine tick callback. It has NO game-specific logic; the
// bridge is admin-neutral (commands are opaque JSON that the Lua
// OverlayBridge.lua interprets, and that file is excluded from player
// packages by the packaging static guard).
class MTDediBridgeHost : public RC::CppUserModBase
{
public:
    MTDediBridgeHost();
    ~MTDediBridgeHost() override;

    auto on_lua_start(
        LuaMadeSimple::Lua& lua,
        LuaMadeSimple::Lua& main_lua,
        LuaMadeSimple::Lua& async_lua,
        std::vector<LuaMadeSimple::Lua*>& hook_luas) -> void override;
};

#define MT_BRIDGE_HOST_API __declspec(dllexport)
extern "C"
{
    MT_BRIDGE_HOST_API RC::CppUserModBase* start_mod()
    {
        return new MTDediBridgeHost();
    }

    MT_BRIDGE_HOST_API void uninstall_mod(RC::CppUserModBase* mod)
    {
        delete mod;
    }
}
