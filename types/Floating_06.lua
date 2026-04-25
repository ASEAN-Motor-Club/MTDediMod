---@meta

---@class AFloating_06_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Rotate_Rotate_Z_7D3386F44E6CDE7F7EA4898DDF01094E float
---@field Rotate_Rotate_Y_7D3386F44E6CDE7F7EA4898DDF01094E float
---@field Rotate_Rotate_X_7D3386F44E6CDE7F7EA4898DDF01094E float
---@field Rotate__Direction_7D3386F44E6CDE7F7EA4898DDF01094E ETimelineDirection::Type
---@field Rotate UTimelineComponent
---@field Intensity double
local AFloating_06_C = {}

function AFloating_06_C:Rotate__FinishedFunc() end
function AFloating_06_C:Rotate__UpdateFunc() end
---@param DeltaSeconds float
function AFloating_06_C:ReceiveTick(DeltaSeconds) end
function AFloating_06_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AFloating_06_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AFloating_06_C:ExecuteUbergraph_Floating_06(EntryPoint) end


