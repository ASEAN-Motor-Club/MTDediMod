#pragma once
#include <atomic>
#include <cstdint>
#include <string>

#include <Unreal/Hooks/Hooks.hpp>

// Forward declarations from UE4SS Unreal API; we only need names.
namespace RC::Unreal
{
    class UObject;
    class UClass;
    class FProperty;
    class UEngine;
}

// Game-thread sampler for player locations.
//
// Registers an engine tick pre-callback (same pattern as LuaHttpServer) and
// every N ticks walks the MotorTownGameState PlayerArray, building a
// LocationSnapshot which is pushed to LocationBroadcaster::Publish().
//
// The sampler caches FProperty* pointers on first resolution; UClass
// property offsets are stable across map changes so the cache survives
// GameState pointer invalidation.
class LocationSampler
{
public:
    static LocationSampler& Get();

    // Register the engine tick hook. `hz` is the desired sample rate and is
    // clamped into [0.5, 10]. Safe to call more than once — the second call
    // is a no-op.
    void Start(float hz);

    // Unregister the engine tick hook. Safe to call when not started.
    void Stop();

private:
    LocationSampler() = default;

    struct PropCache
    {
        bool initialized = false;
        // AMotorTownPlayerState (or base) properties
        RC::Unreal::FProperty* ps_character_guid = nullptr; // FGuid
        RC::Unreal::FProperty* ps_location       = nullptr; // FVector
        RC::Unreal::FProperty* ps_vehicle_key    = nullptr; // FName
        RC::Unreal::FProperty* ps_pawn_private   = nullptr; // UObject* (APawn)
        // Sub-properties of the pawn that we cache opportunistically.
        RC::Unreal::FProperty* pawn_root_component = nullptr;    // UObject*
        RC::Unreal::FProperty* scene_relative_rotation = nullptr; // FRotator

        // Pawn change detection (vehicle props only valid for AMTVehicle pawns)
        RC::Unreal::UObject* last_pawn = nullptr;

        // Vehicle-only property pointers (cleared on pawn change)
        RC::Unreal::FProperty* veh_engine_hot_state = nullptr;
        RC::Unreal::FProperty* veh_engine_rpm       = nullptr;
        RC::Unreal::FProperty* veh_trans_cold_state = nullptr;
        RC::Unreal::FProperty* veh_trans_gear       = nullptr;
        RC::Unreal::FProperty* veh_rep_movement     = nullptr;
        RC::Unreal::FProperty* veh_rep_velocity     = nullptr;
    };

    // Called from the engine tick callback.
    void Tick();

    // Resolve MotorTownGameState. Caches the pointer across ticks and only
    // re-resolves via FindFirstOf when the cached pointer is invalid (destroyed
    // or null). This eliminates the O(UObject-count) scan in the hot path —
    // FindFirstOf now runs only on startup and after map transitions.
    RC::Unreal::UObject* ResolveGameState();

    // Format an FGuid into the 32-char uppercase hex string matching
    // Lua's GuidToString output.
    static void FormatGuid(const void* guid_ptr, std::string& out);

    // Cached GameState pointer — avoids repeated FindFirstOf scans.
    RC::Unreal::UObject* m_game_state = nullptr;

    // Cached PlayerArray FProperty on the GameState class (stable across instances).
    RC::Unreal::FProperty* m_player_array_prop = nullptr;

    std::atomic<bool> m_started{false};
    bool m_tick_hook_registered = false;
    uint64_t m_tick_callback_id = RC::Unreal::Hook::ERROR_ID;

    // Tick cadence. Assumes a nominal 30 Hz server tick; a divisor of
    // round(30 / hz) skips (divisor - 1) out of every `divisor` ticks.
    // Documented assumption — if the server retunes its tick rate the
    // effective sample Hz will drift proportionally but payload
    // timestamp_ms stays accurate.
    int32_t m_tick_divisor = 15; // default: 30 Hz / 2 Hz sample = 15
    int32_t m_tick_counter = 0;

    PropCache m_cache;
};
