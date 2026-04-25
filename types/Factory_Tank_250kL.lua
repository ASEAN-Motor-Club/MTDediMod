---@meta

---@class AFactory_Tank_250kL_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFactory_Tank_250kL_C = {}

---@param bShow boolean
function AFactory_Tank_250kL_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFactory_Tank_250kL_C:ExecuteUbergraph_Factory_Tank_250kL(EntryPoint) end


