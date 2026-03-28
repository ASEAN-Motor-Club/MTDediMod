---@meta

---@class AFarm_Base__C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AFarm_Base__C = {}

---@param bShow boolean
function AFarm_Base__C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFarm_Base__C:ExecuteUbergraph_Farm_Base_(EntryPoint) end


