---@meta

---@class AIT_WinchHook_C : AActor
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Hook UStaticMeshComponent
local AIT_WinchHook_C = {}

function AIT_WinchHook_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AIT_WinchHook_C:ExecuteUbergraph_IT_WinchHook(EntryPoint) end


