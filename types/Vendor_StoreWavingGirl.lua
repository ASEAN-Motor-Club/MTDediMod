---@meta

---@class AVendor_StoreWavingGirl_C : AMTAICharacter_C
---@field UberGraphFrame FPointerToUberGraphFrame
---@field MTInteractable UMTInteractableComponent
---@field MTDialogue UMTDialogueComponent
local AVendor_StoreWavingGirl_C = {}

function AVendor_StoreWavingGirl_C:ReceiveBeginPlay() end
---@param EntryPoint int32
function AVendor_StoreWavingGirl_C:ExecuteUbergraph_Vendor_StoreWavingGirl(EntryPoint) end


