---@meta

---@class AResident_C : AMTDeliveryPoint
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Billboard UBillboardComponent
---@field MTComponentLOD UMTComponentLODComponent
---@field MotorTownInteractable UMTInteractableComponent
---@field Capsule UCapsuleComponent
---@field InteractionCube UStaticMeshComponent
---@field SkeletalMesh USkeletalMeshComponent
local AResident_C = {}

---@param Goods AActor
function AResident_C:ReceiveSetGoods(Goods) end
---@param bShow boolean
function AResident_C:ReceiveShowInteractionArea(bShow) end
---@param EntryPoint int32
function AResident_C:ExecuteUbergraph_Resident(EntryPoint) end


