#include "AdminHide.h"

// windows.h defines min/max as macros, which breaks the UE4SS/Unreal headers
// (std::numeric_limits<T>::max()). Must be set before any include.
#ifndef NOMINMAX
#define NOMINMAX
#endif
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif

#include <windows.h>
#include <cstdint>
#include <cstring>

#include <DynamicOutput/DynamicOutput.hpp>
#include <Unreal/UObjectGlobals.hpp>
#include <Unreal/UClass.hpp>
#include <Unreal/FProperty.hpp>

using namespace RC;
using namespace RC::Unreal;

namespace
{
    // AMotorTownPlayerState.bIsAdmin is a replicated bool. Clients render the
    // star and the " (Admin)" suffix from their copy of that flag, while every
    // server-side permission check reads the *server's* copy.
    //
    // The two requirements pull in opposite directions:
    //   - clients must receive `false` (nobody renders an admin badge)
    //   - the server must keep `true`  (admin RPCs keep their authority)
    //
    // Changing the object's value can only satisfy one of them. Zeroing it at
    // the setter removed the badge and every admin action with it - verified on
    // staging: kick fails with the flag forced false and works with it true.
    //
    // Instead we intercept NetSerializeItem, the single virtual call that turns
    // a property into bytes on the wire, and hand it a zeroed byte. The object
    // is never modified: the server keeps its real value, the panel and RPC
    // authority are untouched, and clients only ever decode `false` - at join
    // (initial bunch) and on every delta alike.
    //
    // Installation copies the FBoolProperty vtable for this one property object
    // and swaps the NetSerializeItem slot in the copy. No engine code is patched
    // and no other bool property is affected; the cost is one extra call on the
    // single property that would otherwise replicate.
    constexpr size_t kVTableSlots = 64;
    constexpr size_t kNetSerializeItemFallback = 0x98; // UE 4.26/4.27

    using NetSerializeItemFn = bool (*)(const void* self, void* ar, void* map, void* data, void* meta);

    NetSerializeItemFn g_orig = nullptr;
    void** g_vtable_copy = nullptr;

    // x64 MSVC: self in rcx, then Ar, Map, Data, MetaData. FBoolProperty reads
    // the value through Data, so pointing it at a local zero byte serializes
    // `false` without touching the object.
    bool Detour(const void* self, void* ar, void* map, void* data, void* meta)
    {
        uint8_t zero = 0;
        return g_orig(self, ar, map, &zero, meta);
    }
}

namespace AdminHide
{
    bool Install()
    {
        if (g_orig) return true;

        auto* state_class = UObjectGlobals::StaticFindObject<UClass*>(
            nullptr, nullptr, STR("/Script/MotorTown.MotorTownPlayerState"));
        if (!state_class)
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] MotorTownPlayerState class not found\n"));
            return false;
        }

        auto* prop = state_class->GetPropertyByNameInChain(STR("bIsAdmin"));
        if (!prop)
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] bIsAdmin property not found\n"));
            return false;
        }

        size_t slot_bytes = kNetSerializeItemFallback;
        auto it = FProperty::VTableLayoutMap.find(STR("NetSerializeItem"));
        if (it != FProperty::VTableLayoutMap.end())
        {
            slot_bytes = it->second;
        }

        auto** vtable = *reinterpret_cast<void***>(prop);
        if (!vtable)
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] bIsAdmin has no vtable\n"));
            return false;
        }

        const size_t slot = slot_bytes / sizeof(void*);

        g_vtable_copy = static_cast<void**>(VirtualAlloc(
            nullptr, kVTableSlots * sizeof(void*), MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE));
        if (!g_vtable_copy)
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] vtable copy alloc failed\n"));
            return false;
        }

        std::memcpy(g_vtable_copy, vtable, kVTableSlots * sizeof(void*));
        g_orig = reinterpret_cast<NetSerializeItemFn>(g_vtable_copy[slot]);
        g_vtable_copy[slot] = reinterpret_cast<void*>(&Detour);

        auto** vptr_field = reinterpret_cast<void**>(prop);
        DWORD old = 0;
        if (!VirtualProtect(vptr_field, sizeof(void*), PAGE_READWRITE, &old))
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] VirtualProtect failed\n"));
            return false;
        }
        *vptr_field = g_vtable_copy;
        VirtualProtect(vptr_field, sizeof(void*), old, &old);

        Output::send<LogLevel::Warning>(
            STR("[AdminHide] bIsAdmin forced false on the wire (NetSerializeItem slot {}); server value untouched\n"),
            slot);
        return true;
    }
}
