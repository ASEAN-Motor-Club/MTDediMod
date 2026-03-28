---@meta

---@class AAC_Character_C : AMTAICharacterController
---@field UberGraphFrame FPointerToUberGraphFrame
local AAC_Character_C = {}

function AAC_Character_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AAC_Character_C:ExecuteUbergraph_AC_Character(EntryPoint) end


