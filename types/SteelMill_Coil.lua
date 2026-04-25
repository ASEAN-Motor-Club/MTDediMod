---@meta

---@class ASteelMill_Coil_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ASteelMill_Coil_C = {}

---@param bShow boolean
function ASteelMill_Coil_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ASteelMill_Coil_C:ExecuteUbergraph_SteelMill_Coil(EntryPoint) end


