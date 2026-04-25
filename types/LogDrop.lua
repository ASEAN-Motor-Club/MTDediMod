---@meta

---@class ALogDrop_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ALogDrop_C = {}

---@param bShow boolean
function ALogDrop_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ALogDrop_C:ExecuteUbergraph_LogDrop(EntryPoint) end


