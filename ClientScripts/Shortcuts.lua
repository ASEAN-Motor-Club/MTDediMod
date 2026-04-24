---Shortcuts module: configurable keybinds for common actions
---Reads shortcut config from ModConfig and registers keyboard/gamepad binds

local config = require("ModConfig")
local UEHelpers = require("UEHelpers")
local teleportManager = require("TeleportManager")
local vehicleManager = require("VehicleManager")
local json = require("JsonParser")
local http = require("socket.http")
local ltn12 = require("ltn12")

--- Minimum interval between shortcut triggers (ms)
local DEBOUNCE_MS = 1000
local lastDespawnTime = 0
local lastImpulseTime = 0
local lastDespawnDialogTime = 0
local lastDoorToggleTime = 0
local despawnDialogOpen = false

--- Impulse strength for the aimed impulse shortcut
local IMPULSE_STRENGTH = 100000.0

---Check whether the local player has admin privileges
---@return boolean
local function IsAdmin()
    local PC = GetMyPlayerController()
    if not PC:IsValid() then return false end
    local PS = PC.PlayerState
    if not PS:IsValid() then return false end
    return PS.bIsAdmin == true
end

local lastGhostTime = 0
local lastGodTime = 0
local lastHideCostumeTime = 0
local lastInvisibleTime = 0

---Get local player's character GUID string
---@return string? guid
local function GetMyCharacterGuid()
    local PC = GetMyPlayerController()
    if not PC:IsValid() then return nil end
    local PS = PC.PlayerState
    if not PS:IsValid() then return nil end
    local guid = GuidToString(PS.CharacterGuid)
    if not guid or guid == "0000" then return nil end
    return guid
end

---Send a JSON POST request to the mod server API
---@param endpoint string e.g. "/players/{guid}/experimental/ghost"
---@param payload table
local function ModApiPost(endpoint, payload)
    local apiUrl = config.GetModConfig("modApiUrl")
    if not apiUrl then
        LogOutput("WARN", "ModApiPost: modApiUrl not configured")
        return
    end
    local url = apiUrl .. endpoint
    local body = json.stringify(payload)
    local res = {}
    local ok, code = pcall(http.request, {
        url = url,
        method = "POST",
        headers = { ["Content-Type"] = "application/json", ["Content-Length"] = #body },
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(res),
    })
    if ok then
        LogOutput("INFO", "ModApiPost %s -> %s", endpoint, tostring(code))
    else
        LogOutput("WARN", "ModApiPost %s failed: %s", endpoint, tostring(code))
    end
end

---Toggle the nearest door on the vehicle the player is aiming at
local function TriggerDoorToggle()
    if not IsAdmin() then
        LogOutput("WARN", "Door toggle shortcut: Admin only")
        return
    end

    local now = os.clock() * 1000
    if now - lastDoorToggleTime < DEBOUNCE_MS then
        return
    end
    lastDoorToggleTime = now

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then
            LogOutput("WARN", "Door toggle shortcut: PlayerController not valid")
            return
        end

        local wasHit, hitResult = GetHitResultFromCenterLineTrace()
        if not wasHit then
            LogOutput("INFO", "Door toggle shortcut: Nothing aimed at")
            return
        end

        local actor = GetActorFromHitResult(hitResult)
        if not actor:IsValid() then
            LogOutput("INFO", "Door toggle shortcut: Invalid aimed actor")
            return
        end

        local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
        if not vehicleClass:IsValid() or not actor:IsA(vehicleClass) then
            LogOutput("INFO", "Door toggle shortcut: Aimed actor is not a vehicle")
            return
        end

        ---@cast actor AMTVehicle
        local doors = actor.Doors
        if not doors:IsValid() or #doors == 0 then
            LogOutput("INFO", "Door toggle shortcut: Vehicle has no doors")
            return
        end

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
            LogOutput("INFO", "Door toggle shortcut: Toggled door %s (dist=%.0f)",
                bestDoor:GetFullName(), math.sqrt(bestDistSq))
        end
    end)
end

---Toggle ghost mode via server API (replicated to all clients)
local function TriggerGhostToggle()
    if not IsAdmin() then
        LogOutput("WARN", "Ghost toggle shortcut: Admin only")
        return
    end

    local now = os.clock() * 1000
    if now - lastGhostTime < DEBOUNCE_MS then
        return
    end
    lastGhostTime = now

    local guid = GetMyCharacterGuid()
    if not guid then
        LogOutput("WARN", "Ghost toggle shortcut: Could not get character GUID")
        return
    end

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then return end
        local pawn = PC:K2_GetPawn()
        if not pawn:IsValid() then return end

        local charClass = StaticFindObject("/Script/MotorTown.MTCharacter")
        if not charClass:IsValid() or not pawn:IsA(charClass) then return end

        ---@cast pawn AMTCharacter
        local ghostOn = (pawn.Net_CharacterFlags & 4) == 0
        ModApiPost("/players/" .. guid .. "/experimental/ghost", { ghost = ghostOn })
        LogOutput("INFO", "Ghost toggle shortcut: ghost=%s (server-side)", tostring(ghostOn))
    end)
