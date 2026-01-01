---@meta

---@class AGarageDoor_02_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTOverlap UMTOverlapComponent
---@field Box UBoxComponent
---@field Door UStaticMeshComponent
---@field MovingPart USceneComponent
---@field Scene USceneComponent
---@field Timeline_0_Height_20F5C6F345AA24BB2E8DC89125FA0DE8 float
---@field Timeline_0__Direction_20F5C6F345AA24BB2E8DC89125FA0DE8 ETimelineDirection::Type
---@field Timeline_0 UTimelineComponent
local AGarageDoor_02_C = {}

function AGarageDoor_02_C:Timeline_0__FinishedFunc() end
function AGarageDoor_02_C:Timeline_0__UpdateFunc() end
function AGarageDoor_02_C:Up() end
function AGarageDoor_02_C:Down() end
---@param bHasOverlap boolean
function AGarageDoor_02_C:BndEvt__GarageDoor_01_MTOverlap_K2Node_ComponentBoundEvent_2_OverlapTestedEvent__DelegateSignature(bHasOverlap) end
---@param EntryPoint int32
function AGarageDoor_02_C:ExecuteUbergraph_GarageDoor_02(EntryPoint) end


