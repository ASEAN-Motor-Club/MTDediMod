---@meta

---@class UW_ControlPanelButton_C : UMTButtonWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Background UBorder
---@field Border1 UBorder
---@field TextBorder UBorder
---@field TextHorAlign EHorizontalAlignment
---@field bRoundBorder boolean
local UW_ControlPanelButton_C = {}

---@return ESlateVisibility
function UW_ControlPanelButton_C:Get_Border1_Visibility_0() end
---@return FLinearColor
function UW_ControlPanelButton_C:Get_Border1_BrushColor_0() end
---@return FLinearColor
function UW_ControlPanelButton_C:Get_Background_ContentColorAndOpacity_0() end
---@return ESlateVisibility
function UW_ControlPanelButton_C:Get_Background_Visibility_0() end
---@return FSlateColor
function UW_ControlPanelButton_C:Get_NameTextBlock_ColorAndOpacity_0() end
---@param IsDesignTime boolean
function UW_ControlPanelButton_C:PreConstruct(IsDesignTime) end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_ControlPanelButton_C:Tick(MyGeometry, InDeltaTime) end
---@param EntryPoint int32
function UW_ControlPanelButton_C:ExecuteUbergraph_W_ControlPanelButton(EntryPoint) end


