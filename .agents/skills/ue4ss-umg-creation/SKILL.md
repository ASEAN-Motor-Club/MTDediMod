# UE4SS UMG Widget Creation

## Creating widgets at runtime with StaticConstructObject

```lua
local btn = StaticConstructObject(
    StaticFindObject("/Script/UMG.Button"),
    parentWidget, FName("MyButton"))
```

### Common widget class paths

| Widget | Path |
|--------|------|
| Button | `/Script/UMG.Button` |
| TextBlock | `/Script/UMG.TextBlock` |
| Border | `/Script/UMG.Border` |
| VerticalBox | `/Script/UMG.VerticalBox` |
| HorizontalBox | `/Script/UMG.HorizontalBox` |
| SizeBox | `/Script/UMG.SizeBox` |
| Spacer | `/Script/UMG.Spacer` |
| CanvasPanel | `/Script/UMG.CanvasPanel` |

## USizeBox for fixed-width modals

```lua
local sizeBox = StaticConstructObject(
    StaticFindObject("/Script/UMG.SizeBox"),
    canvas, FName("ModalSizeBox"))
sizeBox:SetWidthOverride(360)

-- Attach inner widget to sizeBox, toggle sizeBox visibility
sizeBox:SetVisibility(0) -- Visible
sizeBox:SetVisibility(1) -- Collapsed
```

## Adding children to containers

### VerticalBox

```lua
local slot = vbox:AddChildToVerticalBox(childWidget)
slot:SetPadding({Top=2, Bottom=2})
```

### HorizontalBox

```lua
local slot = hbox:AddChildToHorizontalBox(childWidget)
slot:SetPadding({Right=8})

-- Spacer with Fill
local spacerSlot = hbox:AddChildToHorizontalBox(spacer)
spacerSlot:SetSize({SizeRule = 1, Value = 1.0}) -- Fill
```

### CanvasPanel

```lua
local canvasSlot = canvas:AddChildToCanvas(widget)
canvasSlot:SetAnchors({
    Minimum = {X=0.5, Y=0.75},
    Maximum = {X=0.5, Y=0.75}
})
canvasSlot:SetAlignment({X=0.5, Y=1})
canvasSlot:SetAutoSize(true)
```

## Setting widget content

```lua
-- Button with text
local btnText = StaticConstructObject(
    StaticFindObject("/Script/UMG.TextBlock"),
    btn, FName("BtnText"))
btnText:SetText(FText("Click Me"))
btn:SetContent(btnText)

-- Border with vertical box
local vbox = StaticConstructObject(
    StaticFindObject("/Script/UMG.VerticalBox"),
    border, FName("ContentVBox"))
border:SetContent(vbox)
```

## Styling

```lua
-- Colors
widget:SetBrushColor({R=0.06, G=0.06, B=0.1, A=0.92})
widget:SetBackgroundColor({R=0.12, G=0.14, B=0.18, A=0.7})

-- Padding
widget:SetPadding({Left=20, Top=12, Right=20, Bottom=12})

-- Text
local textColor = {SpecifiedColor={R=0.9, G=0.9, B=0.9, A=1}, ColorUseRule=0}
textBlock:SetColorAndOpacity(textColor)
textBlock.Font.Size = 13
```

## ESlateVisibility enum

| Value | Name | Behavior |
|-------|------|----------|
| 0 | Visible | Renders and receives input |
| 1 | Collapsed | Hidden, takes no space |
| 2 | Hidden | Hidden but takes space |
| 3 | HitTestInvisible | Renders but invisible to hit tests |
| 4 | SelfHitTestInvisible | Renders but self is invisible to hit tests (children can receive input) |

> **Important**: When a button only registers clicks on its text, not the full button area, check visibility mode. `Visible (0)` allows the widget and children to receive input. `SelfHitTestInvisible (4)` renders the widget background but blocks it from receiving input — children (like text) handle clicks instead.

## Attaching to HUD

```lua
local PC = GetMyPlayerController()
local HUD = PC:GetHUD()
local hudClass = StaticFindObject("/Script/MotorTown.MotorTownInGameHUD")

if HUD and HUD:IsValid() and HUD:IsA(hudClass) then
    local rootCanvas = HUD.HUDWidget.RootCanvasPanel
    local canvasSlot = rootCanvas:AddChildToCanvas(sizeBox)
    -- position...
end
```

## Always check IsValid()

```lua
if widget and widget:IsValid() then
    widget:DoSomething()
end
```
