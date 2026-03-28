---@meta

---@class AFactory_Bottle_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Bottle_C = {}

---@param bShow boolean
function AFactory_Bottle_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Bottle_C:ExecuteUbergraph_Factory_Bottle(EntryPoint) end


