---@meta

---@class AFloating_05_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Rotate_Rotate_Z_BAC113884A484206A05038BDB6E8E1F1 float
---@field Rotate_Rotate_Y_BAC113884A484206A05038BDB6E8E1F1 float
---@field Rotate_Rotate_X_BAC113884A484206A05038BDB6E8E1F1 float
---@field Rotate__Direction_BAC113884A484206A05038BDB6E8E1F1 ETimelineDirection::Type
---@field Rotate UTimelineComponent
---@field Intensity double
local AFloating_05_C = {}

function AFloating_05_C:Rotate__FinishedFunc() end
function AFloating_05_C:Rotate__UpdateFunc() end
---@param DeltaSeconds float
function AFloating_05_C:ReceiveTick(DeltaSeconds) end
function AFloating_05_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AFloating_05_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AFloating_05_C:ExecuteUbergraph_Floating_05(EntryPoint) end


