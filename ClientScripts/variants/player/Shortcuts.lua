--- Player-build shortcuts: teleport dialog and vehicle quick-save only.
--- Admin actions live in the admin build's Shortcuts.lua; that file is not
--- copied into the player package by package-client.

local teleportManager = require("TeleportManager")
local vehicleSaveSpawn = require("VehicleSaveSpawn")

local DEBOUNCE_MS = 1000
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

RegisterKeyBind(Key.T, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerTeleportDialog)
RegisterKeyBind(Key.F5, { ModifierKey.CONTROL, ModifierKey.SHIFT }, function()
  local PC = GetMyPlayerController()
  if PC:IsValid() and PC.LastVehicle and PC.LastVehicle:IsValid() then
    vehicleSaveSpawn.SaveVehicle("quicksave", vehicleSaveSpawn.SerializeVehicle(PC.LastVehicle))
    LogOutput("INFO", "Vehicle quick-saved")
  end
end)

return {}
