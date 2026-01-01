---@meta

---@class UColorWheelHelper : UBlueprintFunctionLibrary
local UColorWheelHelper = {}

---@param RandomAlpha boolean
---@param TrueRandom boolean
---@return FLinearColor
function UColorWheelHelper:RandomLinearColor(RandomAlpha, TrueRandom) end
---@param RandomAlpha boolean
---@param TrueRandom boolean
---@return FColor
function UColorWheelHelper:RandomColor(RandomAlpha, TrueRandom) end
---@param Color FLinearColor
---@param IsSRGB boolean
---@return FString
function UColorWheelHelper:LinearColorToHex(Color, IsSRGB) end
---@param Hex FString
---@return FLinearColor
function UColorWheelHelper:HexToLinearColor(Hex) end
---@param Hex FString
---@return FColor
function UColorWheelHelper:HexToColor(Hex) end
---@param Hex FString
---@return uint8
function UColorWheelHelper:HexToByte(Hex) end
---@return FLinearColor
function UColorWheelHelper:GetColorUnderCursor() end
---@param Color FColor
---@return FString
function UColorWheelHelper:ColorToHex(Color) end
---@param Byte uint8
---@return FString
function UColorWheelHelper:ByteToHex(Byte) end


---@class UColorWidget : UWidget
---@field SelectorPin FSlateBrush
---@field HueCircle FSlateBrush
---@field OnColorChanged FColorWidgetOnColorChanged
---@field OnMouseDown FColorWidgetOnMouseDown
---@field OnMouseUp FColorWidgetOnMouseUp
local UColorWidget = {}

---@param InColorAndOpacity FLinearColor
---@param Target EWheelBrushTarget
function UColorWidget:SetColorAndOpacity(InColorAndOpacity, Target) end
---@param NewColor FLinearColor
function UColorWidget:SetColor(NewColor) end
---@return FLinearColor
function UColorWidget:GetCurrentColor() end


