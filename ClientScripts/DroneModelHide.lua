local statics = require("Statics")

---DroneModelHide — client-side drone model hiding for FPV flight.
---
---Ctrl+Shift+B toggles hiding of the local player's drone model for a clean
---FPV view. The drone camera (UCameraComponent) is never affected — bHidden
---and per-component hiding only affect primitive rendering, and a camera is
---not a UPrimitiveComponent.
---
---Field-tested 2026-09-05 on the live client (drone class Falcon1_C, a BP
---subclass of AMTDrone):
---  * ClientSpawnDroneResponse hooks client-side and passes the drone actor
---    directly — that capture is the reliable way to get the in-flight drone.
---  * FindFirstOf/FindAllOf match EXACT class names and miss BP subclasses;
---    PC.Drone is nil client-side. Both are kept only as fallbacks.
---  * AActor:GetComponentsByClass is NOT callable on this build (throws).
---  * Working hide ladder: whole-actor (K2_SetActorHiddenInGame /
---    SetActorHiddenInGame) → per-component (K2_GetComponentsByClass /
---    GetComponentsByClass) → native AMTDrone fields (RootBody + Props).
---The first strategy that works is cached and re-asserted every 500ms while
---enabled, so game-driven re-shows (e.g. camera-mode switches) are undone.
---State is runtime-only: resets to stock (visible) on client restart.

local PRIMITIVE_CLASS_PATH = "/Script/Engine.PrimitiveComponent"
local DRONE_SPAWN_HOOK = "/Script/MotorTown.MotorTownPlayerController:ClientSpawnDroneResponse"

---Feature state
local hideEnabled = false

---Captured from ClientSpawnDroneResponse — kept even when hideEnabled was
---off at spawn time, so the toggle can act on the in-flight drone.
local lastDroneRef = nil

---Which hide strategy worked (cached; logged once; reused on re-assert)
local activeStrategy = nil

---Concrete class name of an actor (diagnostics: shows the real BP subclass)
local function ClassNameOf(actor)
    local ok, name = pcall(function()
        return actor:GetClass():GetFName():ToString()
    end)
    if ok and name then return name end
    return "?"
end

local function DroneUsable(drone)
    return drone and drone:IsValid() and not drone:IsActorBeingDestroyed()
end

---The local player's drone, best-effort (capture > PC.Drone > name search)
local function GetMyDrone()
    if DroneUsable(lastDroneRef) then return lastDroneRef end
    local pc = GetMyPlayerController()
    if pc and pc:IsValid() then
        local ok, drone = pcall(function() return pc.Drone end)
        if ok and DroneUsable(drone) then return drone end
    end
    local ok2, drone = pcall(FindFirstOf, "MTDrone")
    if ok2 and DroneUsable(drone) then return drone end
    return nil
end

------------------------------------------------------------ Strategy 1
---Whole-actor hide: one call hides every primitive on the actor.
---@return boolean ok
---@return string via
local function HideWholeActor(drone, hidden)
    for _, fnName in ipairs({ "K2_SetActorHiddenInGame", "SetActorHiddenInGame" }) do
        local okCall, err = pcall(function() drone[fnName](drone, hidden) end)
        if okCall then
            local okRead, isHidden = pcall(function() return drone.bHidden end)
            if not okRead or isHidden == hidden then return true, fnName end
            LogOutput("INFO", "[DroneModelHide] call %s(%s) ok but bHidden reads %s",
                fnName, tostring(hidden), tostring(isHidden))
        else
            LogOutput("INFO", "[DroneModelHide] call %s threw: %s", fnName, tostring(err))
        end
    end
    return false, "whole-actor"
end

------------------------------------------------------------ Strategy 2
---Per-component hide via the actor's component enumeration.
---@return boolean ok
---@return string via
local function HidePerComponent(drone, hidden)
    local primClass = StaticFindObject(PRIMITIVE_CLASS_PATH)
    if not primClass or not primClass:IsValid() then return false, "no primitive class object" end
    for _, fnName in ipairs({ "K2_GetComponentsByClass", "GetComponentsByClass" }) do
        local ok, comps = pcall(function() return drone[fnName](drone, primClass) end)
        if ok and comps then
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
            if found > 0 then
                return true, fnName .. " [" .. changed .. "/" .. found .. " comps]"
            end
        else
            LogOutput("INFO", "[DroneModelHide] %s threw: %s", fnName, tostring(comps))
        end
    end
    return false, "per-component"
end

