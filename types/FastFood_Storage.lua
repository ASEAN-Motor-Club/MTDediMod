---@meta

---@class AFastFood_Storage_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MotorTownInteractable UMTInteractableComponent
---@field InteractionCube UStaticMeshComponent
local AFastFood_Storage_C = {}

---@param Goods AActor
function AFastFood_Storage_C:ReceiveSetGoods(Goods) end
---@param bShow boolean
function AFastFood_Storage_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AFastFood_Storage_C:ExecuteUbergraph_FastFood_Storage(EntryPoint) end


