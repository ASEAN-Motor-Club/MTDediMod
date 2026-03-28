---@meta

---@class AOil_Drop_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AOil_Drop_C = {}

---@param bShow boolean
function AOil_Drop_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AOil_Drop_C:ExecuteUbergraph_Oil_Drop(EntryPoint) end


