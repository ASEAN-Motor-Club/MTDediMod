---@meta

---@class UW_CheckBox_C : UCheckBoxWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field NameText FText
local UW_CheckBox_C = {}

---@return FSlateColor
function UW_CheckBox_C:Get_NameTextBlock_ColorAndOpacity() end
---@param IsDesignTime boolean
function UW_CheckBox_C:PreConstruct(IsDesignTime) end
---@param EntryPoint int32
function UW_CheckBox_C:ExecuteUbergraph_W_CheckBox(EntryPoint) end


