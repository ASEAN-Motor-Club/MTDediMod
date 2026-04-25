# UE4SS Widget Manipulation

## How to block/hide/remove a game UI widget

### Preferred approach: NotifyOnNewObject + RemoveFromParent

The most reliable way to intercept a game widget is `NotifyOnNewObject` with the full UE asset path, then call `RemoveFromParent` in the game thread.

```lua
local WIDGET_FULL_PATH = "/Game/UI/InGame/Vehicle/W_RoadSideService.W_RoadSideService_C"

NotifyOnNewObject(WIDGET_FULL_PATH, function(widget)
    ExecuteInGameThread(function()
        if widget:IsValid() then
            widget:RemoveFromParent()
        end
    end)
end)
```

Optionally also catch already-existing instances with `FindFirstOf`:

```lua
local existing = FindFirstOf("W_RoadSideService_C")
if existing and existing:IsValid() then
    existing:RemoveFromParent()
end
```

### Key learnings

1. **`NotifyOnNewObject` requires the full UE asset path**, not the short class name.
   - Correct: `"/Game/UI/InGame/Vehicle/W_RoadSideService.W_RoadSideService_C"`
   - Wrong: `"W_RoadSideService_C"`
   - The function is `NotifyOnNewObject`, **not** `RegisterNotifyOnNewObject`.

2. **`FindFirstOf` requires only the short class name** (without path).
   - Correct: `"W_RoadSideService_C"`
   - Wrong: `"/Game/UI/InGame/Vehicle/W_RoadSideService.W_RoadSideService_C"`

3. **`RegisterHook` on `AddToViewport` does NOT fire for HUD-managed widgets.**
   - Motor Town pushes widgets via `AMTHUD:PushFullScreenMenuWidget`, which adds them to the HUD's internal widget tree rather than calling `AddToViewport` directly.
   - Even hooking `PushFullScreenMenuWidget` directly didn't fire — the game may use a Blueprint-level path that bypasses the native UFunction.

4. **`StaticFindObject` may fail to find WidgetBlueprintGeneratedClass objects.**
   - Using `widget:GetClass():GetName()` for class comparison works, but `StaticFindObject` with the full path can return nil for BP widget classes.
   - `IsA(string)` with a full class name works as an alternative: `widget:IsA("/Script/MotorTown.RoadsideServiceWidget")`

5. **Always wrap removal in `ExecuteInGameThread`.**
   - Widget operations must happen on the game thread. `NotifyOnNewObject` callbacks may not run on the game thread.

6. **Always check `IsValid()` before operating on a widget.**
   - Between the callback firing and `ExecuteInGameThread` executing, the widget may be garbage-collected or destroyed.

## Finding widget class info

Widget type definitions are in `client-types/`. The base C++ class is defined in `client-types/MotorTown.lua`, and the BP-generated subclass in a separate file (e.g., `client-types/W_RoadSideService.lua`).

For `URoadsideServiceWidget` (MotorTown.lua:12192):
- `RefuelingButton` — UMTButtonWidget
- `TowToRoadButton` — UMTButtonWidget
- `TowToGarageButton` — UMTButtonWidget
- `ButtonsBox` — UWidget (parent panel for all buttons)
- `TowLocationButtonsBox` — UVerticalBox

To selectively hide individual buttons instead of removing the entire widget:

```lua
NotifyOnNewObject(WIDGET_FULL_PATH, function(widget)
    ExecuteInGameThread(function()
        if widget:IsValid() then
            widget.TowToGarageButton:SetVisibility(1) -- VIS_COLLAPSED
            widget.TowToRoadButton:SetVisibility(1)
        end
    end)
end)
```

UE visibility values (correct enum order):
- `0 = Visible`
- `1 = Collapsed`
- `2 = Hidden`
- `3 = HitTestInvisible`
- `4 = SelfHitTestInvisible`

> **Important**: `Visible (0)` allows the widget and its children to receive input. `SelfHitTestInvisible (4)` renders the widget but blocks it from receiving input — useful when you want children (like text) to handle clicks instead.

## Creating UMG widgets at runtime

Use `StaticConstructObject` with the widget class path and parent:

```lua
local btn = StaticConstructObject(
    StaticFindObject("/Script/UMG.Button"),
    parentWidget, FName("MyButton"))
```

### USizeBox for fixed-width modals

```lua
local sizeBox = StaticConstructObject(
    StaticFindObject("/Script/UMG.SizeBox"),
    canvas, FName("ModalSizeBox"))
sizeBox:SetWidthOverride(360)
```

Attach the `SizeBox` to the canvas (not the inner widget), then toggle `sizeBox` visibility.

### HorizontalBoxSlot:SetSize requires FSlateChildSize struct

Pass a table, not a raw number:

```lua
-- Wrong: spacerSlot:SetSize(1)
-- Correct:
spacerSlot:SetSize({SizeRule = 1, Value = 1.0}) -- SizeRule 1 = Fill
```

### Canvas positioning

```lua
local canvasSlot = rootCanvas:AddChildToCanvas(sizeBox)
canvasSlot:SetAnchors({
    Minimum = {X=0.5, Y=0.75},
    Maximum = {X=0.5, Y=0.75}
})
canvasSlot:SetAlignment({X=0.5, Y=1}) -- pivot at bottom-center
canvasSlot:SetAutoSize(true)
```

## Input handling without delegates

UE4SS delegate binding (`OnClicked:Add`) crashes. Use `LoopInGameThreadWithDelay` with `IsPressed()` polling instead:

```lua
local pollHandle = LoopInGameThreadWithDelay(100, function()
    if btn:IsPressed() then
        -- handle click
    end
end)
```

Stop polling properly with `CancelDelayedAction`:

```lua
CancelDelayedAction(pollHandle)
pollHandle = nil
```

> **Lua order matters**: `local function` must be declared **before** it is called. If `Show()` calls `StartPolling()`, define `StartPolling()` above `Show()`.

## Fetching external APIs

Use the custom `fetch` library (provided as `fetch/core.dll` + `fetch/init.lua`):

```lua
local fetch = require("fetch.init")
local data, err = fetch.get("https://api.example.com/data")
if data then
    -- data is already parsed JSON
end
```

## UE4SS API reference

- Docs: https://docs.ue4ss.com/dev/lua-api.html
- `NotifyOnNewObject(string FullUClassName, function Callback)` — fires when any instance of the class (or subclass) is constructed
- `FindFirstOf(string ShortClassName)` — finds first live instance
- `FindAllOf(string ShortClassName)` — finds all live instances
- `RegisterHook(string UFunctionName, function Callback)` — hooks a UFunction; callback params are `(Context, Params...)`
- `ExecuteInGameThread(function)` — queues execution on the game thread
- `LoopInGameThreadWithDelay(integer DelayMs, function Callback)` — polls repeatedly; return `handle` for `CancelDelayedAction`
- `CancelDelayedAction(handle)` — stops a delayed/polling action
- `LoopAsync(integer DelayMs, function Callback)` — polls until callback returns `true`