end

---Toggle god mode via bCanBeDamaged
local function TriggerGodToggle()
    if not IsAdmin() then
        LogOutput("WARN", "God toggle shortcut: Admin only")
        return
    end

    local now = os.clock() * 1000
    if now - lastGodTime < DEBOUNCE_MS then
        return
    end
    lastGodTime = now

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then
            LogOutput("WARN", "God toggle shortcut: PlayerController not valid")
            return
        end

        local pawn = PC:K2_GetPawn()
        if not pawn:IsValid() then
            LogOutput("WARN", "God toggle shortcut: Pawn not valid")
            return
        end

        if pawn.bCanBeDamaged then
            pawn.bCanBeDamaged = false
            LogOutput("INFO", "God toggle shortcut: God ON")
        else
            pawn.bCanBeDamaged = true
            LogOutput("INFO", "God toggle shortcut: God OFF")
        end
    end)
end

---Toggle HideCostume flag via server API (replicated to all clients)
local function TriggerHideCostume()
    if not IsAdmin() then
        LogOutput("WARN", "Hide costume shortcut: Admin only")
        return
    end

    local now = os.clock() * 1000
    if now - lastHideCostumeTime < DEBOUNCE_MS then
        return
    end
    lastHideCostumeTime = now

    local guid = GetMyCharacterGuid()
    if not guid then
        LogOutput("WARN", "Hide costume shortcut: Could not get character GUID")
        return
    end

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then return end
        local pawn = PC:K2_GetPawn()
        if not pawn:IsValid() then return end

        local charClass = StaticFindObject("/Script/MotorTown.MTCharacter")
        if not charClass:IsValid() or not pawn:IsA(charClass) then return end

        ---@cast pawn AMTCharacter
        local hideOn = (pawn.Net_CharacterFlags & 16) == 0
        ModApiPost("/players/" .. guid .. "/experimental/hide_costume", { hide_costume = hideOn })
        LogOutput("INFO", "Hide costume shortcut: hide_costume=%s (server-side)", tostring(hideOn))
    end)
end

---Toggle actor visibility via server API (replicated to all clients)
local function TriggerInvisibleToggle()
    if not IsAdmin() then
        LogOutput("WARN", "Invisible toggle shortcut: Admin only")
        return
    end

    local now = os.clock() * 1000
    if now - lastInvisibleTime < DEBOUNCE_MS then
        return
    end
    lastInvisibleTime = now

    local guid = GetMyCharacterGuid()
    if not guid then
        LogOutput("WARN", "Invisible toggle shortcut: Could not get character GUID")
        return
    end

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then return end
        local pawn = PC:K2_GetPawn()
        if not pawn:IsValid() then return end

        local hidden = not pawn.bHidden
        ModApiPost("/players/" .. guid .. "/experimental/hide_actor", { hidden = hidden })
        LogOutput("INFO", "Invisible toggle shortcut: hidden=%s (server-side)", tostring(hidden))
    end)
end

---Despawn the actor the player is aiming at (vehicle, cargo, or item)
local function TriggerDespawnAimed()
    if not IsAdmin() then
        LogOutput("WARN", "Despawn shortcut: Admin only")
        return
    end

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
        local cargoClass = StaticFindObject("/Script/MotorTown.MTCargo")
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
                PC:ServerTrashItem(actor)
                LogOutput("INFO", "Despawn shortcut: Trashed item %s", actor:GetFullName())
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
    if not IsAdmin() then
        LogOutput("WARN", "Impulse shortcut: Admin only")
        return
    end

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
RegisterKeyBind(Key.RIGHT_MOUSE_BUTTON, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDespawnAimed)
RegisterKeyBind(Key.I, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerImpulseAimed)
RegisterKeyBind(Key.LEFT_MOUSE_BUTTON, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerImpulseAimed)
RegisterKeyBind(Key.O, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDoorToggle)
RegisterKeyBind(Key.T, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerTeleportDialog)
RegisterKeyBind(Key.D, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDespawnDialog)
RegisterKeyBind(Key.G, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerGhostToggle)
RegisterKeyBind(Key.J, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerGodToggle)
RegisterKeyBind(Key.H, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerHideCostume)
RegisterKeyBind(Key.V, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerInvisibleToggle)

return {}
