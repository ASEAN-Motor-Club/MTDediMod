---@meta

---@class AFactory_Toy_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Toy_C = {}

---@param bShow boolean
function AFactory_Toy_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Toy_C:ExecuteUbergraph_Factory_Toy(EntryPoint) end


