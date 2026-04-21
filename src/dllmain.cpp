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

static std::string FormatGuid(const FGuid* guid)
{
	if (!guid) return "";
	return std::format(
		"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
		guid->A,
		(guid->B >> 16),
		(guid->B & 0xFFFF),
		(guid->C >> 16),
		(guid->C & 0xFFFF),
		guid->D
	);
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

	// ServerLoadCargo: post-hook to avoid racing with FAsyncLoadingThread.
	// Previously a pre-hook, which caused EXCEPTION_ACCESS_VIOLATION when two cargo loads
	// arrived ~95ms apart (crash hash 49693C391E78AB2A79B10F68E0C919823E80BAF3).
	// Post-hook runs after the engine completes ServerLoadCargo, so async asset loading
	// is finished and the cargo object is in a stable state.
	HookManager::RegisterPlayerEventPostHook(
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

			// --- Safety: validate cargo UObject is in a stable state ---
			// Skip if the object is mid-destruction or still needs loading/post-load
			if (cargo->HasAnyFlags(static_cast<EObjectFlags>(RF_BeginDestroyed | RF_FinishDestroyed | RF_NeedLoad | RF_NeedPostLoad))) {
				Output::send<LogLevel::Warning>(STR("ServerLoadCargo: Cargo object in unsafe state (ObjectFlags)\n"));
				return false;
			}
			// Skip if the object is pending kill or still being async-loaded
			if (cargo->HasAnyInternalFlags(EInternalObjectFlags::PendingKill | EInternalObjectFlags::AsyncLoading)) {
				Output::send<LogLevel::Warning>(STR("ServerLoadCargo: Cargo object in unsafe state (InternalFlags)\n"));
				return false;
			}

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
		STR("/Script/MotorTown.MotorTownPlayerController:ServerDespawnCargo"),
		"ServerDespawnCargo",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			// --- Extract Cargo (AMTCargo) from function params ---
			auto CargoProp = static_cast<FObjectProperty*>(
				FunctionBeingExecuted->GetPropertyByNameInChain(STR("Cargo")));
			if (!CargoProp) {
				Output::send<LogLevel::Warning>(STR("ServerDespawnCargo: Cargo property not found\n"));
				return false;
			}

			const auto& CargoPtr = CargoProp->ContainerPtrToValuePtr<UObject*>(Context.TheStack.Locals());
			if (CargoPtr == nullptr || *CargoPtr == nullptr) {
				Output::send<LogLevel::Warning>(STR("ServerDespawnCargo: Cargo object is null\n"));
				return false;
			}
			auto cargo = *CargoPtr;

			// --- Extract cargo properties ---
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
				Output::send<LogLevel::Warning>(STR("ServerDespawnCargo: missing cargo property\n"));
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
		STR("/Script/MotorTown.MotorTownPlayerController:ServerResetVehicleAt"),
		"ServerResetVehicleAt"
	);

	// ========== Teleport / Respawn Hooks ==========

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerTeleportCharacter"),
		"ServerTeleportCharacter",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			// --- Extract AbsoluteLocation (FVector) ---
			auto LocationProp = FunctionBeingExecuted->GetPropertyByName(STR("AbsoluteLocation"));
			if (!LocationProp) {
				Output::send<LogLevel::Warning>(STR("ServerTeleportCharacter: AbsoluteLocation property not found\n"));
				return false;
			}
			auto Location = LocationProp->ContainerPtrToValuePtr<FVector>(Context.TheStack.Locals());
			if (!Location) return false;

			json::object location_obj;
			location_obj["X"] = static_cast<int>(std::round(Location->X()));
			location_obj["Y"] = static_cast<int>(std::round(Location->Y()));
			location_obj["Z"] = static_cast<int>(std::round(Location->Z()));
			event_data["AbsoluteLocation"] = location_obj;

			// --- Extract bCharge (bool) ---
			auto bChargeProp = FunctionBeingExecuted->GetPropertyByName(STR("bCharge"));
			if (bChargeProp) {
				auto bCharge = bChargeProp->ContainerPtrToValuePtr<bool>(Context.TheStack.Locals());
				if (bCharge) event_data["bCharge"] = *bCharge;
			}

			// --- Extract bIsRespawn (bool) ---
			auto bIsRespawnProp = FunctionBeingExecuted->GetPropertyByName(STR("bIsRespawn"));
			if (bIsRespawnProp) {
				auto bIsRespawn = bIsRespawnProp->ContainerPtrToValuePtr<bool>(Context.TheStack.Locals());
				if (bIsRespawn) event_data["bIsRespawn"] = *bIsRespawn;
			}

			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerTeleportVehicle"),
		"ServerTeleportVehicle",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			// --- Extract AbsoluteLocation (FVector) ---
			auto LocationProp = FunctionBeingExecuted->GetPropertyByName(STR("AbsoluteLocation"));
			if (!LocationProp) {
				Output::send<LogLevel::Warning>(STR("ServerTeleportVehicle: AbsoluteLocation property not found\n"));
				return false;
			}
			auto Location = LocationProp->ContainerPtrToValuePtr<FVector>(Context.TheStack.Locals());
			if (!Location) return false;

			json::object location_obj;
			location_obj["X"] = static_cast<int>(std::round(Location->X()));
			location_obj["Y"] = static_cast<int>(std::round(Location->Y()));
			location_obj["Z"] = static_cast<int>(std::round(Location->Z()));
			event_data["AbsoluteLocation"] = location_obj;

			return true;
		}
	);

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerRespawnCharacter"),
		"ServerRespawnCharacter",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			// --- Extract AbsoluteLocation (FVector) ---
			auto LocationProp = FunctionBeingExecuted->GetPropertyByName(STR("AbsoluteLocation"));
			if (!LocationProp) {
				Output::send<LogLevel::Warning>(STR("ServerRespawnCharacter: AbsoluteLocation property not found\n"));
				return false;
			}
			auto Location = LocationProp->ContainerPtrToValuePtr<FVector>(Context.TheStack.Locals());
			if (!Location) return false;

			json::object location_obj;
			location_obj["X"] = static_cast<int>(std::round(Location->X()));
			location_obj["Y"] = static_cast<int>(std::round(Location->Y()));
			location_obj["Z"] = static_cast<int>(std::round(Location->Z()));
			event_data["AbsoluteLocation"] = location_obj;

			return true;
		}
	);

	HookManager::RegisterPlayerEventPostHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerSignContract"),
		"ServerSignContract",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

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

			json::object contract_obj;

			std::string contract_item;
			float contract_amount = 0.0f;
			int64 contract_payment_base = 0;
			bool has_item = false;
			bool has_amount = false;
			bool has_payment = false;

			const auto ItemProp = ContractStruct->GetPropertyByNameInChain(STR("Item"));
			if (ItemProp) {
				const auto& Item = ItemProp->ContainerPtrToValuePtr<FString>(Contract);
				if (Item && Item->GetCharArray().GetData()) {
					contract_item = to_string(Item->GetCharArray().GetData());
					contract_obj["Item"] = contract_item;
					has_item = true;
				}
			}

			const auto AmountProp = ContractStruct->GetPropertyByNameInChain(STR("Amount"));
			if (AmountProp) {
				const auto& Amount = AmountProp->ContainerPtrToValuePtr<float>(Contract);
				if (Amount) {
					contract_amount = *Amount;
					contract_obj["Amount"] = contract_amount;
					has_amount = true;
				}
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
							contract_payment_base = *BaseValue;
							json::object payment_obj;
							payment_obj["BaseValue"] = contract_payment_base;
							contract_obj["CompletionPayment"] = payment_obj;
							has_payment = true;
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

			// --- Post-hook: find ContractGuid by matching CIP against signed contract data ---
			const auto& PlayerController = Context.Context;
			if (!PlayerController) return false;

			auto CompaniesProperty = static_cast<FArrayProperty*>(PlayerController->GetPropertyByNameInChain(STR("Companies")));
			if (!CompaniesProperty) {
				CompaniesProperty = static_cast<FArrayProperty*>(PlayerController->GetPropertyByNameInChain(STR("Net_CompaniesBase")));
			}
			if (!CompaniesProperty) return true;

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

				for (int32_t j = NumCips - 1; j >= 0; --j) {
					auto cip_ptr = static_cast<uint8_t*>(CipArray->GetData()) + CipSize * j;
					const auto& CipStruct = CipInnerProp->GetStruct();
					if (!CipStruct) continue;
					auto ContractInProgress = CipInnerProp->ContainerPtrToValuePtr<void>(cip_ptr);
					if (!ContractInProgress) continue;

					const auto CipContractProp = static_cast<FStructProperty*>(CipStruct->GetPropertyByNameInChain(STR("Contract")));
					if (!CipContractProp) continue;
					const auto& CipContract = CipContractProp->ContainerPtrToValuePtr<void>(ContractInProgress);
					if (!CipContract) continue;
					const auto& CipContractStruct = CipContractProp->GetStruct();
					if (!CipContractStruct) continue;

					bool item_match = false;
					bool amount_match = false;
					bool payment_match = false;

					const auto CipItemProp = CipContractStruct->GetPropertyByNameInChain(STR("Item"));
					if (CipItemProp && has_item) {
						const auto& CipItem = CipItemProp->ContainerPtrToValuePtr<FString>(CipContract);
						if (CipItem && CipItem->GetCharArray().GetData()) {
							item_match = (to_string(CipItem->GetCharArray().GetData()) == contract_item);
						}
					}

					const auto CipAmountProp = CipContractStruct->GetPropertyByNameInChain(STR("Amount"));
					if (CipAmountProp && has_amount) {
						const auto& CipAmount = CipAmountProp->ContainerPtrToValuePtr<float>(CipContract);
						if (CipAmount) {
							amount_match = (std::abs(*CipAmount - contract_amount) < 0.01f);
						}
					}

					const auto CipCompletionPaymentProp = static_cast<FStructProperty*>(CipContractStruct->GetPropertyByNameInChain(STR("CompletionPayment")));
					if (CipCompletionPaymentProp && has_payment) {
						const auto& CipCompletionPayment = CipCompletionPaymentProp->ContainerPtrToValuePtr<void>(CipContract);
						const auto& CipCompletionPaymentStruct = CipCompletionPaymentProp->GetStruct();
						if (CipCompletionPayment && CipCompletionPaymentStruct) {
							const auto CipBaseValueProp = CipCompletionPaymentStruct->GetPropertyByNameInChain(STR("BaseValue"));
							if (CipBaseValueProp) {
								const auto& CipBaseValue = CipBaseValueProp->ContainerPtrToValuePtr<int64>(CipCompletionPayment);
								if (CipBaseValue) {
									payment_match = (*CipBaseValue == contract_payment_base);
								}
							}
						}
					}

					if (!item_match || !amount_match || !payment_match) continue;

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
					Output::send<LogLevel::Verbose>(STR("ServerSignContract: ContractGuid = {} (matched by contract data)\n"), to_wstring(guid_str));
					return true;
				}
			}

			Output::send<LogLevel::Verbose>(STR("ServerSignContract: no matching CIP found for Item={} Amount={} Payment={}\n"),
				to_wstring(contract_item), contract_amount, contract_payment_base);
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

			// --- Extract SuspectCharacter (AMTCharacter) ---
			auto SuspectCharacterProp = static_cast<FObjectProperty*>(
				FunctionBeingExecuted->GetPropertyByName(STR("SuspectCharacter")));
			if (SuspectCharacterProp) {
				const auto& SuspectCharPtr = SuspectCharacterProp->ContainerPtrToValuePtr<UObject*>(Context.TheStack.Locals());
				if (SuspectCharPtr && *SuspectCharPtr) {
					auto SuspectChar = *SuspectCharPtr;
					json::object suspect_obj;

					auto ResidentKey = SuspectChar->GetValuePtrByPropertyNameInChain<FName>(STR("Net_ResidentKey"));
					if (ResidentKey) {
						suspect_obj["Net_ResidentKey"] = json::string(to_string(ResidentKey->ToString()));
					}

					auto PlayerStateProp = static_cast<FObjectProperty*>(
						SuspectChar->GetPropertyByNameInChain(STR("Net_MTPlayerState")));
					if (PlayerStateProp) {
						const auto& PlayerStatePtr = PlayerStateProp->ContainerPtrToValuePtr<UObject*>(SuspectChar);
						if (PlayerStatePtr && *PlayerStatePtr) {
							auto CharGuid = (*PlayerStatePtr)->GetValuePtrByPropertyName<FGuid>(STR("CharacterGuid"));
							if (CharGuid) {
								suspect_obj["CharacterGuid"] = json::string(FormatGuid(CharGuid));
							}
							auto PlayerName = (*PlayerStatePtr)->GetValuePtrByPropertyNameInChain<FString>(STR("Net_AccountNickname"));
							if (PlayerName && PlayerName->GetCharArray().GetData()) {
								suspect_obj["AccountNickname"] = json::string(to_string(PlayerName->GetCharArray().GetData()));
							}
						}
					}

					auto CharFlags = SuspectChar->GetValuePtrByPropertyNameInChain<uint32>(STR("Net_CharacterFlags"));
					if (CharFlags) {
						suspect_obj["Net_CharacterFlags"] = *CharFlags;
					}

					event_data["SuspectCharacter"] = suspect_obj;
				}
			}

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

	// ========== Vehicle Entry Hook ==========

	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerEnterVehicle"),
		"ServerEnterVehicle",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			// --- Extract Vehicle (AMTVehicle) from function params ---
			auto VehicleProp = static_cast<FObjectProperty*>(
				FunctionBeingExecuted->GetPropertyByName(STR("Vehicle")));
			if (!VehicleProp) {
				Output::send<LogLevel::Warning>(STR("ServerEnterVehicle: Vehicle property not found\n"));
				return false;
			}
			const auto& VehiclePtr = VehicleProp->ContainerPtrToValuePtr<UObject*>(Context.TheStack.Locals());
			if (!VehiclePtr || !*VehiclePtr) {
				Output::send<LogLevel::Warning>(STR("ServerEnterVehicle: Vehicle object is null\n"));
				return false;
			}
			auto Vehicle = *VehiclePtr;

			// --- Extract SeatType (uint8 enum) ---
			auto SeatTypeProp = FunctionBeingExecuted->GetPropertyByName(STR("SeatType"));
			if (SeatTypeProp) {
				auto SeatType = SeatTypeProp->ContainerPtrToValuePtr<uint8>(Context.TheStack.Locals());
				if (SeatType) event_data["SeatType"] = *SeatType;
			}

			// --- Extract SeatIndex (int32) ---
			auto SeatIndexProp = FunctionBeingExecuted->GetPropertyByName(STR("SeatIndex"));
			if (SeatIndexProp) {
				auto SeatIndex = SeatIndexProp->ContainerPtrToValuePtr<int32>(Context.TheStack.Locals());
				if (SeatIndex) event_data["SeatIndex"] = *SeatIndex;
			}

			// --- Extract bSteal (bool) ---
			auto bStealProp = FunctionBeingExecuted->GetPropertyByName(STR("bSteal"));
			if (bStealProp) {
				auto bSteal = bStealProp->ContainerPtrToValuePtr<bool>(Context.TheStack.Locals());
				if (bSteal) event_data["bSteal"] = *bSteal;
			}

			// --- Extract current driver's CharacterGuid from Vehicle -> Net_Seats ---
			auto SeatsProp = static_cast<FArrayProperty*>(
				Vehicle->GetPropertyByNameInChain(STR("Net_Seats")));
			if (SeatsProp) {
				auto SeatsArray = SeatsProp->ContainerPtrToValuePtr<FScriptArray>(Vehicle);
				if (SeatsArray && SeatsArray->GetData()) {
					auto SeatsInnerProp = static_cast<FStructProperty*>(SeatsProp->GetInner());
					if (SeatsInnerProp) {
						int32 SeatSize = SeatsInnerProp->GetElementSize();
						int32 NumSeats = SeatsArray->Num();
						auto SeatsStruct = SeatsInnerProp->GetStruct();
						if (SeatsStruct) {
							for (int32 i = 0; i < NumSeats; ++i) {
								auto seatPtr = static_cast<uint8_t*>(SeatsArray->GetData()) + (SeatSize * i);
								auto seatContainer = SeatsInnerProp->ContainerPtrToValuePtr<void>(seatPtr);
								if (!seatContainer) continue;

								// Check bHasCharacter
								auto bHasCharProp = SeatsStruct->GetPropertyByNameInChain(STR("bHasCharacter"));
								if (!bHasCharProp) continue;
								auto bHasChar = bHasCharProp->ContainerPtrToValuePtr<bool>(seatContainer);
								if (!bHasChar || !*bHasChar) continue;

								// Get Character object
								auto CharProp = static_cast<FObjectProperty*>(
									SeatsStruct->GetPropertyByNameInChain(STR("Character")));
								if (!CharProp) continue;
								auto CharPtr = CharProp->ContainerPtrToValuePtr<UObject*>(seatContainer);
								if (!CharPtr || !*CharPtr) continue;

								// Character (APawn) -> PlayerState -> CharacterGuid
								auto DriverPlayerState = (*CharPtr)->GetValuePtrByPropertyNameInChain<UObject*>(STR("PlayerState"));
								if (!DriverPlayerState || !*DriverPlayerState) continue;

								auto DriverCharGuid = (*DriverPlayerState)->GetValuePtrByPropertyName<FGuid>(STR("CharacterGuid"));
								if (!DriverCharGuid) continue;

								event_data["DriverCharacterGuid"] = json::string(std::format(
									"{:08X}{:04X}{:04X}{:04X}{:04X}{:08X}",
									DriverCharGuid->A,
									(DriverCharGuid->B >> 16),
									(DriverCharGuid->B & 0xFFFF),
									(DriverCharGuid->C >> 16),
									(DriverCharGuid->C & 0xFFFF),
									DriverCharGuid->D
								));
								Output::send<LogLevel::Verbose>(STR("ServerEnterVehicle: found driver in seat {}\n"), i);
								break; // Found the first seated character (driver)
							}
						}
					}
				}
			}

			return true;
		}
	);

	// ========== Event System Hooks ==========

	// Helper: extract full FMTEvent from a struct pointer into JSON
	auto extract_event_struct = [](void* event_ptr, UScriptStruct* event_struct, json::object& event_obj) {
		if (!event_ptr || !event_struct) return;

		// EventGuid
		auto egProp = event_struct->GetPropertyByNameInChain(STR("EventGuid"));
		if (egProp) {
			auto eg = egProp->ContainerPtrToValuePtr<FGuid>(event_ptr);
			if (eg) event_obj["EventGuid"] = json::string(FormatGuid(eg));
		}

		// EventName
		auto enProp = event_struct->GetPropertyByNameInChain(STR("EventName"));
		if (enProp) {
			auto en = enProp->ContainerPtrToValuePtr<FString>(event_ptr);
			if (en && en->GetCharArray().GetData()) {
				event_obj["EventName"] = json::string(to_string(en->GetCharArray().GetData()));
			}
		}

		// State (uint8 enum)
		auto stateProp = event_struct->GetPropertyByNameInChain(STR("State"));
		if (stateProp) {
			auto state = stateProp->ContainerPtrToValuePtr<uint8>(event_ptr);
			if (state) event_obj["State"] = *state;
		}

		// OwnerCharacterId
		auto ownerProp = static_cast<FStructProperty*>(event_struct->GetPropertyByNameInChain(STR("OwnerCharacterId")));
		if (ownerProp) {
			auto owner = ownerProp->ContainerPtrToValuePtr<void>(event_ptr);
			auto ownerStruct = ownerProp->GetStruct();
			if (owner && ownerStruct) {
				json::object owner_obj;
				auto ogProp = ownerStruct->GetPropertyByNameInChain(STR("CharacterGuid"));
				if (ogProp) {
					auto og = ogProp->ContainerPtrToValuePtr<FGuid>(owner);
					if (og) owner_obj["CharacterGuid"] = json::string(FormatGuid(og));
				}
				auto ouProp = ownerStruct->GetPropertyByNameInChain(STR("UniqueNetId"));
				if (ouProp) {
					auto ou = ouProp->ContainerPtrToValuePtr<FString>(owner);
					if (ou && ou->GetCharArray().GetData()) {
						owner_obj["UniqueNetId"] = json::string(to_string(ou->GetCharArray().GetData()));
					}
				}
				event_obj["OwnerCharacterId"] = owner_obj;
			}
		}

		// Players TArray
		auto playersProp = static_cast<FArrayProperty*>(event_struct->GetPropertyByNameInChain(STR("Players")));
		if (playersProp) {
			auto playersArray = playersProp->ContainerPtrToValuePtr<FScriptArray>(event_ptr);
			auto playersInner = static_cast<FStructProperty*>(playersProp->GetInner());
			if (playersArray && playersArray->GetData() && playersInner) {
				int32 elemSize = playersInner->GetElementSize();
				int32 numPlayers = playersArray->Num();
				auto playerStruct = playersInner->GetStruct();
				json::array players_json;

				for (int32 i = 0; i < numPlayers && playerStruct; ++i) {
					auto playerPtr = static_cast<uint8_t*>(playersArray->GetData()) + (elemSize * i);
					auto player = playersInner->ContainerPtrToValuePtr<void>(playerPtr);
					if (!player) continue;

					json::object pj;

					// CharacterId
					auto cidProp = static_cast<FStructProperty*>(playerStruct->GetPropertyByNameInChain(STR("CharacterId")));
					if (cidProp) {
						auto cid = cidProp->ContainerPtrToValuePtr<void>(player);
						auto cidStruct = cidProp->GetStruct();
						if (cid && cidStruct) {
							json::object cid_obj;
							auto cgProp = cidStruct->GetPropertyByNameInChain(STR("CharacterGuid"));
							if (cgProp) {
								auto cg = cgProp->ContainerPtrToValuePtr<FGuid>(cid);
								if (cg) cid_obj["CharacterGuid"] = json::string(FormatGuid(cg));
							}
							auto unProp = cidStruct->GetPropertyByNameInChain(STR("UniqueNetId"));
							if (unProp) {
								auto un = unProp->ContainerPtrToValuePtr<FString>(cid);
								if (un && un->GetCharArray().GetData()) {
									cid_obj["UniqueNetId"] = json::string(to_string(un->GetCharArray().GetData()));
								}
							}
							pj["CharacterId"] = cid_obj;
						}
					}

					// PlayerName
					auto pnProp = playerStruct->GetPropertyByNameInChain(STR("PlayerName"));
					if (pnProp) {
						auto pn = pnProp->ContainerPtrToValuePtr<FString>(player);
						if (pn && pn->GetCharArray().GetData()) {
							pj["PlayerName"] = json::string(to_string(pn->GetCharArray().GetData()));
						}
					}

					// Scalar fields
					auto rProp = playerStruct->GetPropertyByNameInChain(STR("Rank"));
					if (rProp) { auto v = rProp->ContainerPtrToValuePtr<int32>(player); if (v) pj["Rank"] = *v; }

					auto siProp = playerStruct->GetPropertyByNameInChain(STR("SectionIndex"));
					if (siProp) { auto v = siProp->ContainerPtrToValuePtr<int32>(player); if (v) pj["SectionIndex"] = *v; }

					auto lpProp = playerStruct->GetPropertyByNameInChain(STR("Laps"));
					if (lpProp) { auto v = lpProp->ContainerPtrToValuePtr<int32>(player); if (v) pj["Laps"] = *v; }

					auto lsProp = playerStruct->GetPropertyByNameInChain(STR("LastSectionTotalTimeSeconds"));
					if (lsProp) { auto v = lsProp->ContainerPtrToValuePtr<float>(player); if (v) pj["LastSectionTotalTimeSeconds"] = *v; }

					auto blProp = playerStruct->GetPropertyByNameInChain(STR("BestLapTime"));
					if (blProp) { auto v = blProp->ContainerPtrToValuePtr<float>(player); if (v) pj["BestLapTime"] = *v; }

					auto dqProp = playerStruct->GetPropertyByNameInChain(STR("bDisqualified"));
					if (dqProp) { auto v = dqProp->ContainerPtrToValuePtr<bool>(player); if (v) pj["bDisqualified"] = *v; }

					auto fnProp = playerStruct->GetPropertyByNameInChain(STR("bFinished"));
					if (fnProp) { auto v = fnProp->ContainerPtrToValuePtr<bool>(player); if (v) pj["bFinished"] = *v; }

					auto wvProp = playerStruct->GetPropertyByNameInChain(STR("bWrongVehicle"));
					if (wvProp) { auto v = wvProp->ContainerPtrToValuePtr<bool>(player); if (v) pj["bWrongVehicle"] = *v; }

					auto weProp = playerStruct->GetPropertyByNameInChain(STR("bWrongEngine"));
					if (weProp) { auto v = weProp->ContainerPtrToValuePtr<bool>(player); if (v) pj["bWrongEngine"] = *v; }

					// LapTimes TArray<float>
					auto ltProp = static_cast<FArrayProperty*>(playerStruct->GetPropertyByNameInChain(STR("LapTimes")));
					if (ltProp) {
						auto ltArray = ltProp->ContainerPtrToValuePtr<FScriptArray>(player);
						if (ltArray && ltArray->GetData()) {
							json::array lt_json;
							auto ltInner = ltProp->GetInner();
							if (ltInner) {
								int32 ltElemSize = ltInner->GetElementSize();
								for (int32 j = 0; j < ltArray->Num(); ++j) {
									auto ltVal = reinterpret_cast<const float*>(
										static_cast<const uint8_t*>(ltArray->GetData()) + (ltElemSize * j));
									lt_json.push_back(*ltVal);
								}
							}
							pj["LapTimes"] = lt_json;
						}
					}

					// Reward_Money (FMTShadowedInt64)
					auto rmProp = static_cast<FStructProperty*>(playerStruct->GetPropertyByNameInChain(STR("Reward_Money")));
					if (rmProp) {
						auto rm = rmProp->ContainerPtrToValuePtr<void>(player);
						auto rmStruct = rmProp->GetStruct();
						if (rm && rmStruct) {
							json::object rm_obj;
							auto bvProp = rmStruct->GetPropertyByNameInChain(STR("BaseValue"));
							if (bvProp) {
								auto bv = bvProp->ContainerPtrToValuePtr<int64>(rm);
								if (bv) rm_obj["BaseValue"] = *bv;
							}
							pj["Reward_Money"] = rm_obj;
						}
					}

					players_json.push_back(pj);
				}
				event_obj["Players"] = players_json;
			}
		}

		// RaceSetup (FMTRaceEventSetup)
		auto rsProp = static_cast<FStructProperty*>(event_struct->GetPropertyByNameInChain(STR("RaceSetup")));
		if (rsProp) {
			auto rs = rsProp->ContainerPtrToValuePtr<void>(event_ptr);
			auto rsStruct = rsProp->GetStruct();
			if (rs && rsStruct) {
				json::object rs_obj;

				auto nlProp = rsStruct->GetPropertyByNameInChain(STR("NumLaps"));
				if (nlProp) { auto v = nlProp->ContainerPtrToValuePtr<int32>(rs); if (v) rs_obj["NumLaps"] = *v; }

				// VehicleKeys TArray<FName>
				auto vkProp = static_cast<FArrayProperty*>(rsStruct->GetPropertyByNameInChain(STR("VehicleKeys")));
				if (vkProp) {
					auto vkArray = vkProp->ContainerPtrToValuePtr<FScriptArray>(rs);
					if (vkArray && vkArray->GetData()) {
						json::array vk_json;
						auto vkInner = vkProp->GetInner();
						if (vkInner) {
							int32 vkElemSize = vkInner->GetElementSize();
							for (int32 j = 0; j < vkArray->Num(); ++j) {
								auto vkVal = reinterpret_cast<const FName*>(
									static_cast<const uint8_t*>(vkArray->GetData()) + (vkElemSize * j));
								vk_json.push_back(json::string(to_string(vkVal->ToString())));
							}
						}
						rs_obj["VehicleKeys"] = vk_json;
					}
				}

				// EngineKeys TArray<FName>
				auto ekProp = static_cast<FArrayProperty*>(rsStruct->GetPropertyByNameInChain(STR("EngineKeys")));
				if (ekProp) {
					auto ekArray = ekProp->ContainerPtrToValuePtr<FScriptArray>(rs);
					if (ekArray && ekArray->GetData()) {
						json::array ek_json;
						auto ekInner = ekProp->GetInner();
						if (ekInner) {
							int32 ekElemSize = ekInner->GetElementSize();
							for (int32 j = 0; j < ekArray->Num(); ++j) {
								auto ekVal = reinterpret_cast<const FName*>(
									static_cast<const uint8_t*>(ekArray->GetData()) + (ekElemSize * j));
								ek_json.push_back(json::string(to_string(ekVal->ToString())));
							}
						}
						rs_obj["EngineKeys"] = ek_json;
					}
				}

				// Route (FMTRoute)
				auto routeProp = static_cast<FStructProperty*>(rsStruct->GetPropertyByNameInChain(STR("Route")));
				if (routeProp) {
					auto route = routeProp->ContainerPtrToValuePtr<void>(rs);
					auto routeStruct = routeProp->GetStruct();
					if (route && routeStruct) {
						json::object route_obj;

						auto rnProp = routeStruct->GetPropertyByNameInChain(STR("RouteName"));
						if (rnProp) {
							auto rn = rnProp->ContainerPtrToValuePtr<FString>(route);
							if (rn && rn->GetCharArray().GetData()) {
								route_obj["RouteName"] = json::string(to_string(rn->GetCharArray().GetData()));
							}
						}

						// Waypoints TArray<FTransform>
						auto wpProp = static_cast<FArrayProperty*>(routeStruct->GetPropertyByNameInChain(STR("Waypoints")));
						if (wpProp) {
							auto wpArray = wpProp->ContainerPtrToValuePtr<FScriptArray>(route);
							auto wpInner = static_cast<FStructProperty*>(wpProp->GetInner());
							if (wpArray && wpArray->GetData() && wpInner) {
								int32 wpElemSize = wpInner->GetElementSize();
								int32 numWp = wpArray->Num();
								auto tfStruct = wpInner->GetStruct();
								json::array wp_json;

								for (int32 k = 0; k < numWp && tfStruct; ++k) {
									auto tfPtr = static_cast<uint8_t*>(wpArray->GetData()) + (wpElemSize * k);
									auto tf = wpInner->ContainerPtrToValuePtr<void>(tfPtr);
									if (!tf) continue;

									json::object wp_obj;

									auto trProp = static_cast<FStructProperty*>(tfStruct->GetPropertyByNameInChain(STR("Translation")));
									if (trProp) {
										auto tr = trProp->ContainerPtrToValuePtr<FVector>(tf);
										if (tr) {
											json::object loc;
											loc["X"] = tr->X(); loc["Y"] = tr->Y(); loc["Z"] = tr->Z();
											wp_obj["Location"] = loc;
										}
									}

									auto roProp = static_cast<FStructProperty*>(tfStruct->GetPropertyByNameInChain(STR("Rotation")));
									if (roProp) {
										auto ro = roProp->ContainerPtrToValuePtr<FQuat>(tf);
										if (ro) {
											json::object rot;
											rot["X"] = ro->X(); rot["Y"] = ro->Y();
											rot["Z"] = ro->Z(); rot["W"] = ro->W();
											wp_obj["Rotation"] = rot;
										}
									}

									auto scProp = static_cast<FStructProperty*>(tfStruct->GetPropertyByNameInChain(STR("Scale3D")));
									if (scProp) {
										auto sc = scProp->ContainerPtrToValuePtr<FVector>(tf);
										if (sc) {
											json::object scl;
											scl["X"] = sc->X(); scl["Y"] = sc->Y(); scl["Z"] = sc->Z();
											wp_obj["Scale3D"] = scl;
										}
									}

									wp_json.push_back(wp_obj);
								}
								route_obj["Waypoints"] = wp_json;
							}
						}

						rs_obj["Route"] = route_obj;
					}
				}

				event_obj["RaceSetup"] = rs_obj;
			}
		}
	};

	// --- ServerAddEvent: extract full FMTEvent from function param ---
	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerAddEvent"),
		"ServerAddEvent",
		[extract_event_struct](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			auto EventProperty = static_cast<FStructProperty*>(
				FunctionBeingExecuted->GetPropertyByNameInChain(STR("Event")));
			if (!EventProperty) return false;

			auto event_ptr = EventProperty->ContainerPtrToValuePtr<void>(Context.TheStack.Locals());
			auto event_struct = EventProperty->GetStruct();
			if (!event_ptr || !event_struct) return false;

			json::object event_obj;
			extract_event_struct(event_ptr, event_struct, event_obj);
			event_data["Event"] = event_obj;
			return true;
		}
	);

	// --- ServerChangeEventState: post-hook to get full event after state update ---
	HookManager::RegisterPlayerEventPostHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerChangeEventState"),
		"ServerChangeEventState",
		[extract_event_struct](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			// Extract EventGuid from function params
			auto guidProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("EventGuid"));
			if (!guidProp) return false;
			auto eventGuid = guidProp->ContainerPtrToValuePtr<FGuid>(Context.TheStack.Locals());
			if (!eventGuid) return false;
			std::string targetGuid = FormatGuid(eventGuid);

			// Extract EventState from function params
			auto stateProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("EventState"));
			if (stateProp) {
				auto state = stateProp->ContainerPtrToValuePtr<uint8>(Context.TheStack.Locals());
				if (state) event_data["EventState"] = *state;
			}

			// Traverse AMTEventSystem::Net_Events to get full event data
			auto GS = UObjectGlobals::FindFirstOf(STR("AMotorTownGameState"));
			if (!GS) return true;

			auto eventSystemProp = static_cast<FObjectProperty*>(GS->GetPropertyByNameInChain(STR("Net_EventSystem")));
			if (!eventSystemProp) return true;
			auto eventSystemPtr = eventSystemProp->ContainerPtrToValuePtr<UObject*>(GS);
			if (!eventSystemPtr || !*eventSystemPtr) return true;
			auto eventSystem = *eventSystemPtr;

			auto eventsProp = static_cast<FArrayProperty*>(eventSystem->GetPropertyByNameInChain(STR("Net_Events")));
			if (!eventsProp) return true;
			auto eventsArray = eventsProp->ContainerPtrToValuePtr<FScriptArray>(eventSystem);
			auto eventsInner = static_cast<FStructProperty*>(eventsProp->GetInner());
			if (!eventsArray || !eventsArray->GetData() || !eventsInner) return true;

			int32 elemSize = eventsInner->GetElementSize();
			int32 numEvents = eventsArray->Num();
			auto eventStruct = eventsInner->GetStruct();
			if (!eventStruct) return true;

			for (int32 i = 0; i < numEvents; ++i) {
				auto elemPtr = static_cast<uint8_t*>(eventsArray->GetData()) + (elemSize * i);
				auto elem = eventsInner->ContainerPtrToValuePtr<void>(elemPtr);
				if (!elem) continue;

				auto egProp = eventStruct->GetPropertyByNameInChain(STR("EventGuid"));
				if (!egProp) continue;
				auto eg = egProp->ContainerPtrToValuePtr<FGuid>(elem);
				if (!eg) continue;

				if (FormatGuid(eg) == targetGuid) {
					json::object event_obj;
					extract_event_struct(elem, eventStruct, event_obj);
					event_data["Event"] = event_obj;
					break;
				}
			}

			return true;
		}
	);

	// --- ServerPassedRaceSection: extract race section data ---
	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerPassedRaceSection"),
		"ServerPassedRaceSection",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			auto guidProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("EventGuid"));
			if (!guidProp) return false;
			auto eventGuid = guidProp->ContainerPtrToValuePtr<FGuid>(Context.TheStack.Locals());
			if (!eventGuid) return false;
			event_data["EventGuid"] = json::string(FormatGuid(eventGuid));

			auto siProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("SectionIndex"));
			if (siProp) {
				auto si = siProp->ContainerPtrToValuePtr<int32>(Context.TheStack.Locals());
				if (si) event_data["SectionIndex"] = *si;
			}

			auto tsProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("TotalTimeSeconds"));
			if (tsProp) {
				auto ts = tsProp->ContainerPtrToValuePtr<float>(Context.TheStack.Locals());
				if (ts) event_data["TotalTimeSeconds"] = *ts;
			}

			auto lsProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("LaptimeSeconds"));
			if (lsProp) {
				auto ls = lsProp->ContainerPtrToValuePtr<float>(Context.TheStack.Locals());
				if (ls) event_data["LaptimeSeconds"] = *ls;
			}

			return true;
		}
	);

	// --- ServerRemoveEvent: extract EventGuid ---
	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerRemoveEvent"),
		"ServerRemoveEvent",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			auto guidProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("EventGuid"));
			if (!guidProp) return false;
			auto eventGuid = guidProp->ContainerPtrToValuePtr<FGuid>(Context.TheStack.Locals());
			if (!eventGuid) return false;
			event_data["EventGuid"] = json::string(FormatGuid(eventGuid));
			return true;
		}
	);

	// --- ServerJoinEvent: extract EventGuid ---
	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerJoinEvent"),
		"ServerJoinEvent",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			auto guidProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("EventGuid"));
			if (!guidProp) return false;
			auto eventGuid = guidProp->ContainerPtrToValuePtr<FGuid>(Context.TheStack.Locals());
			if (!eventGuid) return false;
			event_data["EventGuid"] = json::string(FormatGuid(eventGuid));
			return true;
		}
	);

	// --- ServerLeaveEvent: extract EventGuid ---
	HookManager::RegisterPlayerEventHook(
		STR("/Script/MotorTown.MotorTownPlayerController:ServerLeaveEvent"),
		"ServerLeaveEvent",
		[](UnrealScriptFunctionCallableContext& Context, json::object& event_data) -> bool {
			const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction()
				? Context.TheStack.CurrentNativeFunction()
				: *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
			if (!FunctionBeingExecuted) return false;

			auto guidProp = FunctionBeingExecuted->GetPropertyByNameInChain(STR("EventGuid"));
			if (!guidProp) return false;
			auto eventGuid = guidProp->ContainerPtrToValuePtr<FGuid>(Context.TheStack.Locals());
			if (!eventGuid) return false;
			event_data["EventGuid"] = json::string(FormatGuid(eventGuid));
			return true;
		}
	);
}

