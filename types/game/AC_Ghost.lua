---@meta

---@class AAC_Ghost_C : AMTAICharacterController
---@field UberGraphFrame FPointerToUberGraphFrame
local AAC_Ghost_C = {}

function AAC_Ghost_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AAC_Ghost_C:ExecuteUbergraph_AC_Ghost(EntryPoint) end


