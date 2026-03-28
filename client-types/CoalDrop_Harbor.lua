---@meta

---@class ACoalDrop_Harbor_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ACoalDrop_Harbor_C = {}

---@param bShow boolean
function ACoalDrop_Harbor_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ACoalDrop_Harbor_C:ExecuteUbergraph_CoalDrop_Harbor(EntryPoint) end


