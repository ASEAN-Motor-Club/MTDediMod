---@meta

---@class UW_Dialogue_C : UDialogueWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field W_Template_PopupWindow UW_Template_PopupWindow_C
local UW_Dialogue_C = {}

function UW_Dialogue_C:Construct() end
---@param EntryPoint int32
function UW_Dialogue_C:ExecuteUbergraph_W_Dialogue(EntryPoint) end


