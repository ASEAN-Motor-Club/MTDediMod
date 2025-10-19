#include "dllmain.h"
#include <cmath>
#include <Mod/CppUserModBase.hpp>
#include <DynamicOutput/DynamicOutput.hpp>
#include <Unreal/UObjectGlobals.hpp>
#include <Unreal/UObject.hpp>
#include <Unreal/UScriptStruct.hpp>
#include <Unreal/Property/FStructProperty.hpp>
#include <Unreal/AGameModeBase.hpp>
#include <LuaMadeSimple/LuaMadeSimple.hpp>
#include <LuaType/LuaUObject.hpp>

#include <Unreal/UFunction.hpp>
#include <Unreal/FProperty.hpp>
#include <Unreal/Property/FStructProperty.hpp>
#include <Unreal/UScriptStruct.hpp>

#include "webserver.h"
#include "statics.h"
#include "EventManager.h"

using namespace RC;
using namespace RC::Unreal;

MotorTownMods::MotorTownMods()
	: CppUserModBase()
{
	ModName = ModStatics::GetModName();
	ModVersion = ModStatics::GetVersion();
	ModDescription = STR("Mods for Motor Town and Motor Town dedicated server");
	ModAuthors = STR("drpsyko101");
	// Do not change this unless you want to target a UE4SS version
	// other than the one you're currently building with somehow.
	//ModIntendedSDKVersion = STR("2.6");

	Output::send<LogLevel::Verbose>(STR("[{}] mod loaded\n"), ModName);
}

