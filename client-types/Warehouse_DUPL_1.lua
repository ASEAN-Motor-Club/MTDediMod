---@meta

---@class AWarehouse_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ChildActor UChildActorComponent
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AWarehouse_C = {}

---@param bShow boolean
function AWarehouse_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AWarehouse_C:ExecuteUbergraph_Warehouse(EntryPoint) end


