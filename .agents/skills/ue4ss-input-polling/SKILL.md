# UE4SS Input Polling

## Why not delegates?

UE4SS delegate binding (`OnClicked:Add`, `OnPressed:Add`, etc.) frequently crashes. Instead, use polling with `LoopInGameThreadWithDelay` and `IsPressed()`.

## Basic polling loop

```lua
local pollHandle = nil

local function StartPolling()
    if pollHandle then return end
    
    pollHandle = LoopInGameThreadWithDelay(100, function()
        if btn:IsPressed() then
            -- Handle click
        end
    end)
end
```

## Stopping polling

Always use `CancelDelayedAction` to stop:

```lua
local function StopPolling()
    CancelDelayedAction(pollHandle)
    pollHandle = nil
end
```

> **Critical**: Setting `pollHandle = nil` without `CancelDelayedAction` leaks the polling callback — it keeps running until game restart.

## Debouncing

Prevent multiple triggers from a single press:

```lua
local DEBOUNCE_MS = 150
local lastPressed = {}

local now = os.clock() * 1000
local last = lastPressed[btn] or 0

if now - last > DEBOUNCE_MS then
    lastPressed[btn] = now
    -- Handle click
end
```

## Checking button visibility

Only poll buttons that are currently visible:

```lua
-- ESlateVisibility: 0=Visible, 1=Collapsed, 2=Hidden
if btn and btn:IsValid() and btn:GetVisibility() == 0 then
    if btn:IsPressed() then
        -- Handle click
    end
end
```

## Multiple buttons

```lua
local buttons = {btn1, btn2, btn3}

for i, btn in ipairs(buttons) do
    if btn:IsValid() and btn:GetVisibility() == 0 then
        if btn:IsPressed() then
            HandleButtonClick(i)
        end
    end
end
```

## Lifecycle: start on show, stop on hide

```lua
local function Show()
    widget:SetVisibility(0) -- Visible
    isVisible = true
    StartPolling()
end

local function Hide()
    widget:SetVisibility(1) -- Collapsed
    isVisible = false
    StopPolling()
end
```

> **Lua order matters**: `StartPolling()` and `StopPolling()` must be declared **before** `Show()` and `Hide()` because Lua resolves local functions at parse time, not runtime.

## Keybinds

```lua
-- Open on TAB
RegisterKeyBind(Key.TAB, {}, function()
    ExecuteInGameThread(function()
        Show()
    end)
end)

-- Close on ESC
RegisterKeyBind(Key.ESCAPE, {}, function()
    ExecuteInGameThread(function()
        if isVisible then Hide() end
    end)
end)
```

## Checking visibility in poll loop

```lua
pollHandle = LoopInGameThreadWithDelay(100, function()
    if not isVisible then return end  -- Skip if hidden
    -- Check buttons...
end)
```

## Complete example

```lua
local pollHandle = nil
local lastPressed = {}
local DEBOUNCE_MS = 150

local function StartPolling()
    if pollHandle then return end
    
    pollHandle = LoopInGameThreadWithDelay(100, function()
        if not isVisible then return end
        
        local now = os.clock() * 1000
        
        for i, entry in ipairs(itemButtons) do
            local btn = entry.button
            if btn:IsValid() and btn:GetVisibility() == 0 then
                if btn:IsPressed() then
                    local last = lastPressed[btn] or 0
                    if now - last > DEBOUNCE_MS then
                        lastPressed[btn] = now
                        DoAction(i)
                    end
                end
            end
        end
    end)
end

local function StopPolling()
    CancelDelayedAction(pollHandle)
    pollHandle = nil
end

local function Show()
    widget:SetVisibility(0)
    isVisible = true
    StartPolling()
end

local function Hide()
    widget:SetVisibility(1)
    isVisible = false
    StopPolling()
end
```
