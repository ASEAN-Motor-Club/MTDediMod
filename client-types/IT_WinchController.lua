---@meta

---@class AIT_WinchController_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Controller UStaticMeshComponent
local AIT_WinchController_C = {}

function AIT_WinchController_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_WinchController_C:ExecuteUbergraph_IT_WinchController(EntryPoint) end


