---@meta

---@class UW_Button_C : UMTButtonWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Background UBorder
---@field BorderLine UBorder
---@field TextScaleBox UScaleBox
---@field TextHorAlign EHorizontalAlignment
---@field bLargeHeight boolean
---@field bShowInputKey boolean
---@field bRoundBorder boolean
---@field TextPaddingSmall boolean
---@field bShowBorder boolean
local UW_Button_C = {}

---@return ESlateVisibility
function UW_Button_C:Get_Border1_Visibility_0() end
---@return FLinearColor
function UW_Button_C:Get_Border1_BrushColor_0() end
---@return FLinearColor
function UW_Button_C:Get_Background_ContentColorAndOpacity_0() end
---@return ESlateVisibility
function UW_Button_C:Get_Background_Visibility_0() end
---@return FSlateColor
function UW_Button_C:Get_NameTextBlock_ColorAndOpacity_0() end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_Button_C:Tick(MyGeometry, InDeltaTime) end
---@param bNewChecked boolean
function UW_Button_C:ReceiveCheckChanged(bNewChecked) end
---@param IsDesignTime boolean
function UW_Button_C:PreConstruct(IsDesignTime) end
function UW_Button_C:Construct() end
---@param EntryPoint int32
function UW_Button_C:ExecuteUbergraph_W_Button(EntryPoint) end


