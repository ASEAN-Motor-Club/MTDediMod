---@meta

---@class UListItemBG_02_C : UMTListViewEntryBG
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Border_0 UBorder
---@field HoveredImage UImage
---@field Selected boolean
---@field Focused boolean
---@field Hovered boolean
local UListItemBG_02_C = {}

---@return FLinearColor
function UListItemBG_02_C:Get_HoveredImage_ColorAndOpacity() end
---@return ESlateVisibility
function UListItemBG_02_C:Get_HoveredImage_Visibility() end
---@return FLinearColor
function UListItemBG_02_C:Get_Border_0_BrushColor_0() end
---@param bSelected boolean
function UListItemBG_02_C:ReceiveSetSelected(bSelected) end
---@param bFocused boolean
function UListItemBG_02_C:ReceiveSetFocused(bFocused) end
---@param bHovered boolean
function UListItemBG_02_C:ReceiveSetHovered(bHovered) end
---@param EntryPoint int32
function UListItemBG_02_C:ExecuteUbergraph_ListItemBG_02(EntryPoint) end


