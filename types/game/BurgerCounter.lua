---@meta

---@class ABurgerCounter_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTComponentLOD UMTComponentLODComponent
---@field MotorTownInteractable UMTInteractableComponent
---@field Capsule UCapsuleComponent
---@field InteractionCube UStaticMeshComponent
---@field SkeletalMesh USkeletalMeshComponent
local ABurgerCounter_C = {}

---@param Goods AActor
function ABurgerCounter_C:ReceiveSetGoods(Goods) end
---@param bShow boolean
function ABurgerCounter_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function ABurgerCounter_C:ExecuteUbergraph_BurgerCounter(EntryPoint) end


