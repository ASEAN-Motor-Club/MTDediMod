---@meta

---@class APizzaCounter_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTComponentLOD UMTComponentLODComponent
---@field MotorTownInteractable UMTInteractableComponent
---@field Capsule UCapsuleComponent
---@field InteractionCube UStaticMeshComponent
---@field SkeletalMesh USkeletalMeshComponent
local APizzaCounter_C = {}

---@param Goods AActor
function APizzaCounter_C:ReceiveSetGoods(Goods) end
---@param bShow boolean
function APizzaCounter_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function APizzaCounter_C:ExecuteUbergraph_PizzaCounter(EntryPoint) end


