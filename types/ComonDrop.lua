---@meta

---@class AComonDrop_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AComonDrop_C = {}

---@param bShow boolean
function AComonDrop_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AComonDrop_C:ExecuteUbergraph_ComonDrop(EntryPoint) end


