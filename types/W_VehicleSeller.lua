---@meta

---@class UW_VehicleSeller_C : UVehicleSellerWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field BuyButton UW_Button_C
---@field RentButton UW_Button_C
---@field Template_Popup UW_Template_Fullscreen_Popup_C
local UW_VehicleSeller_C = {}

function UW_VehicleSeller_C:BndEvt__BuyButton_K2Node_ComponentBoundEvent_0_OnMenuButtonClickedEvent__DelegateSignature() end
function UW_VehicleSeller_C:BndEvt__RentButton_K2Node_ComponentBoundEvent_2_MTButtonClickedEvent__DelegateSignature() end
function UW_VehicleSeller_C:BndEvt__W_VehicleSeller_InfoButton_K2Node_ComponentBoundEvent_1_MTButtonEvent__DelegateSignature() end
---@param EntryPoint int32
function UW_VehicleSeller_C:ExecuteUbergraph_W_VehicleSeller(EntryPoint) end


