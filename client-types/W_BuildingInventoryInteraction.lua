---@meta

---@class UW_BuildingInventoryInteraction_C : UBuildingInventoryInteractionWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field CloseButton UW_CloseButton_C
---@field FullScreenMenuBG1 UFullScreenMenuBG1_C
---@field W_Template_PopupWindow UW_Template_PopupWindow_C
---@field W_Template_PopupWindow_85 UW_Template_PopupWindow_C
local UW_BuildingInventoryInteraction_C = {}

function UW_BuildingInventoryInteraction_C:BndEvt__W_VehiclePartInventoryInteraction_CloseButton_K2Node_ComponentBoundEvent_0_MTButtonEvent__DelegateSignature() end
---@param BuildingName FText
function UW_BuildingInventoryInteraction_C:SetBuildingName(BuildingName) end
---@param EntryPoint int32
function UW_BuildingInventoryInteraction_C:ExecuteUbergraph_W_BuildingInventoryInteraction(EntryPoint) end


