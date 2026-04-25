---@meta

---@class ASteelMill_IronOreDrop_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ASteelMill_IronOreDrop_C = {}

---@param bShow boolean
function ASteelMill_IronOreDrop_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ASteelMill_IronOreDrop_C:ExecuteUbergraph_SteelMill_IronOreDrop(EntryPoint) end


