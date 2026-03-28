---@meta

---@class AGarageDoor_02B_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTOverlap UMTOverlapComponent
---@field Box UBoxComponent
---@field Door UStaticMeshComponent
---@field MovingPart USceneComponent
---@field Scene USceneComponent
---@field Timeline_0_Scale_7D696BB84BD1892C386E2D97A7FB56EA float
---@field Timeline_0_Height_7D696BB84BD1892C386E2D97A7FB56EA float
---@field Timeline_0__Direction_7D696BB84BD1892C386E2D97A7FB56EA ETimelineDirection::Type
---@field Timeline_0 UTimelineComponent
local AGarageDoor_02B_C = {}

function AGarageDoor_02B_C:Timeline_0__FinishedFunc() end
function AGarageDoor_02B_C:Timeline_0__UpdateFunc() end
function AGarageDoor_02B_C:Up() end
function AGarageDoor_02B_C:Down() end
---@param bHasOverlap boolean
function AGarageDoor_02B_C:BndEvt__GarageDoor_01_MTOverlap_K2Node_ComponentBoundEvent_2_OverlapTestedEvent__DelegateSignature(bHasOverlap) end
---@param EntryPoint int32
function AGarageDoor_02B_C:ExecuteUbergraph_GarageDoor_02B(EntryPoint) end


