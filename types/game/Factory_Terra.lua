---@meta

---@class AFactory_Terra_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Terra_C = {}

---@param bShow boolean
function AFactory_Terra_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Terra_C:ExecuteUbergraph_Factory_Terra(EntryPoint) end


