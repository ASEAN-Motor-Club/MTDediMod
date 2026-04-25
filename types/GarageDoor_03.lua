---@meta

---@class AGarageDoor_03_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTOverlap UMTOverlapComponent
---@field Box UBoxComponent
---@field Door UStaticMeshComponent
---@field MovingPart USceneComponent
---@field Scene USceneComponent
---@field Timeline_0_Scale_4C6E6A0745E7703847CFCD82BB227D3E float
---@field Timeline_0_Height_4C6E6A0745E7703847CFCD82BB227D3E float
---@field Timeline_0__Direction_4C6E6A0745E7703847CFCD82BB227D3E ETimelineDirection::Type
---@field Timeline_0 UTimelineComponent
local AGarageDoor_03_C = {}

function AGarageDoor_03_C:Timeline_0__FinishedFunc() end
function AGarageDoor_03_C:Timeline_0__UpdateFunc() end
function AGarageDoor_03_C:Up() end
function AGarageDoor_03_C:Down() end
---@param bHasOverlap boolean
function AGarageDoor_03_C:BndEvt__GarageDoor_01_MTOverlap_K2Node_ComponentBoundEvent_2_OverlapTestedEvent__DelegateSignature(bHasOverlap) end
---@param EntryPoint int32
function AGarageDoor_03_C:ExecuteUbergraph_GarageDoor_03(EntryPoint) end


