---@meta

---@class AFactory_Meat_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Meat_C = {}

---@param bShow boolean
function AFactory_Meat_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Meat_C:ExecuteUbergraph_Factory_Meat(EntryPoint) end


