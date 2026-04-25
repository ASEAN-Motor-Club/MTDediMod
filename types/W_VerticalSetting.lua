---@meta

---@class UW_VerticalSetting_C : USettingWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field NameScaleBox UScaleBox
---@field Name FText
---@field NameAlignLeft boolean
local UW_VerticalSetting_C = {}

---@return FSlateColor
function UW_VerticalSetting_C:Get_NameTextBlock_ColorAndOpacity() end
---@param IsDesignTime boolean
function UW_VerticalSetting_C:PreConstruct(IsDesignTime) end
---@param EntryPoint int32
function UW_VerticalSetting_C:ExecuteUbergraph_W_VerticalSetting(EntryPoint) end


