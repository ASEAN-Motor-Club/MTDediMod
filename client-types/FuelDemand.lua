---@meta

---@class AFuelDemand_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFuelDemand_C = {}

---@param bShow boolean
function AFuelDemand_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFuelDemand_C:ExecuteUbergraph_FuelDemand(EntryPoint) end


