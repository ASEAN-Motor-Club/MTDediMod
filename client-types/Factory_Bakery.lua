---@meta

---@class AFactory_Bakery_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Bakery_C = {}

---@param bShow boolean
function AFactory_Bakery_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Bakery_C:ExecuteUbergraph_Factory_Bakery(EntryPoint) end


