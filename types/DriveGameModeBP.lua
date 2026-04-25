---@meta

---@class ADriveGameModeBP_C : AMotorTownGameMode
---@field UberGraphFrame FPointerToUberGraphFrame
---@field DefaultSceneRoot USceneComponent
local ADriveGameModeBP_C = {}

function ADriveGameModeBP_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function ADriveGameModeBP_C:ExecuteUbergraph_DriveGameModeBP(EntryPoint) end


