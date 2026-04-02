---Shortcuts module: configurable keybinds for common actions
---Reads shortcut config from ModConfig and registers keyboard/gamepad binds

local config = require("ModConfig")
local statics = require("Statics")
local vehicleManager = require("VehicleManager")

--- Minimum interval between shortcut triggers (ms)
local DEBOUNCE_MS = 1000
local lastTriggerTime = 0
local lastRaycastDespawnTriggerTime = 0

---Send the /arrest command via ServerSendChat
local function TriggerArrest()
    local now = os.clock() * 1000
    if now - lastTriggerTime < DEBOUNCE_MS then
        return
    end
    lastTriggerTime = now

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if PC:IsValid() then
            PC:ServerSendChat("/arrest", 0)
            LogOutput("INFO", "Arrest shortcut triggered")
        else
            LogOutput("WARN", "Arrest shortcut: PlayerController not valid")
        end
    end)
end

--- Register keyboard shortcut from config
local function RegisterKeyboardShortcut()
    local shortcuts = config.GetModConfig("shortcuts")
    if not shortcuts or not shortcuts.arrest or not shortcuts.arrest.keyboard then
        LogOutput("WARN", "No keyboard shortcut config for arrest")
        return
    end

    local kb = shortcuts.arrest.keyboard
    local keyCode = Key[kb.key]
    if not keyCode then
        LogOutput("ERROR", "Invalid shortcut key: %s", kb.key)
        return
    end

    local mods = {}
    if kb.modifiers then
        for _, m in ipairs(kb.modifiers) do
            if ModifierKey[m] then
                table.insert(mods, ModifierKey[m])
            else
                LogOutput("WARN", "Unknown modifier key: %s", m)
            end
        end
    end

    RegisterKeyBind(keyCode, mods, TriggerArrest)
    LogOutput("INFO", "Arrest keyboard shortcut registered: %s + %s",
        table.concat(kb.modifiers or {}, "+"), kb.key)
end

--- Register gamepad shortcut from config using InputKey hook
local function RegisterGamepadShortcut()
    local shortcuts = config.GetModConfig("shortcuts")
    if not shortcuts or not shortcuts.arrest or not shortcuts.arrest.gamepad then
        LogOutput("WARN", "No gamepad shortcut config for arrest")
        return
    end

    local gp = shortcuts.arrest.gamepad
    if not gp.buttons or #gp.buttons == 0 then
        LogOutput("WARN", "No gamepad buttons configured for arrest")
        return
    end

    -- Track held gamepad buttons
    local heldButtons = {}

    -- Try to hook the engine InputKey to capture gamepad events
    local hookSuccess, hookErr = pcall(function()
        RegisterHook("/Script/Engine.PlayerController:InputKey", function(Context, Params)
            local ok, err = pcall(function()
                -- Params.Key is an FKey, Params.Event is EInputEvent
                local keyName = Params:get().Key.KeyName:ToString()
                local eventType = Params:get().Event

                -- Only process gamepad keys
                if not keyName:find("Gamepad_") then return end

                -- IE_Pressed = 0, IE_Released = 1
                if eventType == 0 then
                    heldButtons[keyName] = true
                elseif eventType == 1 then
                    heldButtons[keyName] = false
                end

                -- Check if all configured buttons are pressed
                local allPressed = true
                for _, btn in ipairs(gp.buttons) do
                    if not heldButtons[btn] then
                        allPressed = false
                        break
                    end
                end

                if allPressed then
                    -- Reset to prevent repeat-fire while held
                    for _, btn in ipairs(gp.buttons) do
                        heldButtons[btn] = false
                    end
                    TriggerArrest()
                end
            end)
            if not ok then
                LogOutput("ERROR", "Gamepad hook error: %s", tostring(err))
            end
        end)
    end)

    if hookSuccess then
        LogOutput("INFO", "Arrest gamepad shortcut registered: %s",
            table.concat(gp.buttons, "+"))
    else
        LogOutput("WARN", "Failed to register gamepad hook (InputKey not available): %s",
            tostring(hookErr))
    end
end

---Trigger raycast despawn via VehicleManager
local function TriggerRaycastDespawn()
    local now = os.clock() * 1000
    if now - lastRaycastDespawnTriggerTime < DEBOUNCE_MS then
        return
    end
    lastRaycastDespawnTriggerTime = now

    ExecuteInGameThread(function()
        vehicleManager.RaycastDespawnVehicle()
    end)
end

---Register the raycast despawn keyboard shortcut
local function RegisterRaycastDespawnShortcut()
    local shortcuts = config.GetModConfig("shortcuts")
    if not shortcuts or not shortcuts.raycast_despawn or not shortcuts.raycast_despawn.keyboard then
        LogOutput("WARN", "No keyboard shortcut config for raycast_despawn")
        return
    end

    local kb = shortcuts.raycast_despawn.keyboard
    local keyCode = Key[kb.key]
    if not keyCode then
        LogOutput("ERROR", "Invalid shortcut key: %s", kb.key)
        return
    end

    local mods = {}
    if kb.modifiers then
        for _, m in ipairs(kb.modifiers) do
            if ModifierKey[m] then
                table.insert(mods, ModifierKey[m])
            else
                LogOutput("WARN", "Unknown modifier key: %s", m)
            end
        end
    end

    RegisterKeyBind(keyCode, mods, TriggerRaycastDespawn)
    LogOutput("INFO", "Raycast despawn keyboard shortcut registered: %s + %s",
        table.concat(kb.modifiers or {}, "+"), kb.key)
end

---Reload the mod via UE4SS hot reload
local function RegisterReloadModShortcut()
    RegisterKeyBind(Key.R, { ModifierKey.CONTROL, ModifierKey.SHIFT }, function()
        LogOutput("INFO", "Reloading mod: %s", statics.ModName)
        ReloadMod(statics.ModName)
    end)
    LogOutput("INFO", "Reload mod shortcut registered: Ctrl+Shift+R")
end

-- Initialize shortcuts
RegisterKeyboardShortcut()
RegisterGamepadShortcut()
RegisterRaycastDespawnShortcut()
RegisterReloadModShortcut()

return {}
