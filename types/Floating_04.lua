---@meta

---@class AFloating_04_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Rotate_Rotate_Z_A11993B34FCF0E97DDBF08914F4BC695 float
---@field Rotate_Rotate_Y_A11993B34FCF0E97DDBF08914F4BC695 float
---@field Rotate_Rotate_X_A11993B34FCF0E97DDBF08914F4BC695 float
---@field Rotate__Direction_A11993B34FCF0E97DDBF08914F4BC695 ETimelineDirection::Type
---@field Rotate UTimelineComponent
---@field Intensity double
local AFloating_04_C = {}

function AFloating_04_C:Rotate__FinishedFunc() end
function AFloating_04_C:Rotate__UpdateFunc() end
---@param DeltaSeconds float
function AFloating_04_C:ReceiveTick(DeltaSeconds) end
function AFloating_04_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AFloating_04_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AFloating_04_C:ExecuteUbergraph_Floating_04(EntryPoint) end


