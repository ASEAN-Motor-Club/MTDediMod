#include "LocationSampler.h"
#include "LocationBroadcaster.h"
#include "TickProfiler.h"

#include <chrono>
#include <DynamicOutput/DynamicOutput.hpp>
#include <Helpers/String.hpp>
#include <Unreal/FProperty.hpp>
#include <Unreal/Property/FArrayProperty.hpp>
#include <Unreal/Property/FStructProperty.hpp>
#include <Unreal/UScriptStruct.hpp>
#include <Unreal/Rotator.hpp>
#include <Unreal/UClass.hpp>
#include <Unreal/UObject.hpp>
#include <Unreal/UObjectGlobals.hpp>
#include <Unreal/UnrealCoreStructs.hpp>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <format>
#include <memory>

using namespace RC;
using namespace RC::Unreal;

LocationSampler& LocationSampler::Get()
{
    static LocationSampler instance;
    return instance;
}

void LocationSampler::Start(float hz)
{
    if (m_started.exchange(true))
    {
        // Already started — no double-register on hot reload.
        return;
    }

    // Clamp sample rate into [0.5, 10] Hz.
    if (!(hz >= 0.5f)) hz = 0.5f;
    if (hz > 10.0f) hz = 10.0f;

    // Assume the dedicated server ticks at 30 Hz (standard for Motor Town).
    // divisor = max(1, round(30 / hz)); at 2 Hz this is 15.
    constexpr float kServerTickHz = 30.0f;
    int32_t divisor = static_cast<int32_t>(std::lround(kServerTickHz / hz));
    if (divisor < 1) divisor = 1;
    m_tick_divisor = divisor;
    m_tick_counter = 0;

    using namespace RC::Unreal::Hook;

    auto callback = [this](TCallbackIterationData<void>&, UEngine*, float, bool) {
        this->Tick();
    };

    m_tick_callback_id = RegisterEngineTickPreCallback(
        callback,
        FCallbackOptions{
            .bOnce = false,
            .bReadonly = true,
            .OwnerModName = STR("MotorTownMods"),
            .HookName = STR("LocationSample")
        }
    );

    if (m_tick_callback_id == ERROR_ID)
    {
        Output::send<LogLevel::Error>(
            STR("[LocationSampler] Failed to register engine tick hook\n"));
        m_started = false;
        return;
    }

    m_tick_hook_registered = true;

    Output::send<LogLevel::Verbose>(
        STR("[LocationSampler] Started: hz={} tick_divisor={} callback_id={}\n"),
        hz, m_tick_divisor, m_tick_callback_id);
}

void LocationSampler::Stop()
{
    if (!m_started.exchange(false)) return;

    if (m_tick_hook_registered && m_tick_callback_id != RC::Unreal::Hook::ERROR_ID)
    {
        RC::Unreal::Hook::UnregisterCallback(m_tick_callback_id);
        m_tick_callback_id = RC::Unreal::Hook::ERROR_ID;
        m_tick_hook_registered = false;
    }

    Output::send<LogLevel::Verbose>(STR("[LocationSampler] Stopped\n"));
}

UObject* LocationSampler::ResolveGameState()
{
    // Re-resolve on every call: the GameState pointer changes on map
    // transitions. FindFirstOf is O(UObject-count) but only runs once per
    // sample tick (e.g. every 500 ms at 2 Hz).
    return UObjectGlobals::FindFirstOf(STR("MotorTownGameState"));
}

void LocationSampler::FormatGuid(const void* guid_ptr, std::string& out)
{
    // FGuid is 4 uint32_t values {A, B, C, D}. Match Lua GuidToString output.
    const uint32_t* g = reinterpret_cast<const uint32_t*>(guid_ptr);
    const uint32_t A = g[0];
    const uint32_t B = g[1];
    const uint32_t C = g[2];
    const uint32_t D = g[3];
    out = std::format(
        "{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
        A,
        (B >> 16),
        (B & 0xFFFF),
        (C >> 16),
        (C & 0xFFFF),
        D);
}

