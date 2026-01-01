---@meta

---@class UW_WhisperEntry_C : UWhisperTargetEntryWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field ListItemBG UListItemBG_02_C
---@field WhisperTextBlock UTextBlock
local UW_WhisperEntry_C = {}

---@param bIsSelected boolean
function UW_WhisperEntry_C:BP_OnItemSelectionChanged(bIsSelected) end
---@param EntryPoint int32
function UW_WhisperEntry_C:ExecuteUbergraph_W_WhisperEntry(EntryPoint) end


