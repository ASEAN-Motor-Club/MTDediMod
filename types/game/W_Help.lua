---@meta

---@class UW_Help_C : UHelpWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field FullScreenMenuBG1 UFullScreenMenuBG1_C
---@field MenuBG1 UMenuBG1_C
---@field W_TabMenu UW_TabMenu_C
---@field W_Template_PopupWindow UW_Template_PopupWindow_C
local UW_Help_C = {}

---@param Index int32
function UW_Help_C:ReceiveSetTabIndex(Index) end
---@param EntryPoint int32
function UW_Help_C:ExecuteUbergraph_W_Help(EntryPoint) end


