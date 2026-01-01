---@meta

---@class UW_EditableTextDialog_C : UEditableTextDialogPopupWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field W_Template_Fullscreen_Popup UW_Template_Fullscreen_Popup_C
local UW_EditableTextDialog_C = {}

---@param Title FText
function UW_EditableTextDialog_C:ReceiveSetTitle(Title) end
---@param EntryPoint int32
function UW_EditableTextDialog_C:ExecuteUbergraph_W_EditableTextDialog(EntryPoint) end


