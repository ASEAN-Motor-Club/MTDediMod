---@meta

---@class ASteelMill_LimestoneDrop_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ASteelMill_LimestoneDrop_C = {}

---@param bShow boolean
function ASteelMill_LimestoneDrop_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ASteelMill_LimestoneDrop_C:ExecuteUbergraph_SteelMill_LimestoneDrop(EntryPoint) end


