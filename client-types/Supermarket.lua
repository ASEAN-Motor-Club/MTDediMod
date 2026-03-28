---@meta

---@class ASupermarket_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ASupermarket_C = {}

---@param bShow boolean
function ASupermarket_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ASupermarket_C:ExecuteUbergraph_Supermarket(EntryPoint) end


