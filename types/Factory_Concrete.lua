---@meta

---@class AFactory_Concrete_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Concrete_C = {}

---@param bShow boolean
function AFactory_Concrete_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Concrete_C:ExecuteUbergraph_Factory_Concrete(EntryPoint) end


