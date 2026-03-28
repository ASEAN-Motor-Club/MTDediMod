---@meta

---@class UW_MapIconBase_C : UMapIconWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Highlighted UWidgetAnimation
---@field HighlightImage UImage
---@field MenuBG1_Round_C_0 UMenuBG1_Round_C
---@field MenuBG2_RoundHighlight_C_0 UMenuBG2_RoundHighlight_C
---@field SelectedImage UWB_Icon_Base_C
local UW_MapIconBase_C = {}

---@param bInHighlighted boolean
function UW_MapIconBase_C:ReceiveHighlighted(bInHighlighted) end
---@param bSelected boolean
function UW_MapIconBase_C:ReceiveSelected(bSelected) end
---@param EntryPoint int32
function UW_MapIconBase_C:ExecuteUbergraph_W_MapIconBase(EntryPoint) end


