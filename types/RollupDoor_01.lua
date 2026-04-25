---@meta

---@class ARollupDoor_01_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTOverlap UMTOverlapComponent
---@field Box UBoxComponent
---@field Door UStaticMeshComponent
---@field MovingPart USceneComponent
---@field Scene USceneComponent
---@field Timeline_0_Scale_AA27DC164D66C76514C353B377E2CF00 float
---@field Timeline_0__Direction_AA27DC164D66C76514C353B377E2CF00 ETimelineDirection::Type
---@field Timeline_0 UTimelineComponent
local ARollupDoor_01_C = {}

function ARollupDoor_01_C:Timeline_0__FinishedFunc() end
function ARollupDoor_01_C:Timeline_0__UpdateFunc() end
function ARollupDoor_01_C:Up() end
function ARollupDoor_01_C:Down() end
---@param bHasOverlap boolean
function ARollupDoor_01_C:BndEvt__GarageDoor_01_MTOverlap_K2Node_ComponentBoundEvent_2_OverlapTestedEvent__DelegateSignature(bHasOverlap) end
---@param EntryPoint int32
function ARollupDoor_01_C:ExecuteUbergraph_RollupDoor_01(EntryPoint) end


