---Shortcuts module: configurable keybinds for common actions
---Reads shortcut config from ModConfig and registers keyboard/gamepad binds

local config = require("ModConfig")
local UEHelpers = require("UEHelpers")
local teleportManager = require("TeleportManager")
local vehicleManager = require("VehicleManager")

--- Minimum interval between shortcut triggers (ms)
local DEBOUNCE_MS = 1000
local lastTriggerTime = 0
local lastDespawnTime = 0
local lastImpulseTime = 0
local lastDespawnDialogTime = 0
local despawnDialogOpen = false

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

        -- If we hit a vehicle, find the nearest door to the impact point and open it
        local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
        if vehicleClass:IsValid() and actor:IsA(vehicleClass) then
            ---@cast actor AMTVehicle
            local doors = actor.Doors
            if doors:IsValid() and #doors > 0 then
                local impactPoint = hitResult.ImpactPoint
                local bestDoor = nil
                local bestDistSq = math.huge

                for i = 1, #doors do
                    local door = doors[i]
                    if door:IsValid() then
                        local doorLoc = door:K2_GetComponentLocation()
                        local dx = doorLoc.X - impactPoint.X
                        local dy = doorLoc.Y - impactPoint.Y
                        local dz = doorLoc.Z - impactPoint.Z
                        local distSq = dx * dx + dy * dy + dz * dz
                        if distSq < bestDistSq then
                            bestDistSq = distSq
                            bestDoor = door
                        end
                    end
                end

                if bestDoor then
                    PC:ServerToggleDoor(bestDoor)
                    LogOutput("INFO", "Despawn shortcut: Toggled door %s (dist=%.0f)",
                        bestDoor:GetFullName(), math.sqrt(bestDistSq))
                    return
                end
            end
        end

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


---Despawn selection dialog: opens a ButtonsDialog with three choices
---Ctrl+Shift+D → modal widget (Current / All / Others)
local function TriggerDespawnDialog()
    local now = os.clock() * 1000
    if now - lastDespawnDialogTime < DEBOUNCE_MS then
        return
    end
    if despawnDialogOpen then
        return
    end
    lastDespawnDialogTime = now
    despawnDialogOpen = true

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then
            LogOutput("WARN", "DespawnDialog: PlayerController not valid")
            despawnDialogOpen = false
            return
        end

        ---@cast PC AMotorTownPlayerController
        local HUD = PC.MyHUD
        if not HUD:IsValid() then
            LogOutput("WARN", "DespawnDialog: HUD not valid")
            despawnDialogOpen = false
            return
        end

        ---@cast HUD AMTHUD
        local widgetClass = HUD.ButtonsDialogueWidgetClass
        if not widgetClass:IsValid() then
            LogOutput("WARN", "DespawnDialog: ButtonsDialogueWidgetClass not valid")
            despawnDialogOpen = false
            return
        end

        local widget = HUD:PushFullScreenMenuWidget(widgetClass, false)
        if not widget:IsValid() then
            LogOutput("WARN", "DespawnDialog: Failed to create ButtonsDialogWidget")
            despawnDialogOpen = false
            return
        end

        ---@cast widget UButtonsDialogWidget

        -- Label the title via the inner popup template, if present
        local popupTemplate = widget.W_Template_PopupWindow
        if popupTemplate and popupTemplate:IsValid() then
            popupTemplate['Set New Title Text'](popupTemplate, FText("Despawn Vehicles"))
        end

        -- Wire each button in order: [1]=Current, [2]=All, [3]=Others
        -- ButtonsVerticalBox contains UMTButtonWidget children added by the game.
        -- We hook OnMenuButtonClickedEvent on each child by index.
        local HOOKS = {
            {
                label = "Despawn Current",
                action = function()
                    local count = vehicleManager.DespawnPlayerVehicle(PC)
                    if count > 0 then
                        LogOutput("INFO", "DespawnDialog: Despawned %d vehicle(s)", count)
                    else
                        LogOutput("INFO", "DespawnDialog: No current vehicle to despawn")
                    end
                end
            },
            {
                label = "Despawn All",
                action = function()
                    local count = vehicleManager.DespawnAllPlayerVehicles(PC)
                    if count > 0 then
                        LogOutput("INFO", "DespawnDialog: Despawned all %d vehicle(s)", count)
                    else
                        LogOutput("INFO", "DespawnDialog: No vehicles to despawn")
                    end
                end
            },
            {
                label = "Despawn Others",
                action = function()
                    local count = vehicleManager.DespawnOtherPlayerVehicles(PC)
                    if count > 0 then
                        LogOutput("INFO", "DespawnDialog: Despawned %d other vehicle(s)", count)
                    else
                        LogOutput("INFO", "DespawnDialog: No other vehicles to despawn")
                    end
                end
            },
        }

        -- Hook each button's click event. ButtonsVerticalBox children are the
        -- MT button widgets added by the Blueprint at construction time.
        local buttonBox = widget.ButtonsVerticalBox
        if not buttonBox:IsValid() then
            LogOutput("WARN", "DespawnDialog: ButtonsVerticalBox not valid")
            HUD:PopFullScreenMenuWidget(widget)
            despawnDialogOpen = false
            return
        end

        for i, entry in ipairs(HOOKS) do
            -- GetChildAt is 0-indexed in UMG
            local btn = buttonBox:GetChildAt(i - 1)
            if btn and btn:IsValid() then
                -- Set the display label via the NameTextBlock on UMTButtonWidget
                local nameBlock = btn.NameTextBlock
                if nameBlock and nameBlock:IsValid() then
                    nameBlock:SetText(FText(entry.label))
                end

                -- Capture loop index in closure
                local capturedAction = entry.action
                RegisterHook("/Script/MotorTown.MTButtonWidget:OnButtonClicked",
                    function(Context)
                        if not widget:IsValid() then return end
                        if Context:get() ~= btn then return end
                        capturedAction()
                        HUD:PopFullScreenMenuWidget(widget)
                        despawnDialogOpen = false
                    end)
            else
                LogOutput("WARN", "DespawnDialog: Button %d not found in ButtonsVerticalBox", i)
            end
        end

        LogOutput("INFO", "DespawnDialog: Opened (Current / All / Others)")
    end)
