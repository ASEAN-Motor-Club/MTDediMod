---@meta

---@class AJobTutorialNPC_C : AMTAICharacter_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTVendor UMTVendorComponent
---@field MTInteractable UMTInteractableComponent
---@field MTDialogue UMTDialogueComponent
local AJobTutorialNPC_C = {}

function AJobTutorialNPC_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AJobTutorialNPC_C:ExecuteUbergraph_JobTutorialNPC(EntryPoint) end


