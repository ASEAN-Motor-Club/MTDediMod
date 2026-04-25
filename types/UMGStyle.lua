---@meta

---@class UUMGStyle_C : UBlueprintFunctionLibrary
local UUMGStyle_C = {}

---@param __WorldContext UObject
---@param ColorPalette UMTUIColorPalette
function UUMGStyle_C:GetColorPalette(__WorldContext, ColorPalette) end
---@param ButtonType ButtonType::Type
---@param __WorldContext UObject
---@param ButtonStyle FButtonStyle
function UUMGStyle_C:GetButtonStyle_Default(ButtonType, __WorldContext, ButtonStyle) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetDestinationIconColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetWreckerIconColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetPoliceIconColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FSlateColor
function UUMGStyle_C:GetHoveredColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FSlateColor
function UUMGStyle_C:GetPopupTitleTextColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetCompanyIconColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Brush FSlateBrush
function UUMGStyle_C:GetFocusBorderBrush(__WorldContext, Brush) end
---@param __WorldContext UObject
---@param Style FCheckBoxStyle
function UUMGStyle_C:GetCheckBoxStyle(__WorldContext, Style) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetHightlightColor(__WorldContext, Color) end
---@param IconType EMTIconType
---@param Disabled boolean
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetIconColor(IconType, Disabled, __WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FSlateColor
function UUMGStyle_C:GetTitleTextColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetTitleBGColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetDeliveryIconColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetTradeIconColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetDroppedCargoIconColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetJobIconColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FSlateColor
function UUMGStyle_C:GetButtonTextColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetButtonCheckedBackgroundColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetButtonBackgroundColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FSlateColor
function UUMGStyle_C:GetTableHeaderTextColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FSlateColor
function UUMGStyle_C:GetHighlightTextColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FSlateColor
function UUMGStyle_C:GetFocusTextColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FSlateColor
function UUMGStyle_C:GetTextColor(__WorldContext, Color) end
---@param __WorldContext UObject
---@param Color FLinearColor
function UUMGStyle_C:GetBackgroundColor(__WorldContext, Color) end


