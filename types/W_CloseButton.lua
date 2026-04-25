---@meta

---@class UW_CloseButton_C : UCancelButtonWidget
---@field UberGraphFrame FPointerToUberGraphFrame
---@field Background UBorder
---@field Border1 UBorder
---@field TextHorAlign EHorizontalAlignment
---@field bRoundBorder boolean
local UW_CloseButton_C = {}

---@return ESlateVisibility
function UW_CloseButton_C:Get_Border1_Visibility_0() end
---@return FLinearColor
function UW_CloseButton_C:Get_Border1_BrushColor_0() end
---@return FLinearColor
function UW_CloseButton_C:Get_Background_ContentColorAndOpacity_0() end
---@return ESlateVisibility
function UW_CloseButton_C:Get_Background_Visibility_0() end
---@return FSlateColor
function UW_CloseButton_C:Get_NameTextBlock_ColorAndOpacity_0() end
---@param IsDesignTime boolean
function UW_CloseButton_C:PreConstruct(IsDesignTime) end
---@param MyGeometry FGeometry
---@param InDeltaTime float
function UW_CloseButton_C:Tick(MyGeometry, InDeltaTime) end
---@param bNewChecked boolean
function UW_CloseButton_C:ReceiveCheckChanged(bNewChecked) end
---@param EntryPoint int32
function UW_CloseButton_C:ExecuteUbergraph_W_CloseButton(EntryPoint) end


