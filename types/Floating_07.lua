---@meta

---@class AFloating_07_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Rotate_Rotate_Z_5889CD0740A5CC91CB8E5398AF1A2BCA float
---@field Rotate_Rotate_Y_5889CD0740A5CC91CB8E5398AF1A2BCA float
---@field Rotate_Rotate_X_5889CD0740A5CC91CB8E5398AF1A2BCA float
---@field Rotate__Direction_5889CD0740A5CC91CB8E5398AF1A2BCA ETimelineDirection::Type
---@field Rotate UTimelineComponent
---@field Intensity double
local AFloating_07_C = {}

function AFloating_07_C:Rotate__FinishedFunc() end
function AFloating_07_C:Rotate__UpdateFunc() end
---@param DeltaSeconds float
function AFloating_07_C:ReceiveTick(DeltaSeconds) end
function AFloating_07_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AFloating_07_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AFloating_07_C:ExecuteUbergraph_Floating_07(EntryPoint) end