// Forward declarations for Lua-table-to-JSON conversion
static json::value lua_value_to_json(lua_State* L, int idx);
static json::value lua_table_to_json_value(lua_State* L, int table_idx);

static json::value lua_table_to_json_value(lua_State* L, int table_idx)
{
	int abs_idx = lua_absindex(L, table_idx);

	// First pass: determine if this is an array (consecutive integer keys starting from 1)
	bool is_array = true;
	lua_Integer expected_key = 1;
	lua_Integer array_len = 0;

	lua_pushnil(L);
	while (lua_next(L, abs_idx) != 0) {
		if (lua_type(L, -2) != LUA_TNUMBER || !lua_isinteger(L, -2) || lua_tointeger(L, -2) != expected_key) {
			is_array = false;
			lua_pop(L, 2); // pop value and key
			break;
		}
		expected_key++;
		array_len++;
		lua_pop(L, 1); // pop value, keep key for lua_next
	}

	if (is_array && array_len > 0) {
		json::array arr;

		lua_pushnil(L);
		while (lua_next(L, abs_idx) != 0) {
			arr.push_back(lua_value_to_json(L, -1));
			lua_pop(L, 1); // pop value
		}

		return arr;
	} else {
		json::object obj;

		lua_pushnil(L);
		while (lua_next(L, abs_idx) != 0) {
			std::string key;
			int key_type = lua_type(L, -2);
			if (key_type == LUA_TSTRING) {
				key = lua_tostring(L, -2);
			} else if (key_type == LUA_TNUMBER && lua_isinteger(L, -2)) {
				key = std::to_string(lua_tointeger(L, -2));
			} else {
				lua_pop(L, 1);
				continue;
			}

			obj[key] = lua_value_to_json(L, -1);
			lua_pop(L, 1); // pop value
		}

		return obj;
	}
}

