#include "dllmain.h"
#include <cmath>
#include <Mod/CppUserModBase.hpp>
#include <DynamicOutput/DynamicOutput.hpp>
#include <Unreal/UObjectGlobals.hpp>
#include <Unreal/UObject.hpp>
#include <Unreal/UScriptStruct.hpp>
#include <Unreal/Property/FStructProperty.hpp>
#include <Unreal/Property/FArrayProperty.hpp>
#include <Unreal/Property/FObjectProperty.hpp>
#include <Unreal/AGameModeBase.hpp>
#include <LuaMadeSimple/LuaMadeSimple.hpp>
#include <LuaType/LuaUObject.hpp>
#include <Unreal/UFunction.hpp>
#include <Unreal/UEnum.hpp>
#include <Unreal/FProperty.hpp>

#include "webserver.h"
#include "statics.h"
#include "HookManager.h"

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
	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerCargoArrived"),
		"ServerCargoArrived",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			json::array cargos_payload;
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);

			auto CargosProperty = FunctionBeingExecuted->GetPropertyByName(STR("Cargos"));
			const auto& cargos = CargosProperty->ContainerPtrToValuePtr<TArray<UObject*>>(Context.TheStack.Locals());
			if (cargos == nullptr) {
				return false;
			}
			for (const auto& cargo : *cargos) {
				if (cargo == nullptr) {
					continue;
				}
				const auto& CargoKey = cargo->GetValuePtrByPropertyNameInChain<FName>(STR("Net_CargoKey"));
				const auto& Damage = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_Damage"));
				const auto& Weight = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_Weight"));
				const auto& TimeLeftSeconds = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_TimeLeftSeconds"));
				const auto& DeliveryId = cargo->GetValuePtrByPropertyNameInChain<int32>(STR("Net_DeliveryId"));
				const auto& DestinationLocation = cargo->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_DestinationLocation"));
				const auto& SenderAbsoluteLocation = cargo->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_SenderAbsoluteLocation"));
				auto PaymentProperty = static_cast<FStructProperty*>(cargo->GetPropertyByNameInChain(STR("Net_Payment")));
				if (!PaymentProperty) continue; // Safety check

				auto TopLevelPayment = PaymentProperty->GetStruct();
				auto Payment = PaymentProperty->ContainerPtrToValuePtr<void>(cargo);
				if (Payment == nullptr) continue; // Safety check

				auto BaseValueProperty = TopLevelPayment->GetPropertyByNameInChain(STR("BaseValue"));
				if (!BaseValueProperty) continue; // Safety check

				auto BasePayment = BaseValueProperty->ContainerPtrToValuePtr<int64>(Payment);

				if (!CargoKey || !Damage || !Weight || !TimeLeftSeconds || !DeliveryId || !DestinationLocation || !SenderAbsoluteLocation || !BasePayment) {
					Output::send<LogLevel::Warning>(STR("Skipping cargo in ServerCargoArrived hook due to null property."));
					continue;
				}

				json::object destination_location_obj;
				destination_location_obj["X"] = static_cast<int>(std::round(DestinationLocation->X()));
				destination_location_obj["Y"] = static_cast<int>(std::round(DestinationLocation->Y()));
				destination_location_obj["Z"] = static_cast<int>(std::round(DestinationLocation->Z()));
				json::object sender_location_obj;
				sender_location_obj["X"] = static_cast<int>(std::round(SenderAbsoluteLocation->X()));
				sender_location_obj["Y"] = static_cast<int>(std::round(SenderAbsoluteLocation->Y()));
				sender_location_obj["Z"] = static_cast<int>(std::round(SenderAbsoluteLocation->Z()));

				cargos_payload.push_back({
					{"Net_CargoKey", json::string(to_string(CargoKey->ToString()))},
					{"Net_DeliveryId", *DeliveryId},
					{"Net_Payment", *BasePayment},
					{"Net_Damage", *Damage},
					{"Net_Weight", *Weight},
					{"Net_TimeLeftSeconds", *TimeLeftSeconds},
					{"Net_DestinationLocation", destination_location_obj},
					{"Net_SenderAbsoluteLocation", sender_location_obj}
					});
			}
			event_data["Cargos"] = cargos_payload;
			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerResetVehicleAt"),
		"ServerResetVehicleAt"
	);

	/*
	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerContractCargoDelivered"),
		"ServerContractCargoDelivered",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			auto ContractGuidProperty = FunctionBeingExecuted->GetPropertyByName(STR("ContractGuid"));
			const auto& ContractGuid = ContractGuidProperty->ContainerPtrToValuePtr<FGuid>(Context.TheStack.Locals());
			if (ContractGuid == nullptr) return false;
			event_data["ContractGuid"] = std::format(
				"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
				ContractGuid->A,
				(ContractGuid->B >> 16),    // High 16 bits of B
				(ContractGuid->B & 0xFFFF), // Low 16 bits of B
				(ContractGuid->C >> 16),    // High 16 bits of C
				(ContractGuid->C & 0xFFFF), // Low 16 bits of C
				ContractGuid->D
			);
			const auto& PlayerController = Context.Context;
			const auto& CompaniesProperty = static_cast<FArrayProperty*>(PlayerController->GetPropertyByNameInChain(STR("Companies")));
			if (!CompaniesProperty) {
				Output::send<LogLevel::Verbose>(STR("Companies property not found\n"));
				return false;
			}
			const auto& Companies = CompaniesProperty->ContainerPtrToValuePtr<FScriptArray>(PlayerController);
			if (Companies == nullptr || Companies->GetData() == nullptr) return false;
			const auto& CompaniesInnerProp = static_cast<FStructProperty*>(CompaniesProperty->GetInner());
			const int32 InnerPropSize = CompaniesInnerProp->GetElementSize();
			const int32 NumCompanies = Companies->Num();
			for (int32_t i = 0; i < NumCompanies; ++i) {
				// https://github.com/UE4SS-RE/RE-UE4SS/blob/e77e3d1712faad2793c4ff040ce3687a36fa5bca/UE4SS/src/GUI/LiveView.cpp#L2278
				auto element_offset = CompaniesInnerProp->GetElementSize() * i;
				auto element_container_ptr = static_cast<uint8_t*>(Companies->GetData()) + element_offset;
				const auto& TopLevelCompany = CompaniesInnerProp->GetStruct();
				const auto& Company = CompaniesInnerProp->ContainerPtrToValuePtr<void>(element_container_ptr);
				const auto& ContractsInProgressProperty = static_cast<FArrayProperty*>(TopLevelCompany->GetPropertyByNameInChain(STR("ContractsInProgress")));
				if (!ContractsInProgressProperty) {
					Output::send<LogLevel::Verbose>(STR("ContractsInProgress property not found\n"));
					return false;
				}
				const auto& ContractsInProgress = ContractsInProgressProperty->ContainerPtrToValuePtr<FScriptArray>(Company);
				if (ContractsInProgress == nullptr || ContractsInProgress->GetData() == nullptr) return false;
				const auto& CipInnerProp = static_cast<FStructProperty*>(ContractsInProgressProperty->GetInner());
				const int32 CipInnerPropSize = CipInnerProp->GetElementSize();
				const int32 NumCips = ContractsInProgress->Num();
				for (int32_t i = 0; i < NumCips; ++i) {
					auto element_offset = CipInnerProp->GetElementSize() * i;
					auto element_container_ptr = static_cast<uint8_t*>(ContractsInProgress->GetData()) + element_offset;
					auto ContractInProgress = CipInnerProp->ContainerPtrToValuePtr<void>(element_container_ptr);
					const auto& TopLevelCip = CipInnerProp->GetStruct();
					const auto& CipGuidProperty = TopLevelCip->GetPropertyByNameInChain(STR("Guid"));
					const auto& FinishedAmountProperty = TopLevelCip->GetPropertyByNameInChain(STR("FinishedAmount"));
					const auto& FinishedAmount = FinishedAmountProperty->ContainerPtrToValuePtr<float>(ContractInProgress);
					event_data["FinishedAmount"] = *FinishedAmount;
					const auto& ContractInProgressGuid = CipGuidProperty->ContainerPtrToValuePtr<FGuid>(ContractInProgress);
					if (ContractInProgressGuid == nullptr) continue;
					if (ContractGuid == ContractInProgressGuid) {
						const auto& ContractProperty = static_cast<FStructProperty*>(TopLevelCip->GetPropertyByNameInChain(STR("Contract")));
						if (!ContractProperty) {
							Output::send<LogLevel::Verbose>(STR("Contract property found\n"));
							return false;
						}
						const auto& Contract = ContractProperty->ContainerPtrToValuePtr<void>(ContractInProgress);
						if (Contract == nullptr) return false;
						const auto& TopLevelContract = ContractProperty->GetStruct();
						const auto AmountProp = TopLevelContract->GetPropertyByNameInChain(STR("Amount"));
						const auto& Amount = AmountProp->ContainerPtrToValuePtr<float>(Contract);
						event_data["Amount"] = *Amount;
						const auto ItemProp = TopLevelContract->GetPropertyByNameInChain(STR("Item"));
						const auto& Item = ItemProp->ContainerPtrToValuePtr<FString>(Contract);
						event_data["Item"] = to_string(Item->GetCharArray());
						const auto& CompletionPaymentProperty = static_cast<FStructProperty*>(TopLevelContract->GetPropertyByNameInChain(STR("CompletionPayment")));
						const auto& CompletionPayment = CompletionPaymentProperty->ContainerPtrToValuePtr<void>(Contract);
						const auto& TopLevelCompletionPayment = CompletionPaymentProperty->GetStruct();
						const auto& BaseValueProperty = TopLevelCompletionPayment->GetPropertyByNameInChain(STR("BaseValue"));
						const auto& Payment = BaseValueProperty->ContainerPtrToValuePtr<int64>(CompletionPayment);
						event_data["CompletionPayment"] = *Payment;
						return true;
					}
				}
			}

			return false;
		}
	);
	*/

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerPassengerArrived"),
		"ServerPassengerArrived",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);

			const auto& PassengerProperty = static_cast<FObjectProperty*>(FunctionBeingExecuted->GetPropertyByNameInChain(STR("PassengerComponent")));
			
			const auto& Passenger = PassengerProperty->ContainerPtrToValuePtr<UObject*>(Context.TheStack.Locals());
			if (Passenger == nullptr) return false;
			Output::send<LogLevel::Verbose>(STR("Passenger found\n"));
			const auto& Payment = (*Passenger)->GetValuePtrByPropertyNameInChain<int64>(STR("Net_Payment"));
			const auto& PassengerType = (*Passenger)->GetValuePtrByPropertyNameInChain<uint8>(STR("Net_PassengerType"));
			const auto& StartLocation = (*Passenger)->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_StartLocation"));
			const auto& DestinationLocation = (*Passenger)->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_DestinationLocation"));
			const auto& Distance = (*Passenger)->GetValuePtrByPropertyNameInChain<float>(STR("Net_Distance"));
			const auto& PassengerFlags = (*Passenger)->GetValuePtrByPropertyNameInChain<int32>(STR("Net_PassengerFlags"));
			const auto& LCComfortSatisfaction = (*Passenger)->GetValuePtrByPropertyNameInChain<int32>(STR("Net_LCComfortSatisfaction"));
			const auto& TimeLimitPoint = (*Passenger)->GetValuePtrByPropertyNameInChain<int32>(STR("Net_TimeLimitPoint"));
			const auto& TimeLimitToDestination = (*Passenger)->GetValuePtrByPropertyNameInChain<float>(STR("Net_TimeLimitToDestination"));
			const auto& TimeLimitToDestinationFromStart = (*Passenger)->GetValuePtrByPropertyNameInChain<float>(STR("Net_TimeLimitToDestinationFromStart"));

			if (!Payment || !PassengerType || !Distance || !PassengerFlags || !LCComfortSatisfaction || !TimeLimitPoint || !TimeLimitToDestination || !TimeLimitToDestinationFromStart
				|| !StartLocation || !DestinationLocation) {
				Output::send<LogLevel::Verbose>(STR("Missing information\n")); 
				return false;
			}

			json::object passenger_obj;
			passenger_obj["Net_Payment"] = *Payment;
			passenger_obj["Net_PassengerType"] = *PassengerType;
			passenger_obj["Net_Distance"] = *Distance;
			passenger_obj["Net_PassengerFlags"] = *PassengerFlags;
			passenger_obj["Net_LCComfortSatisfaction"] = *LCComfortSatisfaction;
			passenger_obj["Net_TimeLimitPoint"] = *TimeLimitPoint;
			passenger_obj["Net_TimeLimitToDestination"] = *TimeLimitToDestination;
			passenger_obj["Net_TimeLimitToDestinationFromStart"] = *TimeLimitToDestinationFromStart;

			json::object destination_location_obj;
			destination_location_obj["X"] = static_cast<int>(std::round(DestinationLocation->X()));
			destination_location_obj["Y"] = static_cast<int>(std::round(DestinationLocation->Y()));
			destination_location_obj["Z"] = static_cast<int>(std::round(DestinationLocation->Z()));
			passenger_obj["Net_DestinationLocation"] = destination_location_obj;
			json::object start_location_obj;
			start_location_obj["X"] = static_cast<int>(std::round(StartLocation->X()));
			start_location_obj["Y"] = static_cast<int>(std::round(StartLocation->Y()));
			start_location_obj["Z"] = static_cast<int>(std::round(StartLocation->Z()));
			passenger_obj["Net_StartLocation"] = start_location_obj;

			event_data["Passenger"] = passenger_obj;
			return true;
		}
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
