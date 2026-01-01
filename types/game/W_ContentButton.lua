---@meta

---@class UW_ContentButton_C : UMTButtonWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Background UBorder
---@field Border1 UBorder
---@field Content UNamedSlot
---@field TextHorAlign EHorizontalAlignment
---@field bRoundBorder boolean
local UW_ContentButton_C = {}

---@return ESlateVisibility
function UW_ContentButton_C:Get_Border1_Visibility_0() end
---@return FLinearColor
function UW_ContentButton_C:Get_Border1_BrushColor_0() end
---@return FLinearColor
function UW_ContentButton_C:Get_Background_ContentColorAndOpacity_0() end
---@return ESlateVisibility
function UW_ContentButton_C:Get_Background_Visibility_0() end
---@return FSlateColor
function UW_ContentButton_C:Get_NameTextBlock_ColorAndOpacity_0() end
---@param IsDesignTime boolean
function UW_ContentButton_C:PreConstruct(IsDesignTime) end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_ContentButton_C:Tick(MyGeometry, InDeltaTime) end
---@param bNewChecked boolean
function UW_ContentButton_C:ReceiveCheckChanged(bNewChecked) end
---@param EntryPoint int32
function UW_ContentButton_C:ExecuteUbergraph_W_ContentButton(EntryPoint) end


