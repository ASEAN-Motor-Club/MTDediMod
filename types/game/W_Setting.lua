---@meta

---@class UW_Setting_C : USettingWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field NameScaleBox UScaleBox
---@field Name FText
---@field NameAlignLeft boolean
local UW_Setting_C = {}

---@return FSlateColor
function UW_Setting_C:Get_NameTextBlock_ColorAndOpacity() end
---@param IsDesignTime boolean
function UW_Setting_C:PreConstruct(IsDesignTime) end
---@param EntryPoint int32
function UW_Setting_C:ExecuteUbergraph_W_Setting(EntryPoint) end