void LocationSampler::Tick()
{
    // Cheap skip: run the sample body once per m_tick_divisor engine ticks.
    if (++m_tick_counter < m_tick_divisor) return;
    m_tick_counter = 0;

    auto t0 = std::chrono::steady_clock::now();

    UObject* gameState = ResolveGameState();
    if (!gameState)
    {
        // Startup / map transition — normal, no log.
        return;
    }

    auto PlayerArrayProp = static_cast<FArrayProperty*>(
        gameState->GetPropertyByNameInChain(STR("PlayerArray")));
    if (!PlayerArrayProp) return;

    auto players = PlayerArrayProp->ContainerPtrToValuePtr<FScriptArray>(gameState);
    if (!players || !players->GetData()) return;

    auto inner = PlayerArrayProp->GetInner();
    if (!inner) return;
    const int32 elemSize = inner->GetElementSize();
    const int32 n = players->Num();

    auto snap = std::make_shared<LocationSnapshot>();
    snap->entries.reserve(static_cast<size_t>(std::max(0, n)));
    snap->boot_epoch = LocationBroadcaster::Get().GetBootEpoch();
    snap->seq = LocationBroadcaster::Get().NextSeq();
    snap->timestamp_ms = static_cast<uint64_t>(
        std::chrono::duration_cast<std::chrono::milliseconds>(
            std::chrono::system_clock::now().time_since_epoch()).count());

    for (int32 i = 0; i < n; ++i)
    {
        auto ps_slot = reinterpret_cast<UObject**>(
            static_cast<uint8_t*>(players->GetData()) + elemSize * i);
        UObject* ps = ps_slot ? *ps_slot : nullptr;
        if (!ps) continue;

        // Resolve and cache FProperty* pointers the first time we see a
        // valid PlayerState. UClass property offsets are stable across
        // map changes so these cached pointers are reused forever.
        if (!m_cache.initialized)
        {
            m_cache.ps_character_guid = ps->GetPropertyByNameInChain(STR("CharacterGuid"));
            m_cache.ps_location       = ps->GetPropertyByNameInChain(STR("Location"));
            m_cache.ps_vehicle_key    = ps->GetPropertyByNameInChain(STR("VehicleKey"));
            m_cache.ps_pawn_private   = ps->GetPropertyByNameInChain(STR("PawnPrivate"));
            m_cache.initialized = true;

            Output::send<LogLevel::Verbose>(
                STR("[LocationSampler] Resolved PlayerState properties: ")
                STR("CharacterGuid={} Location={} VehicleKey={} PawnPrivate={}\n"),
                m_cache.ps_character_guid ? 1 : 0,
                m_cache.ps_location       ? 1 : 0,
                m_cache.ps_vehicle_key    ? 1 : 0,
                m_cache.ps_pawn_private   ? 1 : 0);
        }

        PlayerLocation entry;

        // --- CharacterGuid ---
        if (m_cache.ps_character_guid)
        {
            auto guid = m_cache.ps_character_guid->ContainerPtrToValuePtr<void>(ps);
            if (guid) FormatGuid(guid, entry.character_guid);
        }

        // --- Location (FVector on the PlayerState) ---
        if (m_cache.ps_location)
        {
            auto loc = m_cache.ps_location->ContainerPtrToValuePtr<FVector>(ps);
            if (loc)
            {
                entry.x = static_cast<float>(loc->X());
                entry.y = static_cast<float>(loc->Y());
                entry.z = static_cast<float>(loc->Z());
            }
        }

        // --- VehicleKey (FName) ---
        if (m_cache.ps_vehicle_key)
        {
            auto vk = m_cache.ps_vehicle_key->ContainerPtrToValuePtr<FName>(ps);
            if (vk)
            {
                auto name_str = vk->ToString();
                std::string s = to_string(name_str);
                // Treat the engine default name "None" as on-foot / no vehicle.
                if (s != "None") entry.vehicle_key = std::move(s);
            }
        }

        // --- Yaw (via PawnPrivate -> RootComponent -> RelativeRotation) ---
        // PawnPrivate may be null mid-respawn or on a just-disconnecting
        // player. In that case we leave yaw = 0.0f and still emit the entry.
        if (m_cache.ps_pawn_private)
        {
            auto pawn_slot = m_cache.ps_pawn_private->ContainerPtrToValuePtr<UObject*>(ps);
            UObject* pawn = pawn_slot ? *pawn_slot : nullptr;
            if (pawn)
            {
                if (!m_cache.pawn_root_component)
                {
                    m_cache.pawn_root_component =
                        pawn->GetPropertyByNameInChain(STR("RootComponent"));
                }
                if (m_cache.pawn_root_component)
                {
                    auto rc_slot = m_cache.pawn_root_component->ContainerPtrToValuePtr<UObject*>(pawn);
                    UObject* root = rc_slot ? *rc_slot : nullptr;
                    if (root)
                    {
                        if (!m_cache.scene_relative_rotation)
                        {
                            m_cache.scene_relative_rotation =
                                root->GetPropertyByNameInChain(STR("RelativeRotation"));
                        }
                        if (m_cache.scene_relative_rotation)
                        {
                            auto rot = m_cache.scene_relative_rotation->ContainerPtrToValuePtr<FRotator>(root);
                            if (rot) entry.yaw = static_cast<float>(rot->GetYaw());
                        }
                    }
                }
            }
        }

        // --- Vehicle telemetry (RPM, Gear, Velocity) ---
        if (m_cache.ps_pawn_private)
        {
            auto pawn_slot = m_cache.ps_pawn_private->ContainerPtrToValuePtr<UObject*>(ps);
            UObject* pawn = pawn_slot ? *pawn_slot : nullptr;

            // Invalidate vehicle cache on pawn change (e.g. player enters/exits vehicle)
            if (pawn != m_cache.last_pawn)
            {
                m_cache.last_pawn = pawn;
                m_cache.veh_engine_hot_state = nullptr;
                m_cache.veh_engine_rpm       = nullptr;
                m_cache.veh_trans_cold_state = nullptr;
                m_cache.veh_trans_gear       = nullptr;
                m_cache.veh_rep_movement     = nullptr;
                m_cache.veh_rep_velocity     = nullptr;
            }

            if (pawn)
            {
                // NetLC_EngineHotState -> CurrentRPM
                if (!m_cache.veh_engine_hot_state)
                {
                    m_cache.veh_engine_hot_state =
                        pawn->GetPropertyByNameInChain(STR("NetLC_EngineHotState"));
                }
                if (m_cache.veh_engine_hot_state)
                {
                    auto state_prop = static_cast<FStructProperty*>(m_cache.veh_engine_hot_state);
                    auto state_ptr = state_prop->ContainerPtrToValuePtr<void>(pawn);
                    if (state_ptr)
                    {
                        if (!m_cache.veh_engine_rpm)
                        {
                            m_cache.veh_engine_rpm =
                                state_prop->GetStruct()->GetPropertyByNameInChain(STR("CurrentRPM"));
                        }
                        if (m_cache.veh_engine_rpm)
                        {
                            auto rpm = m_cache.veh_engine_rpm->ContainerPtrToValuePtr<float>(state_ptr);
                            if (rpm) entry.rpm = *rpm;
                        }
                    }
                }

                // NetLC_TransmissionColdState -> CurrentGear
                if (!m_cache.veh_trans_cold_state)
                {
                    m_cache.veh_trans_cold_state =
                        pawn->GetPropertyByNameInChain(STR("NetLC_TransmissionColdState"));
                }
                if (m_cache.veh_trans_cold_state)
                {
                    auto state_prop = static_cast<FStructProperty*>(m_cache.veh_trans_cold_state);
                    auto state_ptr = state_prop->ContainerPtrToValuePtr<void>(pawn);
                    if (state_ptr)
                    {
                        if (!m_cache.veh_trans_gear)
                        {
                            m_cache.veh_trans_gear =
                                state_prop->GetStruct()->GetPropertyByNameInChain(STR("CurrentGear"));
                        }
                        if (m_cache.veh_trans_gear)
                        {
                            auto gear = m_cache.veh_trans_gear->ContainerPtrToValuePtr<int8_t>(state_ptr);
                            if (gear) entry.gear = *gear;
                        }
                    }
                }

                // VehicleReplicatedMovement -> Velocity (FVector)
                if (!m_cache.veh_rep_movement)
                {
                    m_cache.veh_rep_movement =
                        pawn->GetPropertyByNameInChain(STR("VehicleReplicatedMovement"));
                }
                if (m_cache.veh_rep_movement)
                {
                    auto state_prop = static_cast<FStructProperty*>(m_cache.veh_rep_movement);
                    auto state_ptr = state_prop->ContainerPtrToValuePtr<void>(pawn);
                    if (state_ptr)
                    {
                        if (!m_cache.veh_rep_velocity)
                        {
                            m_cache.veh_rep_velocity =
                                state_prop->GetStruct()->GetPropertyByNameInChain(STR("Velocity"));
                        }
                        if (m_cache.veh_rep_velocity)
                        {
                            auto vel = m_cache.veh_rep_velocity->ContainerPtrToValuePtr<FVector>(state_ptr);
                            if (vel)
                            {
                                entry.vx = static_cast<float>(vel->X());
                                entry.vy = static_cast<float>(vel->Y());
                                entry.vz = static_cast<float>(vel->Z());
                            }
                        }
                    }
                }
            }
        }

        snap->entries.push_back(std::move(entry));
    }

    LocationBroadcaster::Get().Publish(std::move(snap));

    auto elapsed = std::chrono::steady_clock::now() - t0;
    TickProfiler::Get().ReportModTime(
        TickProfiler::COMP_LOCATION,
        std::chrono::duration_cast<std::chrono::microseconds>(elapsed).count());
}