auto MotorTownMods::on_unreal_init() -> void
{
	// Init API server
	auto server = Webserver::Get();
	auto prehookServerCargoArrived = [](UnrealScriptFunctionCallableContext& Context, void* CustomData) {
		const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
		std::string CharacterGuidStr;
		const auto& PlayerController = Context.Context;
		auto PlayerStateProperty = PlayerController->GetPropertyByNameInChain(STR("PlayerState"));
		auto PlayerState = PlayerController->GetValuePtrByPropertyNameInChain<UObject*>(STR("PlayerState"));
		if (PlayerState) {
			const auto& CharacterGuid = (*PlayerState)->GetValuePtrByPropertyName<FGuid>(STR("CharacterGuid"));
			if (CharacterGuid) {
				CharacterGuidStr = std::format(
					"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
					CharacterGuid->A,
					(CharacterGuid->B >> 16),      // High 16 bits of B
					(CharacterGuid->B & 0xFFFF),   // Low 16 bits of B
					(CharacterGuid->C >> 16),      // High 16 bits of C
					(CharacterGuid->C & 0xFFFF),   // Low 16 bits of C
					CharacterGuid->D
				);
				Output::send<LogLevel::Verbose>(STR("{}\n"), to_wstring(CharacterGuidStr));
			}
		}

		json::object event_payload;
		json::object event_data;
		if (!CharacterGuidStr.empty()) {
			event_data["CharacterGuid"] = json::string(CharacterGuidStr);
		}
		event_payload["hook"] = json::string("ServerCargoArrived");
		event_payload["timestamp"] = std::time(nullptr);
		json::array cargos_payload;

		auto CargosProperty = FunctionBeingExecuted->GetPropertyByName(STR("Cargos"));
		const auto& cargos = CargosProperty->ContainerPtrToValuePtr<TArray<UObject*>>(Context.TheStack.Locals());
		for (const auto& cargo : *cargos) {
			const auto& CargoKey = cargo->GetValuePtrByPropertyNameInChain<FName>(STR("Net_CargoKey"));
			const auto& Damage = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_Damage"));
			const auto& TimeLeftSeconds = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_TimeLeftSeconds"));
			const auto& DeliveryId = cargo->GetValuePtrByPropertyNameInChain<int32>(STR("Net_DeliveryId"));
			const auto& DestinationLocation = cargo->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_DestinationLocation"));
			json::object destination_location_obj;
			destination_location_obj["X"] = static_cast<int>(std::round(DestinationLocation->X()));
			destination_location_obj["Y"] = static_cast<int>(std::round(DestinationLocation->Y()));
			destination_location_obj["Z"] = static_cast<int>(std::round(DestinationLocation->Z()));
			const auto& SenderAbsoluteLocation = cargo->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_SenderAbsoluteLocation"));
			json::object sender_location_obj;
			sender_location_obj["X"] = static_cast<int>(std::round(SenderAbsoluteLocation->X()));
			sender_location_obj["Y"] = static_cast<int>(std::round(SenderAbsoluteLocation->Y()));
			sender_location_obj["Z"] = static_cast<int>(std::round(SenderAbsoluteLocation->Z()));
			auto PaymentProperty = static_cast<FStructProperty*>(cargo->GetPropertyByNameInChain(STR("Net_Payment")));
			auto TopLevelPayment = PaymentProperty->GetStruct();
			auto Payment = PaymentProperty->ContainerPtrToValuePtr<void>(cargo);
			auto BaseValueProperty = TopLevelPayment->GetPropertyByNameInChain(STR("BaseValue"));
			auto BasePayment = BaseValueProperty->ContainerPtrToValuePtr<int64>(Payment);
			cargos_payload.push_back({
				{"Net_CargoKey", json::string(to_string(CargoKey->ToString()))},
				{"Net_DeliveryId", *DeliveryId},
				{"Net_Payment", *BasePayment},
				{"Net_Damage", *Damage},
				{"Net_TimeLeftSeconds", *TimeLeftSeconds},
				{"Net_DestinationLocation", destination_location_obj},
				{"Net_SenderAbsoluteLocation", sender_location_obj}
			});
		}

		event_data["Cargos"] = cargos_payload;
		event_payload["data"] = event_data;
		EventManager::Get().AddEvent(std::move(event_payload));
	};
	auto posthookServerCargoArrived = [](UnrealScriptFunctionCallableContext& Context, void* CustomData) {
	};
	UObjectGlobals::RegisterHook(STR("/Script/MotorTown.MotorTownPlayerController:ServerCargoArrived"), prehookServerCargoArrived, posthookServerCargoArrived, nullptr);

	auto prehookServerResetVehicleAtResponse = [](UnrealScriptFunctionCallableContext& Context, void* CustomData) {
		Output::send<LogLevel::Verbose>(STR("ServerResetVehicleAtResponse hook\n"));
		const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
		std::string CharacterGuidStr;
		const auto& PlayerController = Context.Context;
		auto PlayerStateProperty = PlayerController->GetPropertyByNameInChain(STR("PlayerState"));
		auto PlayerState = PlayerController->GetValuePtrByPropertyNameInChain<UObject*>(STR("PlayerState"));
		if (PlayerState) {
			const auto& CharacterGuid = (*PlayerState)->GetValuePtrByPropertyName<FGuid>(STR("CharacterGuid"));
			if (CharacterGuid) {
				CharacterGuidStr = std::format(
					"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
					CharacterGuid->A,
					(CharacterGuid->B >> 16),      // High 16 bits of B
					(CharacterGuid->B & 0xFFFF),   // Low 16 bits of B
					(CharacterGuid->C >> 16),      // High 16 bits of C
					(CharacterGuid->C & 0xFFFF),   // Low 16 bits of C
					CharacterGuid->D
				);
				Output::send<LogLevel::Verbose>(STR("{}\n"), to_wstring(CharacterGuidStr));
			}
		}

		json::object event_payload;
		json::object event_data;
		if (!CharacterGuidStr.empty()) {
			event_data["CharacterGuid"] = json::string(CharacterGuidStr);
		}
		event_payload["hook"] = json::string("ServerResetVehicleAtResponse");
		event_payload["timestamp"] = std::time(nullptr);

		auto VehicleProperty = FunctionBeingExecuted->GetPropertyByName(STR("Vehicle"));
		const auto& Vehicle = VehicleProperty->ContainerPtrToValuePtr<UObject*>(Context.TheStack.Locals());
		if (Vehicle) {
			auto VehicleId = (*Vehicle)->GetValuePtrByPropertyNameInChain<int64>(STR("Net_VehicleId"));
			if (VehicleId) {
				event_data["VehicleId"] = *VehicleId;
				event_payload["data"] = event_data;
				EventManager::Get().AddEvent(std::move(event_payload));
			}
		}
	};
	auto posthookServerResetVehicleAtResponse = [](UnrealScriptFunctionCallableContext& Context, void* CustomData) {
	};
	UObjectGlobals::RegisterHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerResetVehicleAtResponse"),
		prehookServerResetVehicleAtResponse,
		posthookServerResetVehicleAtResponse,
		nullptr
	);
}

auto MotorTownMods::on_lua_start(
	LuaMadeSimple::Lua& lua,
	LuaMadeSimple::Lua& main_lua,
	LuaMadeSimple::Lua& async_lua,
	std::vector<LuaMadeSimple::Lua*>& hook_luas) -> void
{
	lua.register_function("ExportStructAsText", [](const LuaMadeSimple::Lua& lua_net) -> int {
		int32_t stack_size = lua_net.get_stack_size();

		if (stack_size <= 1)
		{
			lua_net.throw_error("Function 'UScriptStruct:GetStructTextItem' cannot be called with 1 parameters.");
		}

		auto& object = lua_net.get_userdata<RC::LuaType::UObject>();
		auto propName = lua_net.get_string();
		auto ptr = object.get_remote_cpp_object();
		if (ptr)
		{
			auto uniqueIdProp = static_cast<FStructProperty*>(ptr->GetPropertyByNameInChain(to_wstring(propName).c_str()));
			if (uniqueIdProp)
			{
				auto uniqueIdStruct = uniqueIdProp->GetStruct();
				auto uniqueId = uniqueIdProp->ContainerPtrToValuePtr<void>(ptr);

				FString uniqueIdString;
				uniqueIdProp->ExportTextItem(uniqueIdString, uniqueId, nullptr, ptr, 0);
				lua_net.set_string(to_string(uniqueIdString.GetCharArray()));
				return 1;
			}
		}
		lua_net.set_string("");

		return 1;
		});
}
