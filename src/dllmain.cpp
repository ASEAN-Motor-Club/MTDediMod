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

MotorTownMods::~MotorTownMods()
{
	HookManager::UnregisterAllHooks();
}

auto MotorTownMods::on_unreal_init() -> void
{
	HookManager::UnregisterAllHooks(); // Prevent duplicate hooks on hot-reload if destructor wasn't fully processed

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

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerContractCargoDelivered"),
		"ServerContractCargoDelivered",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			auto ContractGuidProperty = FunctionBeingExecuted->GetPropertyByName(STR("ContractGuid"));
			if (!ContractGuidProperty) {
				Output::send<LogLevel::Verbose>(STR("ContractGuid property not found on FunctionBeingExecuted\n"));
				return false;
			}
			const auto& ContractGuid = ContractGuidProperty->ContainerPtrToValuePtr<FGuid>(Context.TheStack.Locals());
			if (ContractGuid == nullptr) {
				Output::send<LogLevel::Verbose>(STR("ContractGuid value is null\n"));
				return false;
			}

			std::string guid_str = std::format(
				"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
				ContractGuid->A,
				(ContractGuid->B >> 16),    // High 16 bits of B
				(ContractGuid->B & 0xFFFF), // Low 16 bits of B
				(ContractGuid->C >> 16),    // High 16 bits of C
				(ContractGuid->C & 0xFFFF), // Low 16 bits of C
				ContractGuid->D
			);
			event_data["ContractGuid"] = guid_str;
			Output::send<LogLevel::Verbose>(STR("ServerContractCargoDelivered: Processing ContractGuid {}\n"), to_wstring(guid_str));

			const auto& PlayerController = Context.Context;
			if (!PlayerController) {
				Output::send<LogLevel::Verbose>(STR("PlayerController context is null\n"));
				return false;
			}

			// Try "Companies" first
			auto CompaniesProperty = static_cast<FArrayProperty*>(PlayerController->GetPropertyByNameInChain(STR("Companies")));
			if (!CompaniesProperty) {
				// Try fallback "Net_CompaniesBase"
				CompaniesProperty = static_cast<FArrayProperty*>(PlayerController->GetPropertyByNameInChain(STR("Net_CompaniesBase")));
			}

			if (!CompaniesProperty) {
				Output::send<LogLevel::Verbose>(STR("Neither Companies nor Net_CompaniesBase property found\n"));
				return false;
			}

			const auto& Companies = CompaniesProperty->ContainerPtrToValuePtr<FScriptArray>(PlayerController);
			if (Companies == nullptr || Companies->GetData() == nullptr) {
				Output::send<LogLevel::Verbose>(STR("Companies array data is null\n"));
				return false;
			}

			const auto& CompaniesInnerProp = static_cast<FStructProperty*>(CompaniesProperty->GetInner());
			if (!CompaniesInnerProp) {
				Output::send<LogLevel::Verbose>(STR("CompaniesInnerProp is null\n"));
				return false;
			}

			const int32 InnerPropSize = CompaniesInnerProp->GetElementSize();
			const int32 NumCompanies = Companies->Num();
			Output::send<LogLevel::Verbose>(STR("Searching through {} companies\n"), NumCompanies);

			for (int32_t i = 0; i < NumCompanies; ++i) {
				auto element_offset = InnerPropSize * i;
				auto element_container_ptr = static_cast<uint8_t*>(Companies->GetData()) + element_offset;
				const auto& TopLevelCompany = CompaniesInnerProp->GetStruct();
				if (!TopLevelCompany) continue;

				const auto& Company = CompaniesInnerProp->ContainerPtrToValuePtr<void>(element_container_ptr);
				if (!Company) continue;

				const auto& ContractsInProgressProperty = static_cast<FArrayProperty*>(TopLevelCompany->GetPropertyByNameInChain(STR("ContractsInProgress")));
				if (!ContractsInProgressProperty) {
					Output::send<LogLevel::Verbose>(STR("Company {}: ContractsInProgress property not found\n"), i);
					continue;
				}

				const auto& ContractsInProgress = ContractsInProgressProperty->ContainerPtrToValuePtr<FScriptArray>(Company);
				if (ContractsInProgress == nullptr || ContractsInProgress->GetData() == nullptr) {
					Output::send<LogLevel::Verbose>(STR("Company {}: ContractsInProgress array data is null\n"), i);
					continue;
				}

				const auto& CipInnerProp = static_cast<FStructProperty*>(ContractsInProgressProperty->GetInner());
				if (!CipInnerProp) continue;

				const int32 CipInnerPropSize = CipInnerProp->GetElementSize();
				const int32 NumCips = ContractsInProgress->Num();
				Output::send<LogLevel::Verbose>(STR("Company {}: searching through {} ContractsInProgress\n"), i, NumCips);

				for (int32_t j = 0; j < NumCips; ++j) {
					auto cip_element_offset = CipInnerPropSize * j;
					auto cip_element_container_ptr = static_cast<uint8_t*>(ContractsInProgress->GetData()) + cip_element_offset;
					auto ContractInProgress = CipInnerProp->ContainerPtrToValuePtr<void>(cip_element_container_ptr);
					if (!ContractInProgress) continue;

					const auto& TopLevelCip = CipInnerProp->GetStruct();
					if (!TopLevelCip) continue;

					const auto& CipGuidProperty = TopLevelCip->GetPropertyByNameInChain(STR("Guid"));
					const auto& FinishedAmountProperty = TopLevelCip->GetPropertyByNameInChain(STR("FinishedAmount"));
					if (!CipGuidProperty || !FinishedAmountProperty) continue;

					const auto& ContractInProgressGuid = CipGuidProperty->ContainerPtrToValuePtr<FGuid>(ContractInProgress);
					if (ContractInProgressGuid == nullptr) continue;

					std::string cip_guid_str = std::format(
						"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
						ContractInProgressGuid->A,
						(ContractInProgressGuid->B >> 16),
						(ContractInProgressGuid->B & 0xFFFF),
						(ContractInProgressGuid->C >> 16),
						(ContractInProgressGuid->C & 0xFFFF),
						ContractInProgressGuid->D
					);
					Output::send<LogLevel::Verbose>(STR("  CIP {}: comparing with {}\n"), j, to_wstring(cip_guid_str));

					if (ContractGuid->A == ContractInProgressGuid->A &&
						ContractGuid->B == ContractInProgressGuid->B &&
						ContractGuid->C == ContractInProgressGuid->C &&
						ContractGuid->D == ContractInProgressGuid->D) {

						Output::send<LogLevel::Verbose>(STR("  Match found for ContractGuid!\n"));

						const auto& FinishedAmount = FinishedAmountProperty->ContainerPtrToValuePtr<float>(ContractInProgress);
						if (FinishedAmount) {
							event_data["FinishedAmount"] = *FinishedAmount;
						}

						const auto& ContractProperty = static_cast<FStructProperty*>(TopLevelCip->GetPropertyByNameInChain(STR("Contract")));
						if (!ContractProperty) {
							Output::send<LogLevel::Verbose>(STR("Contract property not found in Struct\n"));
							continue;
						}

						const auto& Contract = ContractProperty->ContainerPtrToValuePtr<void>(ContractInProgress);
						if (Contract == nullptr) continue;

						const auto& TopLevelContract = ContractProperty->GetStruct();
						if (!TopLevelContract) continue;

						const auto AmountProp = TopLevelContract->GetPropertyByNameInChain(STR("Amount"));
						if (AmountProp) {
							const auto& Amount = AmountProp->ContainerPtrToValuePtr<float>(Contract);
							if (Amount) event_data["Amount"] = *Amount;
						}

						const auto ItemProp = TopLevelContract->GetPropertyByNameInChain(STR("Item"));
						if (ItemProp) {
							const auto& Item = ItemProp->ContainerPtrToValuePtr<FString>(Contract);
							if (Item && Item->GetCharArray().GetData()) {
								event_data["Item"] = to_string(Item->GetCharArray().GetData());
							}
						}

						const auto& CompletionPaymentProperty = static_cast<FStructProperty*>(TopLevelContract->GetPropertyByNameInChain(STR("CompletionPayment")));
						if (CompletionPaymentProperty) {
							const auto& CompletionPayment = CompletionPaymentProperty->ContainerPtrToValuePtr<void>(Contract);
							const auto& TopLevelCompletionPayment = CompletionPaymentProperty->GetStruct();
							if (CompletionPayment && TopLevelCompletionPayment) {
								const auto& BasePaymentValueProperty = TopLevelCompletionPayment->GetPropertyByNameInChain(STR("BaseValue"));
								if (BasePaymentValueProperty) {
									const auto& Payment = BasePaymentValueProperty->ContainerPtrToValuePtr<int64>(CompletionPayment);
									if (Payment) event_data["CompletionPayment"] = *Payment;
								}
							}
						}
						return true;
					}
				}
			}

			Output::send<LogLevel::Verbose>(STR("ServerContractCargoDelivered: ContractGuid not found in any company contracts\n"));
			return false;
		}
	);

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

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerTowRequestArrived"),
		"ServerTowRequestArrived",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);

			// --- Step 1: Get TowRequestComponent from function params ---
			auto TowRequestComponentProp = static_cast<FObjectProperty*>(
				FunctionBeingExecuted->GetPropertyByNameInChain(STR("TowRequestComponent")));
			if (!TowRequestComponentProp) {
				Output::send<LogLevel::Warning>(STR("ServerTowRequestArrived: TowRequestComponent property not found on function\n"));
				return false;
			}
			Output::send<LogLevel::Verbose>(STR("ServerTowRequestArrived: found TowRequestComponentProp\n"));

			const auto& TowRequestComponent = TowRequestComponentProp->ContainerPtrToValuePtr<UObject*>(
				Context.TheStack.Locals());
			if (TowRequestComponent == nullptr) {
				Output::send<LogLevel::Warning>(STR("ServerTowRequestArrived: TowRequestComponent container ptr is null\n"));
				return false;
			}
			if (*TowRequestComponent == nullptr) {
				Output::send<LogLevel::Warning>(STR("ServerTowRequestArrived: TowRequestComponent deref is null\n"));
				return false;
			}
			Output::send<LogLevel::Verbose>(STR("ServerTowRequestArrived: got TowRequestComponent object\n"));

			// --- Step 2-5: Extract direct properties from TowRequestComponent ---
			const auto& Payment = (*TowRequestComponent)->GetValuePtrByPropertyNameInChain<int64>(STR("Net_Payment"));
			const auto& StartLocation = (*TowRequestComponent)->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_StartLocation"));
			const auto& DestLocation = (*TowRequestComponent)->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_DestinationAbsoluteLocation"));
			const auto& TowRequestFlags = (*TowRequestComponent)->GetValuePtrByPropertyNameInChain<int32>(STR("Net_TowRequestFlags"));

			Output::send<LogLevel::Verbose>(STR("ServerTowRequestArrived: Payment={} StartLoc={} DestLoc={} Flags={}\n"),
				Payment ? 1 : 0, StartLocation ? 1 : 0, DestLocation ? 1 : 0, TowRequestFlags ? 1 : 0);

			if (!Payment || !StartLocation || !DestLocation) {
				Output::send<LogLevel::Warning>(STR("ServerTowRequestArrived: missing core TowRequest properties\n"));
				return false;
			}

			json::object tow_obj;
			tow_obj["Net_Payment"] = *Payment;
			if (TowRequestFlags) tow_obj["Net_TowRequestFlags"] = *TowRequestFlags;

			json::object start_loc;
			start_loc["X"] = static_cast<int>(std::round(StartLocation->X()));
			start_loc["Y"] = static_cast<int>(std::round(StartLocation->Y()));
			start_loc["Z"] = static_cast<int>(std::round(StartLocation->Z()));
			tow_obj["Net_StartLocation"] = start_loc;

			json::object dest_loc;
			dest_loc["X"] = static_cast<int>(std::round(DestLocation->X()));
			dest_loc["Y"] = static_cast<int>(std::round(DestLocation->Y()));
			dest_loc["Z"] = static_cast<int>(std::round(DestLocation->Z()));
			tow_obj["Net_DestinationAbsoluteLocation"] = dest_loc;

			// --- Step 6: Navigate to parent AMTVehicle via Outer ---
			// Usually components are nested under the Actor/Vehicle.
			UObject* Vehicle = (*TowRequestComponent)->GetOuterPrivate();
			if (!Vehicle) {
				Output::send<LogLevel::Warning>(STR("ServerTowRequestArrived: could not resolve outer Vehicle\n"));
				event_data["TowRequest"] = tow_obj;
				return true; // still send partial payload
			}

			// --- Step 7: Extract Body Damage from Vehicle->Net_Parts ---
			auto PartsProp = static_cast<FArrayProperty*>(
				Vehicle->GetPropertyByNameInChain(STR("Net_Parts")));
			if (PartsProp) {
				auto Parts = PartsProp->ContainerPtrToValuePtr<FScriptArray>(Vehicle);
				if (Parts && Parts->GetData()) {
					auto PartsInnerProp = static_cast<FStructProperty*>(PartsProp->GetInner());
					if (PartsInnerProp) {
						int32 PartSize = PartsInnerProp->GetElementSize();
						int32 NumParts = Parts->Num();
						auto PartsStruct = PartsInnerProp->GetStruct();
						if (PartsStruct) {
							for (int32 i = 0; i < NumParts; ++i) {
								auto partPtr = static_cast<uint8_t*>(Parts->GetData()) + (PartSize * i);
								auto partContainer = PartsInnerProp->ContainerPtrToValuePtr<void>(partPtr);
								if (!partContainer) continue;

								auto SlotProp = PartsStruct->GetPropertyByNameInChain(STR("Slot"));
								if (!SlotProp) continue;
								auto Slot = SlotProp->ContainerPtrToValuePtr<uint8>(partContainer);
								if (!Slot || *Slot != 1) continue; // 1 = EMTVehiclePartSlot::Body

								auto DamageProp = PartsStruct->GetPropertyByNameInChain(STR("Damage"));
								if (DamageProp) {
									auto Damage = DamageProp->ContainerPtrToValuePtr<float>(partContainer);
									if (Damage) {
										tow_obj["BodyDamage"] = *Damage;
									}
								}
								break;
							}
						}
					}
				}
			}

			event_data["TowRequest"] = tow_obj;
			return true;
		}
	);

	// ========== Police Work Hooks ==========

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerArrivedAtPolicePatrolPoint"),
		"ServerArrivedAtPolicePatrolPoint",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			Output::send<LogLevel::Verbose>(STR("ServerArrivedAtPolicePatrolPoint: starting extraction\n"));

			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) {
				Output::send<LogLevel::Warning>(STR("ServerArrivedAtPolicePatrolPoint: FunctionBeingExecuted is null\n"));
				return false;
			}

			// --- Extract PatrolPointId ---
			auto PatrolPointIdProp = FunctionBeingExecuted->GetPropertyByName(STR("PatrolPointId"));
			if (!PatrolPointIdProp) {
				Output::send<LogLevel::Warning>(STR("ServerArrivedAtPolicePatrolPoint: PatrolPointId property not found\n"));
				return false;
			}
			auto PatrolPointId = PatrolPointIdProp->ContainerPtrToValuePtr<int32>(Context.TheStack.Locals());
			if (!PatrolPointId) {
				Output::send<LogLevel::Warning>(STR("ServerArrivedAtPolicePatrolPoint: PatrolPointId value ptr is null\n"));
				return false;
			}

			Output::send<LogLevel::Verbose>(STR("ServerArrivedAtPolicePatrolPoint: PatrolPointId={}\n"), *PatrolPointId);
			event_data["PatrolPointId"] = *PatrolPointId;
			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerSelectPolicePullOverPenaltyResponse"),
		"ServerSelectPolicePullOverPenaltyResponse",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			Output::send<LogLevel::Verbose>(STR("ServerSelectPolicePullOverPenaltyResponse: starting extraction\n"));

			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) {
				Output::send<LogLevel::Warning>(STR("ServerSelectPolicePullOverPenaltyResponse: FunctionBeingExecuted is null\n"));
				return false;
			}

			// --- Extract bWarningOnly ---
			auto bWarningOnlyProp = FunctionBeingExecuted->GetPropertyByName(STR("bWarningOnly"));
			if (!bWarningOnlyProp) {
				Output::send<LogLevel::Warning>(STR("ServerSelectPolicePullOverPenaltyResponse: bWarningOnly property not found\n"));
				return false;
			}
			auto bWarningOnly = bWarningOnlyProp->ContainerPtrToValuePtr<bool>(Context.TheStack.Locals());
			if (!bWarningOnly) {
				Output::send<LogLevel::Warning>(STR("ServerSelectPolicePullOverPenaltyResponse: bWarningOnly value ptr is null\n"));
				return false;
			}

			Output::send<LogLevel::Verbose>(STR("ServerSelectPolicePullOverPenaltyResponse: bWarningOnly={}\n"), *bWarningOnly ? 1 : 0);
			event_data["bWarningOnly"] = *bWarningOnly;
			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerAddPolicePlayer"),
		"ServerAddPolicePlayer"
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerRemovePolicePlayer"),
		"ServerRemovePolicePlayer"
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
				lua_net.set_string(to_string(*uniqueIdString));
				return 1;
			}
		}
		lua_net.set_string("");

		return 1;
		});
}
