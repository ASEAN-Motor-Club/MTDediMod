---@meta

---@class ALogWarehouse_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local ALogWarehouse_C = {}

---@param bShow boolean
function ALogWarehouse_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ALogWarehouse_C:ExecuteUbergraph_LogWarehouse(EntryPoint) end


