---@meta

---@class ACoalWarehouse_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ACoalWarehouse_C = {}

---@param bShow boolean
function ACoalWarehouse_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ACoalWarehouse_C:ExecuteUbergraph_CoalWarehouse(EntryPoint) end