static json::value lua_value_to_json(lua_State* L, int idx)
{
	int abs_idx = lua_absindex(L, idx);
	int type = lua_type(L, abs_idx);

	switch (type) {
	case LUA_TNIL:
		return json::value();
	case LUA_TBOOLEAN:
		return json::value(static_cast<bool>(lua_toboolean(L, abs_idx)));
	case LUA_TNUMBER:
		if (lua_isinteger(L, abs_idx)) {
			return json::value(lua_tointeger(L, abs_idx));
		}
		return json::value(lua_tonumber(L, abs_idx));
	case LUA_TSTRING: {
		const char* str = lua_tostring(L, abs_idx);
		return json::string(str ? str : "");
	}
	case LUA_TTABLE:
		return lua_table_to_json_value(L, abs_idx);
	default:
		return json::value();
	}
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

	// EnqueueWebhookEvent(event_name, data_table) -> bool
	// Emits a Lua-constructed event directly into the C++ EventManager SSE/webhook pipeline.
	// Accepts a Lua table instead of a JSON string, avoiding the serialize/parse roundtrip.
	lua.register_function("EnqueueWebhookEvent", [](const LuaMadeSimple::Lua& lua_net) -> int {
		if (lua_net.get_stack_size() < 2) {
			lua_net.throw_error("EnqueueWebhookEvent requires 2 arguments: event_name, data_table");
		}

		std::string event_name = std::string(lua_net.get_string());

		lua_State* L = lua_net.get_lua_state();

		if (!lua_istable(L, 1)) {
			Output::send<LogLevel::Warning>(STR("EnqueueWebhookEvent: second argument must be a table\n"));
			lua_pop(L, 1); // pop the non-table argument
			lua_net.set_bool(false);
			return 1;
		}

		json::value data = lua_table_to_json_value(L, 1);
		lua_pop(L, 1); // pop table

		if (!data.is_object()) {
			Output::send<LogLevel::Warning>(STR("EnqueueWebhookEvent: data must be a JSON object\n"));
			lua_net.set_bool(false);
			return 1;
		}

		json::object event_payload;
		event_payload["hook"] = json::string(event_name);
		event_payload["timestamp"] = static_cast<int64_t>(std::time(nullptr));
		event_payload["data"] = std::move(data.as_object());

		EventManager::Get().AddEvent(std::move(event_payload));

		Output::send<LogLevel::Verbose>(STR("EnqueueWebhookEvent: queued event '{}'\n"), to_wstring(event_name));
		lua_net.set_bool(true);
		return 1;
	});

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