------------------------------------------------------------ Strategy 3
---Native AMTDrone fields: RootBody (USphereComponent) + Props (TArray).
---@return boolean ok
---@return string via
local function HideNativeFields(drone, hidden)
    local changed = 0
    pcall(function()
        local rb = drone.RootBody
        if rb and rb:IsValid() then
            local readOk, isHidden = pcall(function() return rb.bHiddenInGame end)
            if readOk and isHidden ~= hidden then
                pcall(function() rb:SetHiddenInGame(hidden) end)
                changed = changed + 1
            end
        end
    end)
    pcall(function()
        local props = drone.Props
        if props then
            for i = 1, #props do
                local comp = props[i]
                if comp and comp:IsValid() then
                    local readOk, isHidden = pcall(function() return comp.bHiddenInGame end)
                    if readOk and isHidden ~= hidden then
                        pcall(function() comp:SetHiddenInGame(hidden) end)
                        changed = changed + 1
                    end
                end
            end
        end
    end)
    return changed > 0, "native fields [" .. changed .. "]"
end

---Apply the layered hide. Cached strategy first, then the full ladder.
local function ApplyDroneHide(drone, hidden)
    if activeStrategy == "whole-actor" then
        local ok, via = HideWholeActor(drone, hidden)
        if ok then return true, via end
    end
    local ok1, via1 = HideWholeActor(drone, hidden)
    if ok1 then
        activeStrategy = "whole-actor"
        return true, via1
    end
    local ok2, via2 = HidePerComponent(drone, hidden)
    if ok2 then
        activeStrategy = "per-component"
        return true, via2
    end
    local ok3, via3 = HideNativeFields(drone, hidden)
    if ok3 then
        activeStrategy = "native-fields"
        return true, via3
    end
    return false, "ALL strategies failed"
end

---Keybind handler: flip state, apply to the drone in flight (if any)
local function ToggleDroneModel()
    hideEnabled = not hideEnabled
    local drone = GetMyDrone()
    if drone then
        local ok, via = ApplyDroneHide(drone, hideEnabled)
        LogOutput("INFO", "[DroneModelHide] %s — %s (class: %s)",
            hideEnabled and "ON" or "OFF", ok and via or ("FAILED: " .. via), ClassNameOf(drone))
    else
        LogOutput("INFO", "[DroneModelHide] %s (no drone found — armed for next spawn)",
            hideEnabled and "ON" or "OFF")
    end
    pcall(function()
        local PC = GetMyPlayerController()
        if PC and PC:IsValid() then
            PC:ClientShowPopupMessage(FText(hideEnabled and "Drone model: HIDDEN" or "Drone model: VISIBLE"))
        end
    end)
end

---Drone spawn response: capture the actor ALWAYS (BP-safe, the hook hands us
---the actor — no class-name search), hide immediately when enabled.
---Wrapped in pcall — RegisterHook THROWS on an unregistrable UFunction and
---must not brick the client mod's main chunk.
do
    local ok, err = pcall(function()
        RegisterHook(DRONE_SPAWN_HOOK, function(Context, InDrone, InDroneItemKey)
            local drone = InDrone:get()
            if not drone then return end
            lastDroneRef = drone
            if not DroneUsable(drone) then return end
            LogOutput("INFO", "[DroneModelHide] Drone spawn captured (class: %s)", ClassNameOf(drone))
            if not hideEnabled then return end
            local ok2, via = ApplyDroneHide(drone, true)
            LogOutput("INFO", "[DroneModelHide] Drone spawned — %s",
                ok2 and ("hidden via " .. via) or ("FAILED: " .. via))
        end)
    end)
    if not ok then
        LogOutput("WARN", "[DroneModelHide] %s hook failed to register (%s) — toggle fallbacks still apply",
            DRONE_SPAWN_HOOK, tostring(err))
    end
end

---Re-assert while enabled (500ms): undoes game re-shows (e.g. camera-mode
---switches), covers spawns that happened while disabled. Early-outs cheaply.
LoopInGameThreadWithDelay(500, function()
    if not hideEnabled then return end
    local drone = GetMyDrone()
    if not drone then return end
    if activeStrategy == "whole-actor" then
        local okRead, isHidden = pcall(function() return drone.bHidden end)
        if okRead and isHidden then return end
    end
    local ok, via = ApplyDroneHide(drone, true)
    if ok and not via:match("%[0/") then
        LogOutput("INFO", "[DroneModelHide] Re-asserted — %s", via)
    end
end)

RegisterKeyBind(Key.B, { ModifierKey.CONTROL, ModifierKey.SHIFT }, ToggleDroneModel)

LogOutput("INFO", "[DroneModelHide] Loaded (v%s) — Ctrl+Shift+B toggles drone model visibility",
    statics.ModVersion)

return {}
