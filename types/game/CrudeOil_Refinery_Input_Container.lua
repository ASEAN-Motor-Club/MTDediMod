---@meta

---@class ACrudeOil_Refinery_Input_Container_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ACrudeOil_Refinery_Input_Container_C = {}

---@param bShow boolean
function ACrudeOil_Refinery_Input_Container_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ACrudeOil_Refinery_Input_Container_C:ExecuteUbergraph_CrudeOil_Refinery_Input_Container(EntryPoint) end


