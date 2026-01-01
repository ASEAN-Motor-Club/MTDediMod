---@meta

---@class ACourierService_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ACourierService_C = {}

---@param bShow boolean
function ACourierService_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ACourierService_C:ExecuteUbergraph_CourierService(EntryPoint) end


