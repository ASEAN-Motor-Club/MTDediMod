---@meta

---@class ASteelMill_CoalDrop_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ASteelMill_CoalDrop_C = {}

---@param bShow boolean
function ASteelMill_CoalDrop_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ASteelMill_CoalDrop_C:ExecuteUbergraph_SteelMill_CoalDrop(EntryPoint) end


