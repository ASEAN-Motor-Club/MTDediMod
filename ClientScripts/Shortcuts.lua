---Shortcuts module: configurable keybinds for common actions
---Reads shortcut config from ModConfig and registers keyboard/gamepad binds

local config = require("ModConfig")
local UEHelpers = require("UEHelpers")

--- Minimum interval between shortcut triggers (ms)
local DEBOUNCE_MS = 1000
local lastTriggerTime = 0
local lastDespawnTime = 0
local lastImpulseTime = 0

--- Impulse strength for the aimed impulse shortcut
local IMPULSE_STRENGTH = 100000.0

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

---Despawn the actor the player is aiming at (vehicle, cargo, or item)
local function TriggerDespawnAimed()
    local now = os.clock() * 1000
    if now - lastDespawnTime < DEBOUNCE_MS then
        return
    end
    lastDespawnTime = now

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then
            LogOutput("WARN", "Despawn shortcut: PlayerController not valid")
            return
        end

        local wasHit, hitResult = GetHitResultFromCenterLineTrace()
        if not wasHit then
            LogOutput("INFO", "Despawn shortcut: Nothing aimed at")
            return
        end

        local actor = GetActorFromHitResult(hitResult)
        if not actor:IsValid() then
            LogOutput("INFO", "Despawn shortcut: Invalid aimed actor")
            return
        end

        local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
        local cargoClass = StaticFindObject("/Script/MotorTown.AMTCargo")
        local itemComponentClass = StaticFindObject("/Script/MotorTown.UMTItemComponent")

        if vehicleClass:IsValid() and actor:IsA(vehicleClass) then
            ---@cast actor AMTVehicle
            if not actor:IsActorBeingDestroyed() then
                PC:ServerDespawnVehicle(actor, 0)
                LogOutput("INFO", "Despawn shortcut: Despawned vehicle %s", actor:GetFullName())
            end
        elseif cargoClass:IsValid() and actor:IsA(cargoClass) then
            ---@cast actor AMTCargo
            if not actor:IsActorBeingDestroyed() then
                PC:ServerDespawnCargo(actor)
                LogOutput("INFO", "Despawn shortcut: Despawned cargo %s", actor:GetFullName())
            end
        elseif itemComponentClass:IsValid() then
            local itemComponent = actor:GetComponentByClass(itemComponentClass)
            if itemComponent:IsValid() and not actor:IsActorBeingDestroyed() then
                actor:K2_DestroyActor()
                LogOutput("INFO", "Despawn shortcut: Destroyed item %s", actor:GetFullName())
            else
                LogOutput("INFO", "Despawn shortcut: Aimed actor is not despawnable: %s", actor:GetFullName())
            end
        else
            LogOutput("INFO", "Despawn shortcut: Aimed actor is not despawnable: %s", actor:GetFullName())
        end
    end)
end

---[EXPERIMENTAL] Apply a physics impulse to the actor the player is aiming at.
---Uses the game's built-in ServerApplyImpact RPC which replicates automatically.
local function TriggerImpulseAimed()
    local now = os.clock() * 1000
    if now - lastImpulseTime < DEBOUNCE_MS then
        return
    end
    lastImpulseTime = now

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then
            LogOutput("WARN", "Impulse shortcut: PlayerController not valid")
            return
        end

        local wasHit, hitResult = GetHitResultFromCenterLineTrace()
        if not wasHit then
            LogOutput("INFO", "Impulse shortcut: Nothing aimed at")
            return
        end

        local actor = GetActorFromHitResult(hitResult)
        if not actor:IsValid() then
            LogOutput("INFO", "Impulse shortcut: Invalid aimed actor")
            return
        end

        local rootComponent = actor:K2_GetRootComponent()
        if not rootComponent:IsValid() then
            LogOutput("WARN", "Impulse shortcut: Actor has no root component: %s", actor:GetFullName())
            return
        end

        -- Verify root component is a PrimitiveComponent
        local primitiveClass = StaticFindObject("/Script/Engine.PrimitiveComponent")
        if not primitiveClass:IsValid() or not rootComponent:IsA(primitiveClass) then
            LogOutput("WARN", "Impulse shortcut: Root component is not a PrimitiveComponent: %s", actor:GetFullName())
            return
        end

        -- Compute impulse direction: 70% forward + 30% upward
        local KML = UEHelpers.GetKismetMathLibrary()
        local cameraManager = PC.PlayerCameraManager
        local forward = KML:GetForwardVector(cameraManager:GetCameraRotation())

        local impulse = {
            X = forward.X * IMPULSE_STRENGTH * 0.7,
            Y = forward.Y * IMPULSE_STRENGTH * 0.7,
            Z = (forward.Z * IMPULSE_STRENGTH * 0.7) + (IMPULSE_STRENGTH * 0.3)
        }

        -- Compute relative location (impact point relative to actor origin)
        local actorLocation = actor:K2_GetActorLocation()
        local relativeLocation = {
            X = hitResult.ImpactPoint.X - actorLocation.X,
            Y = hitResult.ImpactPoint.Y - actorLocation.Y,
            Z = hitResult.ImpactPoint.Z - actorLocation.Z,
        }

        ---@type FMTPhysicsImpact
        local impact = {
            Component = rootComponent,
            RelativeLocation = relativeLocation,
            Impulse = impulse,
        }

        PC:ServerApplyImpact(impact)
        LogOutput("INFO", "Impulse shortcut: ServerApplyImpact on %s", actor:GetFullName())
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

-- Initialize shortcuts
RegisterKeyboardShortcut()
RegisterGamepadShortcut()
RegisterKeyBind(Key.X, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDespawnAimed)
RegisterKeyBind(Key.I, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerImpulseAimed)

return {}
