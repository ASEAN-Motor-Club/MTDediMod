---@meta

---@class UListItemBG_01_C : UMTListViewEntryBG
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Border_0 UBorder
---@field Selected boolean
---@field Focused boolean
local UListItemBG_01_C = {}

---@return FLinearColor
function UListItemBG_01_C:Get_Border_0_BrushColor_0() end
---@param bSelected boolean
function UListItemBG_01_C:ReceiveSetSelected(bSelected) end
---@param bFocused boolean
function UListItemBG_01_C:ReceiveSetFocused(bFocused) end
---@param EntryPoint int32
function UListItemBG_01_C:ExecuteUbergraph_ListItemBG_01(EntryPoint) end


