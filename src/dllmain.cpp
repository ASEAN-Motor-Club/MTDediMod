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
			if (!FunctionBeingExecuted) return false;

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
		STR("/Script/MotorTown.MotorTownPlayerController:ServerLoadCargo"),
		"ServerLoadCargo",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			// --- Extract Cargo (AMTCargo) from function params ---
			auto CargoProp = static_cast<FObjectProperty*>(
				FunctionBeingExecuted->GetPropertyByNameInChain(STR("Cargo")));
			if (!CargoProp) {
				Output::send<LogLevel::Warning>(STR("ServerLoadCargo: Cargo property not found\n"));
				return false;
			}

			const auto& CargoPtr = CargoProp->ContainerPtrToValuePtr<UObject*>(Context.TheStack.Locals());
			if (CargoPtr == nullptr || *CargoPtr == nullptr) {
				Output::send<LogLevel::Warning>(STR("ServerLoadCargo: Cargo object is null\n"));
				return false;
			}
			auto cargo = *CargoPtr;

			// --- Extract bReposition ---
			auto bRepositionProp = FunctionBeingExecuted->GetPropertyByName(STR("bReposition"));
			if (bRepositionProp) {
				auto bReposition = bRepositionProp->ContainerPtrToValuePtr<bool>(Context.TheStack.Locals());
				if (bReposition) event_data["bReposition"] = *bReposition;
			}

			// --- Extract cargo properties (same as ServerCargoArrived) ---
			const auto& CargoKey = cargo->GetValuePtrByPropertyNameInChain<FName>(STR("Net_CargoKey"));
			const auto& Damage = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_Damage"));
			const auto& Weight = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_Weight"));
			const auto& TimeLeftSeconds = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_TimeLeftSeconds"));
			const auto& DeliveryId = cargo->GetValuePtrByPropertyNameInChain<int32>(STR("Net_DeliveryId"));
			const auto& DestinationLocation = cargo->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_DestinationLocation"));
			const auto& SenderAbsoluteLocation = cargo->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_SenderAbsoluteLocation"));
			auto PaymentProperty = static_cast<FStructProperty*>(cargo->GetPropertyByNameInChain(STR("Net_Payment")));
			if (!PaymentProperty) return false;

			auto TopLevelPayment = PaymentProperty->GetStruct();
			auto Payment = PaymentProperty->ContainerPtrToValuePtr<void>(cargo);
			if (Payment == nullptr) return false;

			auto BaseValueProperty = TopLevelPayment->GetPropertyByNameInChain(STR("BaseValue"));
			if (!BaseValueProperty) return false;

			auto BasePayment = BaseValueProperty->ContainerPtrToValuePtr<int64>(Payment);

			if (!CargoKey || !Damage || !Weight || !TimeLeftSeconds || !DeliveryId || !DestinationLocation || !SenderAbsoluteLocation || !BasePayment) {
				Output::send<LogLevel::Warning>(STR("ServerLoadCargo: missing cargo property\n"));
				return false;
			}

			json::object destination_location_obj;
			destination_location_obj["X"] = static_cast<int>(std::round(DestinationLocation->X()));
			destination_location_obj["Y"] = static_cast<int>(std::round(DestinationLocation->Y()));
			destination_location_obj["Z"] = static_cast<int>(std::round(DestinationLocation->Z()));
			json::object sender_location_obj;
			sender_location_obj["X"] = static_cast<int>(std::round(SenderAbsoluteLocation->X()));
			sender_location_obj["Y"] = static_cast<int>(std::round(SenderAbsoluteLocation->Y()));
			sender_location_obj["Z"] = static_cast<int>(std::round(SenderAbsoluteLocation->Z()));

			json::object cargo_obj;
			cargo_obj["Net_CargoKey"] = json::string(to_string(CargoKey->ToString()));
			cargo_obj["Net_DeliveryId"] = *DeliveryId;
			cargo_obj["Net_Payment"] = *BasePayment;
			cargo_obj["Net_Damage"] = *Damage;
			cargo_obj["Net_Weight"] = *Weight;
			cargo_obj["Net_TimeLeftSeconds"] = *TimeLeftSeconds;
			cargo_obj["Net_DestinationLocation"] = destination_location_obj;
			cargo_obj["Net_SenderAbsoluteLocation"] = sender_location_obj;

			event_data["Cargo"] = cargo_obj;
			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerPickupCargo"),
		"ServerPickupCargo",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction();
			if (!FunctionBeingExecuted) {
				Output::send<LogLevel::Warning>(STR("ServerPickupCargo: FunctionBeingExecuted is null\n"));
				return false;
			}

			// --- Extract Cargo (AMTCargo) from function params ---
			auto CargoProp = static_cast<FObjectProperty*>(
				FunctionBeingExecuted->GetPropertyByName(STR("Cargo")));
			if (!CargoProp) {
				Output::send<LogLevel::Warning>(STR("ServerPickupCargo: Cargo property not found\n"));
				return false;
			}

			const auto& CargoPtr = CargoProp->ContainerPtrToValuePtr<UObject*>(Context.TheStack.Locals());
			if (CargoPtr == nullptr || *CargoPtr == nullptr) {
				Output::send<LogLevel::Warning>(STR("ServerPickupCargo: Cargo object is null\n"));
				return false;
			}
			auto cargo = *CargoPtr;

			// --- Extract cargo properties ---
			const auto& CargoKey = cargo->GetValuePtrByPropertyNameInChain<FName>(STR("Net_CargoKey"));
			const auto& Damage = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_Damage"));
			const auto& Weight = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_Weight"));
			const auto& TimeLeftSeconds = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_TimeLeftSeconds"));
			const auto& DeliveryId = cargo->GetValuePtrByPropertyNameInChain<int32>(STR("Net_DeliveryId"));

			if (!CargoKey) {
				Output::send<LogLevel::Warning>(STR("ServerPickupCargo: CargoKey is null\n"));
				return false;
			}

			json::object cargo_obj;
			cargo_obj["Net_CargoKey"] = json::string(to_string(CargoKey->ToString()));
			if (DeliveryId) cargo_obj["Net_DeliveryId"] = *DeliveryId;
			if (Damage) cargo_obj["Net_Damage"] = *Damage;
			if (Weight) cargo_obj["Net_Weight"] = *Weight;
			if (TimeLeftSeconds) cargo_obj["Net_TimeLeftSeconds"] = *TimeLeftSeconds;

			// --- Extract Payment (optional) ---
			auto PaymentProperty = static_cast<FStructProperty*>(cargo->GetPropertyByNameInChain(STR("Net_Payment")));
			if (PaymentProperty) {
				auto TopLevelPayment = PaymentProperty->GetStruct();
				auto Payment = PaymentProperty->ContainerPtrToValuePtr<void>(cargo);
				if (Payment && TopLevelPayment) {
					auto BaseValueProperty = TopLevelPayment->GetPropertyByNameInChain(STR("BaseValue"));
					if (BaseValueProperty) {
						auto BasePayment = BaseValueProperty->ContainerPtrToValuePtr<int64>(Payment);
						if (BasePayment) {
							cargo_obj["Net_Payment"] = *BasePayment;
						}
					}
				}
			}

			// --- Extract previous owner info (optional) ---
			auto OwnerNameProp = cargo->GetPropertyByNameInChain(STR("Net_OwnerName"));
			if (OwnerNameProp) {
				const auto& OwnerName = OwnerNameProp->ContainerPtrToValuePtr<FString>(cargo);
				if (OwnerName && OwnerName->GetCharArray().GetData()) {
					cargo_obj["Net_OwnerName"] = json::string(to_string(OwnerName->GetCharArray().GetData()));
				}
			}

			// Server_LastMovementOwnerPC -> PlayerState -> CharacterGuid (optional)
			auto LastOwnerPCProp = static_cast<FObjectProperty*>(
				cargo->GetPropertyByNameInChain(STR("Server_LastMovementOwnerPC")));
			if (LastOwnerPCProp) {
				const auto& LastOwnerPC = LastOwnerPCProp->ContainerPtrToValuePtr<UObject*>(cargo);
				if (LastOwnerPC && *LastOwnerPC) {
					auto PrevPlayerState = (*LastOwnerPC)->GetValuePtrByPropertyNameInChain<UObject*>(STR("PlayerState"));
					if (PrevPlayerState && *PrevPlayerState) {
						const auto& PrevCharGuid = (*PrevPlayerState)->GetValuePtrByPropertyName<FGuid>(STR("CharacterGuid"));
						if (PrevCharGuid) {
							cargo_obj["PreviousOwnerCharacterGuid"] = json::string(std::format(
								"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
								PrevCharGuid->A,
								(PrevCharGuid->B >> 16),
								(PrevCharGuid->B & 0xFFFF),
								(PrevCharGuid->C >> 16),
								(PrevCharGuid->C & 0xFFFF),
								PrevCharGuid->D
							));
						}
					}
				}
			}

			event_data["Cargo"] = cargo_obj;
			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerResetVehicleAt"),
		"ServerResetVehicleAt"
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerSignContract"),
		"ServerSignContract",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			// --- Extract Contract struct from function params ---
			auto ContractProperty = static_cast<FStructProperty*>(FunctionBeingExecuted->GetPropertyByName(STR("Contract")));
			if (!ContractProperty) {
				Output::send<LogLevel::Verbose>(STR("ServerSignContract: Contract property not found\n"));
				return false;
			}
			const auto& Contract = ContractProperty->ContainerPtrToValuePtr<void>(Context.TheStack.Locals());
			if (!Contract) {
				Output::send<LogLevel::Verbose>(STR("ServerSignContract: Contract value is null\n"));
				return false;
			}

			const auto& ContractStruct = ContractProperty->GetStruct();
			if (!ContractStruct) return false;

			// Extract Contract fields
			json::object contract_obj;

			const auto ItemProp = ContractStruct->GetPropertyByNameInChain(STR("Item"));
			if (ItemProp) {
				const auto& Item = ItemProp->ContainerPtrToValuePtr<FString>(Contract);
				if (Item && Item->GetCharArray().GetData()) {
					contract_obj["Item"] = to_string(Item->GetCharArray().GetData());
				}
			}

			const auto AmountProp = ContractStruct->GetPropertyByNameInChain(STR("Amount"));
			if (AmountProp) {
				const auto& Amount = AmountProp->ContainerPtrToValuePtr<float>(Contract);
				if (Amount) contract_obj["Amount"] = *Amount;
			}

			const auto CompletionPaymentProp = static_cast<FStructProperty*>(ContractStruct->GetPropertyByNameInChain(STR("CompletionPayment")));
			if (CompletionPaymentProp) {
				const auto& CompletionPayment = CompletionPaymentProp->ContainerPtrToValuePtr<void>(Contract);
				const auto& CompletionPaymentStruct = CompletionPaymentProp->GetStruct();
				if (CompletionPayment && CompletionPaymentStruct) {
					const auto BaseValueProp = CompletionPaymentStruct->GetPropertyByNameInChain(STR("BaseValue"));
					if (BaseValueProp) {
						const auto& BaseValue = BaseValueProp->ContainerPtrToValuePtr<int64>(CompletionPayment);
						if (BaseValue) {
							json::object payment_obj;
							payment_obj["BaseValue"] = *BaseValue;
							contract_obj["CompletionPayment"] = payment_obj;
						}
					}
				}
			}

			const auto CostProp = static_cast<FStructProperty*>(ContractStruct->GetPropertyByNameInChain(STR("Cost")));
			if (CostProp) {
				const auto& Cost = CostProp->ContainerPtrToValuePtr<void>(Contract);
				const auto& CostStruct = CostProp->GetStruct();
				if (Cost && CostStruct) {
					const auto BaseValueProp = CostStruct->GetPropertyByNameInChain(STR("BaseValue"));
					if (BaseValueProp) {
						const auto& BaseValue = BaseValueProp->ContainerPtrToValuePtr<int64>(Cost);
						if (BaseValue) {
							json::object cost_obj;
							cost_obj["BaseValue"] = *BaseValue;
							contract_obj["Cost"] = cost_obj;
						}
					}
				}
			}

			event_data["Contract"] = contract_obj;

			// --- Traverse Companies → ContractsInProgress to find ContractGuid ---
			const auto& PlayerController = Context.Context;
			if (!PlayerController) return false;

			auto CompaniesProperty = static_cast<FArrayProperty*>(PlayerController->GetPropertyByNameInChain(STR("Companies")));
			if (!CompaniesProperty) {
				CompaniesProperty = static_cast<FArrayProperty*>(PlayerController->GetPropertyByNameInChain(STR("Net_CompaniesBase")));
			}
			if (!CompaniesProperty) return true; // Still emit without guid

			const auto& Companies = CompaniesProperty->ContainerPtrToValuePtr<FScriptArray>(PlayerController);
			if (!Companies || !Companies->GetData()) return true;

			const auto& CompaniesInnerProp = static_cast<FStructProperty*>(CompaniesProperty->GetInner());
			if (!CompaniesInnerProp) return true;

			const int32 InnerPropSize = CompaniesInnerProp->GetElementSize();
			const int32 NumCompanies = Companies->Num();

			for (int32_t i = 0; i < NumCompanies; ++i) {
				auto elem_ptr = static_cast<uint8_t*>(Companies->GetData()) + InnerPropSize * i;
				const auto& CompanyStruct = CompaniesInnerProp->GetStruct();
				if (!CompanyStruct) continue;
				const auto& Company = CompaniesInnerProp->ContainerPtrToValuePtr<void>(elem_ptr);
				if (!Company) continue;

				const auto CipArrayProp = static_cast<FArrayProperty*>(CompanyStruct->GetPropertyByNameInChain(STR("ContractsInProgress")));
				if (!CipArrayProp) continue;
				const auto& CipArray = CipArrayProp->ContainerPtrToValuePtr<FScriptArray>(Company);
				if (!CipArray || !CipArray->GetData()) continue;

				const auto& CipInnerProp = static_cast<FStructProperty*>(CipArrayProp->GetInner());
				if (!CipInnerProp) continue;
				const int32 CipSize = CipInnerProp->GetElementSize();
				const int32 NumCips = CipArray->Num();

				// The most recently signed contract is typically the last element
				for (int32_t j = NumCips - 1; j >= 0; --j) {
					auto cip_ptr = static_cast<uint8_t*>(CipArray->GetData()) + CipSize * j;
					const auto& CipStruct = CipInnerProp->GetStruct();
					if (!CipStruct) continue;
					auto ContractInProgress = CipInnerProp->ContainerPtrToValuePtr<void>(cip_ptr);
					if (!ContractInProgress) continue;

					const auto GuidProp = CipStruct->GetPropertyByNameInChain(STR("Guid"));
					if (!GuidProp) continue;
					const auto& Guid = GuidProp->ContainerPtrToValuePtr<FGuid>(ContractInProgress);
					if (!Guid) continue;

					std::string guid_str = std::format(
						"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
						Guid->A,
						(Guid->B >> 16),
						(Guid->B & 0xFFFF),
						(Guid->C >> 16),
						(Guid->C & 0xFFFF),
						Guid->D
					);
					event_data["ContractGuid"] = guid_str;
					Output::send<LogLevel::Verbose>(STR("ServerSignContract: ContractGuid = {}\n"), to_wstring(guid_str));
					return true;
				}
			}

			// No ContractGuid found, still emit with contract data
			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerContractCargoDelivered"),
		"ServerContractCargoDelivered",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			// Lightweight: extract ContractGuid only, no company traversal
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			auto ContractGuidProperty = FunctionBeingExecuted->GetPropertyByName(STR("ContractGuid"));
			if (!ContractGuidProperty) return false;

			const auto& ContractGuid = ContractGuidProperty->ContainerPtrToValuePtr<FGuid>(Context.TheStack.Locals());
			if (!ContractGuid) return false;

			event_data["ContractGuid"] = std::format(
				"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
				ContractGuid->A,
				(ContractGuid->B >> 16),
				(ContractGuid->B & 0xFFFF),
				(ContractGuid->C >> 16),
				(ContractGuid->C & 0xFFFF),
				ContractGuid->D
			);
			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerPassengerArrived"),
		"ServerPassengerArrived",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);

			auto PassengerProperty = static_cast<FObjectProperty*>(FunctionBeingExecuted->GetPropertyByNameInChain(STR("PassengerComponent")));
			if (!PassengerProperty) {
				Output::send<LogLevel::Warning>(STR("ServerPassengerArrived: PassengerComponent property not found\n"));
				return false;
			}

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
			const auto& SearchAndRescueRadiusRatio = (*Passenger)->GetValuePtrByPropertyNameInChain<float>(STR("Net_SearchAndRescueRadiusRatio"));

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
			if (SearchAndRescueRadiusRatio) passenger_obj["Net_SearchAndRescueRadiusRatio"] = *SearchAndRescueRadiusRatio;

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

	// AddPoliceSuspect(policeObject, characterObject) -> bool
	// Natively pushes a suspect entry into AMTPolice::Net_Suspects TArray
	lua.register_function("AddPoliceSuspect", [](const LuaMadeSimple::Lua& lua_net) -> int {
		Output::send<LogLevel::Verbose>(STR("AddPoliceSuspect: entered\n"));

		if (lua_net.get_stack_size() < 2) {
			lua_net.throw_error("AddPoliceSuspect requires 2 arguments: policeObject, characterObject");
		}

		Output::send<LogLevel::Verbose>(STR("AddPoliceSuspect: getting args\n"));

		auto& police_lua = lua_net.get_userdata<RC::LuaType::UObject>();
		auto* police = police_lua.get_remote_cpp_object();

		auto& char_lua = lua_net.get_userdata<RC::LuaType::UObject>();
		auto* character = char_lua.get_remote_cpp_object();

		if (!police || !character) {
			Output::send<LogLevel::Warning>(STR("AddPoliceSuspect: null police or character\n"));
			lua_net.set_bool(false);
			return 1;
		}

		// Find Net_Suspects TArray property
		auto suspectsProp = static_cast<FArrayProperty*>(police->GetPropertyByNameInChain(STR("Net_Suspects")));
		if (!suspectsProp) {
			Output::send<LogLevel::Warning>(STR("AddPoliceSuspect: Net_Suspects property not found\n"));
			lua_net.set_bool(false);
			return 1;
		}

		auto* suspectsArray = suspectsProp->ContainerPtrToValuePtr<FScriptArray>(police);
		if (!suspectsArray) {
			Output::send<LogLevel::Warning>(STR("AddPoliceSuspect: Net_Suspects array ptr is null\n"));
			lua_net.set_bool(false);
			return 1;
		}

		auto innerProp = static_cast<FStructProperty*>(suspectsProp->GetInner());
		if (!innerProp) {
			Output::send<LogLevel::Warning>(STR("AddPoliceSuspect: inner property is null\n"));
			lua_net.set_bool(false);
			return 1;
		}

		int32 elemSize = innerProp->GetElementSize();
		int32 oldNum = suspectsArray->Num();
		int32 newNum = oldNum + 1;

		// Grow the TArray manually using UE's allocator
		// FScriptArray stores: void* Data, int32 ArrayNum, int32 ArrayMax
		void* oldData = suspectsArray->GetData();
		int32 oldMax = suspectsArray->Max();

		if (newNum > oldMax) {
			// Need to reallocate
			int32 newMax = newNum + 4; // Some slack
			void* newData = FMemory::Realloc(oldData, newMax * elemSize, alignof(void*));
			if (!newData) {
				Output::send<LogLevel::Warning>(STR("AddPoliceSuspect: realloc failed\n"));
				lua_net.set_bool(false);
				return 1;
			}
			// Update the FScriptArray internals via raw pointer manipulation
			// FScriptArray layout: { void* Data; int32 ArrayNum; int32 ArrayMax; }
			auto* rawArray = reinterpret_cast<uint8_t*>(suspectsArray);
			*reinterpret_cast<void**>(rawArray) = newData;
			*reinterpret_cast<int32*>(rawArray + sizeof(void*) + sizeof(int32)) = newMax;
		}

		// Update ArrayNum
		auto* rawArray = reinterpret_cast<uint8_t*>(suspectsArray);
		*reinterpret_cast<int32*>(rawArray + sizeof(void*)) = newNum;

		// Get pointer to the new element and zero-initialize it
		auto* newElem = static_cast<uint8_t*>(suspectsArray->GetData()) + (elemSize * oldNum);
		memset(newElem, 0, elemSize);

		auto innerStruct = innerProp->GetStruct();
		if (!innerStruct) {
			Output::send<LogLevel::Warning>(STR("AddPoliceSuspect: inner struct is null\n"));
			lua_net.set_bool(false);
			return 1;
		}

		// Set Character field (UObject pointer)
		auto charProp = innerStruct->GetPropertyByNameInChain(STR("Character"));
		if (charProp) {
			auto* charPtr = charProp->ContainerPtrToValuePtr<UObject*>(newElem);
			if (charPtr) {
				*charPtr = character;
				Output::send<LogLevel::Verbose>(STR("AddPoliceSuspect: Character set\n"));
			}
		}

		// Set LastSeenLocation from character's current location
		auto charLocationProp = character->GetPropertyByNameInChain(STR("RelativeLocation"));
		if (charLocationProp) {
			auto* charLoc = charLocationProp->ContainerPtrToValuePtr<FVector>(character);
			auto locProp = innerStruct->GetPropertyByNameInChain(STR("LastSeenLocation"));
			if (charLoc && locProp) {
				auto* locPtr = locProp->ContainerPtrToValuePtr<FVector>(newElem);
				if (locPtr) {
					*locPtr = *charLoc;
					Output::send<LogLevel::Verbose>(STR("AddPoliceSuspect: LastSeenLocation set\n"));
				}
			}
		}

		Output::send<LogLevel::Verbose>(STR("AddPoliceSuspect: suspect added (total: {})\n"), oldNum + 1);
		lua_net.set_bool(true);
		return 1;
	});
}
