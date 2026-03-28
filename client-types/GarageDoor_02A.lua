---@meta

---@class AGarageDoor_02A_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTOverlap UMTOverlapComponent
---@field Box UBoxComponent
---@field Door UStaticMeshComponent
---@field MovingPart USceneComponent
---@field Scene USceneComponent
---@field Timeline_0_Scale_6E4045C2451273168ADACE949D0B90AB float
---@field Timeline_0_Height_6E4045C2451273168ADACE949D0B90AB float
---@field Timeline_0__Direction_6E4045C2451273168ADACE949D0B90AB ETimelineDirection::Type
---@field Timeline_0 UTimelineComponent
local AGarageDoor_02A_C = {}

function AGarageDoor_02A_C:Timeline_0__FinishedFunc() end
function AGarageDoor_02A_C:Timeline_0__UpdateFunc() end
function AGarageDoor_02A_C:Up() end
function AGarageDoor_02A_C:Down() end
---@param bHasOverlap boolean
function AGarageDoor_02A_C:BndEvt__GarageDoor_01_MTOverlap_K2Node_ComponentBoundEvent_2_OverlapTestedEvent__DelegateSignature(bHasOverlap) end
---@param EntryPoint int32
function AGarageDoor_02A_C:ExecuteUbergraph_GarageDoor_02A(EntryPoint) end


