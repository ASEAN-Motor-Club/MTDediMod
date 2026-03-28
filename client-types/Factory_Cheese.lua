---@meta

---@class AFactory_Cheese_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Cheese_C = {}

---@param bShow boolean
function AFactory_Cheese_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Cheese_C:ExecuteUbergraph_Factory_Cheese(EntryPoint) end


