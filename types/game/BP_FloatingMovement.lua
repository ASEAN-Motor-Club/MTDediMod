---@meta

---@class UBP_FloatingMovement_C : UActorComponent
---@field UberGraphFrame FPointerToUberGraphFrame
---@field OriginalTransform FTransform
---@field Time double
---@field SwayMultiplier double
local UBP_FloatingMovement_C = {}

function UBP_FloatingMovement_C:ReceiveBeginPlay() end
---@param DeltaSeconds float
function UBP_FloatingMovement_C:ReceiveTick(DeltaSeconds) end
---@param EntryPoint int32
function UBP_FloatingMovement_C:ExecuteUbergraph_BP_FloatingMovement(EntryPoint) end