end


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

--- Construct an FKey struct from a UE key name string (e.g. "Gamepad_RightShoulder")
---@param keyName string UE key name
---@return table FKey-compatible struct
local function MakeFKey(keyName)
    return { KeyName = FName(keyName) }
end

--- Register gamepad shortcut from config using IsInputKeyDown polling
local function RegisterGamepadShortcut()
    local shortcuts = config.GetModConfig("shortcuts")
    if not shortcuts or not shortcuts.arrest or not shortcuts.arrest.gamepad then
        LogOutput("INFO", "No gamepad shortcut config for arrest")
        return
    end

    local gp = shortcuts.arrest.gamepad
    if not gp.buttons or #gp.buttons == 0 then
        LogOutput("WARN", "No gamepad buttons configured for arrest")
        return
    end

    -- Pre-build FKey structs for each configured button
    local fkeys = {}
    for _, btnName in ipairs(gp.buttons) do
        table.insert(fkeys, MakeFKey(btnName))
    end

    -- Track whether combo was active last tick to prevent repeat-fire while held
    local wasActive = false

    -- Poll every 100ms on the game thread
    LoopInGameThreadWithDelay(100, function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then return end

        local allDown = true
        for _, fkey in ipairs(fkeys) do
            if not PC:IsInputKeyDown(fkey) then
                allDown = false
                break
            end
        end

        if allDown and not wasActive then
            wasActive = true
            TriggerArrest()
        elseif not allDown then
            wasActive = false
        end
    end)

    LogOutput("INFO", "Arrest gamepad shortcut registered (polling): %s",
        table.concat(gp.buttons, "+"))
end


---Open a text input dialog for teleport location, then teleport on submit
local lastTeleportDialogTime = 0
local teleportDialogOpen = false

local function TriggerTeleportDialog()
    local now = os.clock() * 1000
    if now - lastTeleportDialogTime < DEBOUNCE_MS then
        return
    end
    if teleportDialogOpen then
        return
    end
    lastTeleportDialogTime = now
    teleportDialogOpen = true

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then
            LogOutput("WARN", "Teleport dialog: PlayerController not valid")
            teleportDialogOpen = false
            return
        end

        local HUD = PC.MyHUD
        if not HUD:IsValid() then
            LogOutput("WARN", "Teleport dialog: HUD not valid")
            teleportDialogOpen = false
            return
        end

        ---@cast HUD AMTHUD
        local widgetClass = HUD.EditableTextDialogPopupWidgetClass
        if not widgetClass:IsValid() then
            LogOutput("WARN", "Teleport dialog: EditableTextDialogPopupWidgetClass not valid")
            teleportDialogOpen = false
            return
        end

        local widget = HUD:PushFullScreenMenuWidget(widgetClass, false)
        if not widget:IsValid() then
            LogOutput("WARN", "Teleport dialog: Failed to create widget")
            teleportDialogOpen = false
            return
        end

        ---@cast widget UEditableTextDialogPopupWidget
        widget:ReceiveSetTitle(FText("Teleport — enter location name"))

        -- Hook text commit to handle the teleport
        RegisterHook("/Script/MotorTown.EditableTextDialogPopupWidget:HandleTextBoxCommitted",
            function(Context, Text, CommitMethod)
                -- Only handle our dialog instance
                if not widget:IsValid() then return end
                if Context:get() ~= widget then return end

                local locationName = Text:get():ToString()

                -- Clean up: pop from HUD stack (restores input mode)
                HUD:PopFullScreenMenuWidget(widget)
                teleportDialogOpen = false

                if locationName == "" then
                    LogOutput("INFO", "Teleport dialog: cancelled (empty input)")
                    return
                end

                -- Parse into args the same way Commands.lua does
                local args = SplitString(locationName, " ") or {}
                local myPC = GetMyPlayerController()
                if myPC:IsValid() then
                    teleportManager.HandleTeleport(myPC, args)
                end
            end)

        LogOutput("INFO", "Teleport dialog opened")
    end)
end


-- Initialize shortcuts
RegisterKeyboardShortcut()
RegisterGamepadShortcut()
RegisterKeyBind(Key.X, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDespawnAimed)
RegisterKeyBind(Key.RIGHT_MOUSE_BUTTON, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDespawnAimed)
RegisterKeyBind(Key.I, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerImpulseAimed)
RegisterKeyBind(Key.LEFT_MOUSE_BUTTON, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerImpulseAimed)
RegisterKeyBind(Key.T, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerTeleportDialog)
RegisterKeyBind(Key.D, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDespawnDialog)

return {}
