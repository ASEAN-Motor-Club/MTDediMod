#pragma once

#include <string>
#include <optional>
#include <functional>
#include <format>
#include <vector>
#include <utility>
#include <Unreal/UObjectGlobals.hpp>
#include <Unreal/UObject.hpp>
#include <Unreal/UnrealCoreStructs.hpp>
#include <DynamicOutput/DynamicOutput.hpp>
#include <boost/json.hpp> 
#include "EventManager.h"

using namespace RC;
using namespace RC::Unreal;
namespace json = boost::json;

class HookManager
{
private:
    // Storage for registered hooks: (function name, hook ID pair)
    static inline std::vector<std::pair<std::wstring, std::pair<int, int>>> s_RegisteredHooks;
public:
    /**
     * @brief A function that extracts hook-specific data.
     * @param Context The Unreal context.
     * @param event_data The JSON data object to populate.
     * @return true if extraction was successful and event should be sent, false otherwise.
     */
    using DataExtractor = std::function<bool(UnrealScriptFunctionCallableContext&, json::object&)>;

    /**
     * @brief Registers a pre-hook for a player-related event.
     * This automatically handles getting the CharacterGuid and building the base event payload.
     *
     * @param unreal_function_name The full path to the Unreal function to hook (e.g., STR("/Script/Class.Function")).
     * @param event_name The string name to use for the 'hook' field in the JSON payload.
     * @param data_extractor_fn (Optional) A function to extract additional, hook-specific data.
     */
    static void RegisterPlayerEventHook(
        const std::wstring& unreal_function_name,
        const std::string& event_name,
        DataExtractor data_extractor_fn = nullptr
    )
    {
        auto pre_hook = [event_name, data_extractor_fn](UnrealScriptFunctionCallableContext& Context, void* CustomData) {
            Output::send<LogLevel::Verbose>(STR("Start of hook {}"), to_wstring(event_name));

            // 1. Get Base Player Info (now encapsulated)
            std::optional<std::string> character_guid_str = GetCharacterGuid(Context);
            if (!character_guid_str)
            {
                Output::send<LogLevel::Warning>(STR("Could not get CharacterGuid for hook {}"), to_wstring(event_name));
                return; // Abort
            }

            // 2. Create Base Payload
            json::object event_payload;
            json::object event_data;

            event_data["CharacterGuid"] = json::string(*character_guid_str);
            event_payload["hook"] = json::string(event_name);
            event_payload["timestamp"] = std::time(nullptr);

            // 3. Run custom data extractor, if provided
            if (data_extractor_fn)
            {
                try
                {
                    bool success = data_extractor_fn(Context, event_data);
                    if (!success)
                    {
                        // The extractor failed (e.g., null pointer) and signaled not to send the event.
                        Output::send<LogLevel::Verbose>(STR("Data extraction failed or was aborted for hook {}"), to_wstring(event_name));
                        return;
                    }
                }
                catch (const std::exception& e)
                {
                    Output::send<LogLevel::Error>(STR("Exception in data extractor for hook {}: {}"), to_wstring(event_name), to_wstring(e.what()));
                    return; // Abort on exception
                }
            }

            // 4. Send Event
            event_payload["data"] = std::move(event_data);
            EventManager::Get().AddEvent(std::move(event_payload));
        };

        // 5. Register the hook and store the hook IDs
        auto hookIds = UObjectGlobals::RegisterHook(
            unreal_function_name.c_str(),
            pre_hook,
            [](UnrealScriptFunctionCallableContext&, void*) {}, // Empty post-hook
            nullptr
        );
        s_RegisteredHooks.emplace_back(unreal_function_name, hookIds);
        Output::send<LogLevel::Verbose>(STR("Registered hook for {} with IDs ({}, {})"), unreal_function_name, hookIds.first, hookIds.second);
    }

    /**
     * @brief Unregisters all previously registered hooks.
     * Call this before reinitializing hooks (e.g., on mod reload).
     */
    static void UnregisterAllHooks()
    {
        Output::send<LogLevel::Normal>(STR("Unregistering {} hooks..."), s_RegisteredHooks.size());
        for (const auto& [funcName, hookIds] : s_RegisteredHooks)
        {
            UObjectGlobals::UnregisterHook(funcName.c_str(), hookIds);
            Output::send<LogLevel::Verbose>(STR("Unregistered hook for {}"), funcName);
        }
        s_RegisteredHooks.clear();
        Output::send<LogLevel::Normal>(STR("All hooks unregistered."));
    }

private:
    /**
     * @brief Encapsulated logic to get the player's CharacterGuid string.
     */
    static std::optional<std::string> GetCharacterGuid(UnrealScriptFunctionCallableContext& Context)
    {
        const auto& PlayerController = Context.Context;
        if (PlayerController == nullptr) {
            return std::nullopt;
        }

        auto PlayerState = PlayerController->GetValuePtrByPropertyNameInChain<UObject*>(STR("PlayerState"));
        if (PlayerState == nullptr || *PlayerState == nullptr) {
            return std::nullopt;
        }

        const auto& CharacterGuid = (*PlayerState)->GetValuePtrByPropertyName<FGuid>(STR("CharacterGuid"));
        if (CharacterGuid == nullptr) {
            return std::nullopt;
        }

        // Return the formatted string
        return std::format(
            "{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
            CharacterGuid->A,
            (CharacterGuid->B >> 16),    // High 16 bits of B
            (CharacterGuid->B & 0xFFFF), // Low 16 bits of B
            (CharacterGuid->C >> 16),    // High 16 bits of C
            (CharacterGuid->C & 0xFFFF), // Low 16 bits of C
            CharacterGuid->D
        );
    }
};