---@meta

---@class ABar_02_Move_C : AMTBreakable
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Box UBoxComponent
---@field MTOverlap UMTOverlapComponent
---@field MovingPart UStaticMeshComponent
---@field Timeline_Height_C4963C7346F8DCE1209B1DB5AE6109BF float
---@field Timeline__Direction_C4963C7346F8DCE1209B1DB5AE6109BF ETimelineDirection::Type
---@field Timeline UTimelineComponent
local ABar_02_Move_C = {}

function ABar_02_Move_C:Timeline__FinishedFunc() end
function ABar_02_Move_C:Timeline__UpdateFunc() end
function ABar_02_Move_C:Close() end
function ABar_02_Move_C:Open() end
---@param bHasOverlap boolean
function ABar_02_Move_C:BndEvt__GarageDoor_01_MTOverlap_K2Node_ComponentBoundEvent_2_OverlapTestedEvent__DelegateSignature(bHasOverlap) end
function ABar_02_Move_C:ReceiveBroken() end
---@param EntryPoint int32
function ABar_02_Move_C:ExecuteUbergraph_Bar_02_Move(EntryPoint) end


