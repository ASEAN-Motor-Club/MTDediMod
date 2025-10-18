#include "dllmain.h"

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
	auto prehook = [](UnrealScriptFunctionCallableContext& Context, void* CustomData) {
		Output::send<LogLevel::Verbose>(STR("prehook\n"));
		const auto FunctionBeingExecuted = Context.TheStack.CurrentNativeFunction() ? Context.TheStack.CurrentNativeFunction() : *std::bit_cast<UFunction**>(&Context.TheStack.Code()[0 - sizeof(uint64)]);
		auto CargosProperty = FunctionBeingExecuted->GetPropertyByName(STR("Cargos"));
		const auto& cargos = CargosProperty->ContainerPtrToValuePtr<TArray<UObject*>>(Context.TheStack.Locals());
		for (const auto& cargo : *cargos) {
			const auto& CargoKey = cargo->GetValuePtrByPropertyNameInChain<FName>(STR("Net_CargoKey"));
			if (CargoKey) {
				Output::send<LogLevel::Verbose>(STR("Cargo {}\n"), CargoKey->ToString());
			}
			const auto& Damage = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_Damage"));
			if (Damage) {
				Output::send<LogLevel::Verbose>(STR("Damage {}\n"), *Damage);
			}
			const auto& DestinationLocation = cargo->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_DestinationLocation"));
			const auto& SenderAbsoluteLocation = cargo->GetValuePtrByPropertyNameInChain<FVector>(STR("Net_SenderAbsoluteLocation"));
			const auto& TimeLeftSeconds = cargo->GetValuePtrByPropertyNameInChain<float>(STR("Net_TimeLeftSeconds"));
			auto PaymentProperty = static_cast<FStructProperty*>(cargo->GetPropertyByNameInChain(STR("Net_Payment")));
			auto TopLevelPayment = PaymentProperty->GetStruct();
			auto Payment = PaymentProperty->ContainerPtrToValuePtr<void>(cargo);
			auto BaseValueProperty = TopLevelPayment->GetPropertyByNameInChain(STR("BaseValue"));
			auto BasePayment = BaseValueProperty->ContainerPtrToValuePtr<int64>(Payment);
			if (BasePayment) {
				Output::send<LogLevel::Verbose>(STR("Base payment {}\n"), *BasePayment);
			}
		}
	};
	auto posthook = [](UnrealScriptFunctionCallableContext& Context, void* CustomData) {
		Output::send<LogLevel::Verbose>(STR("posthook\n"));
		};
	UObjectGlobals::RegisterHook(STR("/Script/MotorTown.MotorTownPlayerController:ServerCargoArrived"), prehook, posthook, nullptr);
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
