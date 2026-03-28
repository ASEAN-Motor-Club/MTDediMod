---@meta

---@class AWarehouseDoor_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ChildActor UChildActorComponent
---@field InteractionCube UStaticMeshComponent
---@field MotorTownInteractable UMTInteractableComponent
local AWarehouseDoor_C = {}

---@param bShow boolean
function AWarehouseDoor_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AWarehouseDoor_C:ExecuteUbergraph_WarehouseDoor(EntryPoint) end


