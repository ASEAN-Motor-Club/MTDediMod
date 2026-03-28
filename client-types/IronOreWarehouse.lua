---@meta

---@class AIronOreWarehouse_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AIronOreWarehouse_C = {}

---@param bShow boolean
function AIronOreWarehouse_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AIronOreWarehouse_C:ExecuteUbergraph_IronOreWarehouse(EntryPoint) end


