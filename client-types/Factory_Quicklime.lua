---@meta

---@class AFactory_Quicklime_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Quicklime_C = {}

---@param bShow boolean
function AFactory_Quicklime_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Quicklime_C:ExecuteUbergraph_Factory_Quicklime(EntryPoint) end


