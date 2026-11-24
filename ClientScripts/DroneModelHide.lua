local statics = require("Statics")

---DroneModelHide — client-side drone model hiding for FPV flight.
---
---Ctrl+Shift+B toggles hiding of every primitive component on the local
---player's drone (body, propellers, effects). UCameraComponent derives from
---USceneComponent, not UPrimitiveComponent, so the drone's camera keeps
---rendering while the visible model disappears.
---
---While enabled, hiding is re-applied on drone spawn
---(ClientSpawnDroneResponse) and whenever the game tries to show a drone
---component again (SetHiddenInGame hook) — no timer, no poll.
---State is runtime-only: resets to stock (visible) on client restart.

local PRIMITIVE_CLASS_PATH = "/Script/Engine.PrimitiveComponent"
local DRONE_SPAWN_HOOK = "/Script/MotorTown.MotorTownPlayerController:ClientSpawnDroneResponse"

---Feature state: true = drone primitives hidden
local hideEnabled = false

---Get the local player's drone (AMotorTownPlayerController.Drone), nil-safe
---@return FActorInstance?
local function GetMyDrone()
    local PC = GetMyPlayerController()
    if not PC or not PC:IsValid() then return nil end
    local ok, drone = pcall(function() return PC.Drone end)
    if not ok or not drone or not drone:IsValid() then return nil end
    if drone:IsActorBeingDestroyed() then return nil end
    return drone
end

---Set bHiddenInGame on every primitive component of the drone
---@param drone FActorInstance
---@param hidden boolean
---@return number found  primitive components seen on the actor
---@return number changed components actually toggled this call
local function SetDroneModelHidden(drone, hidden)
    local primClass = StaticFindObject(PRIMITIVE_CLASS_PATH)
    if not primClass or not primClass:IsValid() then return 0, 0 end

    local ok, comps = pcall(function() return drone:GetComponentsByClass(primClass) end)
    if not ok or not comps then return 0, 0 end

    local found, changed = 0, 0
    local count = #comps
    for i = 1, count do
        local comp = comps[i]
        if comp and comp:IsValid() then
            found = found + 1
            local readOk, isHidden = pcall(function() return comp.bHiddenInGame end)
            if readOk and isHidden ~= hidden then
                pcall(function() comp:SetHiddenInGame(hidden) end)
                changed = changed + 1
            end
        end
    end
    return found, changed
end

---Keybind handler: flip state, apply to the drone in flight (if any)
local function ToggleDroneModel()
    hideEnabled = not hideEnabled
    local drone = GetMyDrone()
    if drone then
        local found, changed = SetDroneModelHidden(drone, hideEnabled)
        LogOutput("INFO", "[DroneModelHide] %s — %d/%d primitive component(s) %s",
            hideEnabled and "ON" or "OFF", changed, found,
            hideEnabled and "hidden" or "shown")
    else
        LogOutput("INFO", "[DroneModelHide] %s (no drone in flight)",
            hideEnabled and "ON" or "OFF")
    end
    pcall(function()
        local PC = GetMyPlayerController()
        if PC and PC:IsValid() then
            PC:ClientShowPopupMessage(FText(hideEnabled and "Drone model: HIDDEN" or "Drone model: VISIBLE"))
        end
    end)
end

---Instant hide on drone spawn. Wrapped in pcall — RegisterHook THROWS on an
---unregistrable UFunction and must not brick the client mod's main chunk
---(if this hook is lost, the SetHiddenInGame hook still covers re-show).
do
    local ok, err = pcall(function()
        RegisterHook(DRONE_SPAWN_HOOK, function(Context, InDrone, InDroneItemKey)
            if not hideEnabled then return end
            local drone = InDrone:get()
            if not drone or not drone:IsValid() then return end
            local found, changed = SetDroneModelHidden(drone, true)
            LogOutput("INFO", "[DroneModelHide] Drone spawned — hid %d/%d primitive component(s)",
                changed, found)
        end)
    end)
    if not ok then
        LogOutput("WARN", "[DroneModelHide] %s hook failed to register (%s) — SetHiddenInGame hook still applies",
            DRONE_SPAWN_HOOK, tostring(err))
    end
end

---The game re-shows drone primitives on camera-mode changes. Re-hide on the
---SetHiddenInGame hook instead of polling. Our own re-hide calls pass true,
---so this cannot recurse.
RegisterHook("/Script/Engine.SceneComponent:SetHiddenInGame",
    function(Context, NewHidden, bPropagateToChildren)
        if not hideEnabled then return end
        local okHidden, hidden = pcall(function() return NewHidden:get() end)
        if not okHidden or hidden ~= false then return end

        local drone = GetMyDrone()
        if not drone then return end

        local okComp, comp = pcall(function() return Context:get() end)
        if not okComp or not comp or not comp:IsValid() then return end

        local okOwner, owner = pcall(function() return comp:GetOwner() end)
        if not okOwner or not owner or not owner:IsValid() then return end
        if owner ~= drone then return end

        pcall(function() comp:SetHiddenInGame(true) end)
    end)

RegisterKeyBind(Key.B, { ModifierKey.CONTROL, ModifierKey.SHIFT }, ToggleDroneModel)

LogOutput("INFO", "[DroneModelHide] Loaded (v%s) — Ctrl+Shift+B toggles drone model visibility",
    statics.ModVersion)

return {}
