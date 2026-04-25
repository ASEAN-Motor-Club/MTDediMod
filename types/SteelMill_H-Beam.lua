---@meta

---@class ASteelMill_H-Beam_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ASteelMill_H-Beam_C = {}

---@param bShow boolean
function ASteelMill_H-Beam_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
ASteelMill_H-Beam_C['ExecuteUbergraph_SteelMill_H-Beam'] = function(self, EntryPoint) end


