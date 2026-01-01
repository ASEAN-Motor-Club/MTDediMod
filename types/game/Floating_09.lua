---@meta

---@class AFloating_09_C : AStaticMeshActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Rotate_Rotate_Y_FEB0C58A4C5F5A8860B1B3A0D8DCC893 float
---@field Rotate_Rotate_X_FEB0C58A4C5F5A8860B1B3A0D8DCC893 float
---@field Rotate__Direction_FEB0C58A4C5F5A8860B1B3A0D8DCC893 ETimelineDirection::Type
---@field Rotate UTimelineComponent
---@field Intensity double
local AFloating_09_C = {}

function AFloating_09_C:Rotate__FinishedFunc() end
function AFloating_09_C:Rotate__UpdateFunc() end
---@param DeltaSeconds float
function AFloating_09_C:ReceiveTick(DeltaSeconds) end
function AFloating_09_C:ReceiveBeginPlay() end
---@param EndPlayReason EEndPlayReason::Type
function AFloating_09_C:ReceiveEndPlay(EndPlayReason) end
---@param EntryPoint int32
function AFloating_09_C:ExecuteUbergraph_Floating_09(EntryPoint) end


