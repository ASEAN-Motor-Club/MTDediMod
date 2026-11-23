---Shortcuts module: configurable keybinds for common actions
---Reads shortcut config from ModConfig and registers keyboard/gamepad binds

local config = require("ModConfig")
local UEHelpers = require("UEHelpers")
local teleportManager = require("TeleportManager")
local vehicleManager = require("VehicleManager")
local vehicleSaveSpawn = require("VehicleSaveSpawn")
local json = require("JsonParser")
local http = require("socket.http")
local ltn12 = require("ltn12")

--- Minimum interval between shortcut triggers (ms)
local DEBOUNCE_MS = 1000
local lastTriggerTime = 0
local lastDespawnTime = 0
local lastImpulseTime = 0
local lastDespawnDialogTime = 0
local lastDoorToggleTime = 0
local lastEngineToggleTime = 0
local despawnDialogOpen = false

--- Writer generation for ServerSetVehicleEngineColdState (0.7.20). The RPC
--- orders cold-state writes by generation, so it must increase per call.
local engineColdStateGeneration = 0

--- Impulse strength for the aimed impulse shortcut (persisted in config.json)
local DEFAULT_IMPULSE_STRENGTH = 100000.0
local IMPULSE_MIN = 1000.0
local IMPULSE_MAX = 1000000000.0

--- Speed mode: impulse is derived from the actor's mass, so the same setting
--- produces the same velocity change on a scooter and on a loaded truck.
local DEFAULT_SPEED_KMH = 20.0
local SPEED_MIN_KMH = 1.0
local SPEED_MAX_KMH = 1000.0
--- 1 km/h = 100000cm / 3600s
local KMH_TO_CMS = 100000.0 / 3600.0

---Current impulse mode: "raw" (send the number as-is) or "speed" (mass-scaled)
---@return string
local function GetImpulseMode()
    local m = config.GetModConfig("impulseMode")
    if m == "speed" then return "speed" end
    return "raw"
end

---Current target speed change in km/h (speed mode only)
---@return number
local function GetSpeedKmh()
    local v = config.GetModConfig("impulseSpeedKmh")
    if type(v) ~= "number" then return DEFAULT_SPEED_KMH end
    if v < SPEED_MIN_KMH then return SPEED_MIN_KMH end
    if v > SPEED_MAX_KMH then return SPEED_MAX_KMH end
    return v
end

---Current impulse strength from config, clamped to a sane range
---@return number
local function GetImpulseStrength()
    local v = config.GetModConfig("impulseStrength")
    if type(v) ~= "number" then return DEFAULT_IMPULSE_STRENGTH end
    if v < IMPULSE_MIN then return IMPULSE_MIN end
    if v > IMPULSE_MAX then return IMPULSE_MAX end
    return v
end

---Current right-click action: "despawn" (aimed actor), "trunk" (nearest door)
---or "engine" (toggle the aimed vehicle's engine cold-state).
---@return string
local RIGHT_CLICK_ACTIONS = { "despawn", "trunk", "engine" }

local function IsRightClickAction(a)
    for _, v in ipairs(RIGHT_CLICK_ACTIONS) do
        if v == a then return true end
    end
    return false
end

local function GetRightClickAction()
    local a = config.GetModConfig("rightClickAction")
    if type(a) ~= "string" then return "despawn" end
    a = string.lower(a)
    if IsRightClickAction(a) then return a end
    return "despawn"
end

---Advance despawn -> trunk -> engine -> despawn.
---@return string the new action
local function CycleRightClickAction()
    local cur = GetRightClickAction()
    local idx = 1
    for i, v in ipairs(RIGHT_CLICK_ACTIONS) do
        if v == cur then idx = i end
    end
    local nxt = RIGHT_CLICK_ACTIONS[(idx % #RIGHT_CLICK_ACTIONS) + 1]
    config.SetModConfig("rightClickAction", nxt)
    return nxt
end

---Impulse direction: "angled" (70% forward + 30% up), "ray" (straight along
---the aim ray) or "up" (straight up)
---@return string
local function GetImpulseDirectionMode()
    local m = config.GetModConfig("impulseDirection")
    if m == "ray" or m == "up" then return m end
    return "angled"
end

---Where the impulse is applied: "impact" (raycast hit point) or "com" (center of mass)
---@return string
local function GetImpulseOriginMode()
    local m = config.GetModConfig("impulseOrigin")
    if m == "com" then return m end
    return "impact"
end

---Round + clamp an impulse value to the allowed range
---@param n number
---@return number? value
local function ClampImpulse(n)
    if type(n) ~= "number" or n ~= n then return nil end -- bad input / NaN guard
    n = math.floor(n + 0.5)
    if n < IMPULSE_MIN then n = IMPULSE_MIN end
    if n > IMPULSE_MAX then n = IMPULSE_MAX end
    return n
end

---Round + clamp a speed-mode target (km/h)
---@param n number
---@return number? value
local function ClampSpeed(n)
    if type(n) ~= "number" or n ~= n then return nil end
    n = math.floor(n * 10 + 0.5) / 10
    if n < SPEED_MIN_KMH then n = SPEED_MIN_KMH end
    if n > SPEED_MAX_KMH then n = SPEED_MAX_KMH end
    return n
end

---Is this actor a Motor Town vehicle?
---@param actor AActor?
---@return boolean
local function IsVehicleActor(actor)
    if not actor or not actor:IsValid() then return false end
    local ok, vehicleClass = pcall(StaticFindObject, "/Script/MotorTown.MTVehicle")
    if not ok or not vehicleClass or not vehicleClass:IsValid() then return false end
    local ok2, isVehicle = pcall(function() return actor:IsA(vehicleClass) end)
    return ok2 and isVehicle == true
end

---Mass of a VEHICLE's root primitive in kg (engine-reported), or nil.
---Only vehicles are queried: GetMass() dereferences the physics body, and
---non-vehicle actors (cargo, props, breakables) can have no BodyInstance.
---@param actor AActor?
---@return number? massKg
local function GetActorMassKg(actor)
    if not IsVehicleActor(actor) then return nil end
    local ok, root = pcall(function() return actor:K2_GetRootComponent() end)
    if not ok or not root or not root:IsValid() then return nil end
    local ok2, mass = pcall(function() return root:GetMass() end)
    if not ok2 or type(mass) ~= "number" or mass <= 0 then return nil end
    return mass
end

---Actor currently under the crosshair (client-side trace), or nil
---@return AActor?
local function GetAimedActorNow()
    local ok, wasHit, hitResult = pcall(GetHitResultFromCenterLineTrace)
    if not ok or not wasHit then return nil end
    local ok2, actor = pcall(GetActorFromHitResult, hitResult)
    if not ok2 or not actor or not actor:IsValid() then return nil end
    return actor
end

---Impulse magnitude to send for a vehicle of `massKg`.
---Speed mode scales with mass so every vehicle gets the same delta-v;
---raw mode returns the configured number unchanged.
---@param massKg number?
---@return number? strength
local function ComputeImpulseStrength(massKg)
    if GetImpulseMode() == "speed" then
        if not massKg then return nil end
        return massKg * GetSpeedKmh() * KMH_TO_CMS
    end
    return GetImpulseStrength()
end

---Unit direction vector for the impulse, per the configured direction mode
---@param forward FVector aim/camera forward
---@return number x
---@return number y
---@return number z
local function GetImpulseDirectionUnit(forward)
    local mode = GetImpulseDirectionMode()
    local x, y, z
    if mode == "up" then
        x, y, z = 0.0, 0.0, 1.0
    elseif mode == "ray" then
        x, y, z = forward.X, forward.Y, forward.Z
    else
        x = forward.X * 0.7
        y = forward.Y * 0.7
        z = forward.Z * 0.7 + 0.3
    end
    local len = math.sqrt(x * x + y * y + z * z)
    if len > 0 then
        x, y, z = x / len, y / len, z / len
    end
    return x, y, z
end

---World-space center of mass of the root primitive, or nil
---@param root UPrimitiveComponent
---@return table? vector
local function GetCenterOfMassWorld(root)
    if not root or not root:IsValid() then return nil end
    local ok, com = pcall(function() return root:GetCenterOfMass() end)
    if (not ok) or type(com) ~= "table" or type(com.X) ~= "number" then
        ok, com = pcall(function() return root:GetCenterOfMass("") end)
    end
    if ok and type(com) == "table" and type(com.X) == "number" then
        return com
    end
    return nil
end

---Relative application point (actor-space) and a label for logging
---@param actor AActor
---@param root UPrimitiveComponent
---@param hitResult table
---@return table location
---@return string label
local function GetImpulseRelativeLocation(actor, root, hitResult)
    local loc = actor:K2_GetActorLocation()
    if GetImpulseOriginMode() == "com" then
        local com = GetCenterOfMassWorld(root)
        if com then
            return { X = com.X - loc.X, Y = com.Y - loc.Y, Z = com.Z - loc.Z }, "com"
        end
        return { X = 0.0, Y = 0.0, Z = 0.0 }, "origin-fallback"
    end
    return {
        X = hitResult.ImpactPoint.X - loc.X,
        Y = hitResult.ImpactPoint.Y - loc.Y,
        Z = hitResult.ImpactPoint.Z - loc.Z,
    }, "impact"
end

--- Setters for the egui admin panel. Each writes config.json immediately so
--- the next key press or bridge poll sees the new value.
local function SetImpulseStrength(n)
    local v = ClampImpulse(n)
    if not v then return false end
    config.SetModConfig("impulseStrength", v)
    return true
end

local function SetSpeedKmh(n)
    local v = ClampSpeed(n)
    if not v then return false end
    config.SetModConfig("impulseSpeedKmh", v)
    return true
end

local function SetImpulseMode(mode)
    if mode ~= "raw" and mode ~= "speed" then return false end
    config.SetModConfig("impulseMode", mode)
    return true
end

local function SetImpulseDirectionMode(mode)
    if mode ~= "angled" and mode ~= "ray" and mode ~= "up" then return false end
    config.SetModConfig("impulseDirection", mode)
    return true
end

local function SetImpulseOriginMode(mode)
    if mode ~= "impact" and mode ~= "com" then return false end
    config.SetModConfig("impulseOrigin", mode)
    return true
end

local function SetRightClickAction(action)
    if not IsRightClickAction(action) then return false end
    config.SetModConfig("rightClickAction", action)
    return true
end

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
        local breakableClass = StaticFindObject("/Script/MotorTown.MTBreakable")

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
        elseif breakableClass:IsValid() and actor:IsA(breakableClass) then
            if not actor:IsActorBeingDestroyed() then
                PC:ServerTrashItem(actor)
                LogOutput("INFO", "Despawn shortcut: Trashed breakable %s", actor:GetFullName())
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

---Toggle the engine of the vehicle the player is aiming at (Ctrl+Shift+E)
---Flips NetLC_EngineColdState.bDisabled via the controller's
---ServerSetVehicleEngineColdState RPC. When disabled, the vehicle cannot be
---started until toggled back.
---0.7.20 moved this off the vehicle (AMTVehicle:ServerSetEngineColdState is
---gone) and added a writer Generation (uint64) to the new
---ServerSetVehicleEngineColdState(Vehicle, Generation, State); we send a
---locally increasing counter.
local function TriggerEngineToggleAimed()
    if not IsAdmin() then
        LogOutput("WARN", "Engine toggle shortcut: Admin only")
        return
    end

    local now = os.clock() * 1000
    if now - lastEngineToggleTime < DEBOUNCE_MS then
        return
    end
    lastEngineToggleTime = now

    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC:IsValid() then
            LogOutput("WARN", "Engine toggle shortcut: PlayerController not valid")
            return
        end

        local wasHit, hitResult = GetHitResultFromCenterLineTrace()
        if not wasHit then
            LogOutput("INFO", "Engine toggle shortcut: Nothing aimed at")
            return
        end

        local actor = GetActorFromHitResult(hitResult)
        if not actor:IsValid() then
            LogOutput("INFO", "Engine toggle shortcut: Invalid aimed actor")
            return
        end

        local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")
        if not vehicleClass:IsValid() or not actor:IsA(vehicleClass) then
            LogOutput("INFO", "Engine toggle shortcut: Aimed actor is not a vehicle")
            return
        end

        ---@cast actor AMTVehicle
        if actor:IsActorBeingDestroyed() then
            LogOutput("INFO", "Engine toggle shortcut: Vehicle is being destroyed")
            return
        end

        local coldState = actor.NetLC_EngineColdState
        local wasDisabled = coldState ~= nil and coldState.bDisabled == true
        ---@type FMTEngineColdState
        local newState = {
            bOverHeated = coldState ~= nil and coldState.bOverHeated == true or false,
            bDisabled = not wasDisabled,
        }
        engineColdStateGeneration = engineColdStateGeneration + 1
        PC:ServerSetVehicleEngineColdState(actor, engineColdStateGeneration, newState)
        LogOutput("INFO", "Engine toggle shortcut: %s engine on %s (bDisabled %s -> %s)",
            newState.bDisabled and "Stopped" or "Started",
            actor:GetFullName(),
            tostring(wasDisabled),
            tostring(newState.bDisabled))
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

        local massKg = GetActorMassKg(actor)
        -- Static props report 0 kg; treating that as a real mass makes the
        -- delta-v readout divide by zero and skews speed mode.
        if massKg and massKg <= 0 then massKg = nil end
        local strength = ComputeImpulseStrength(massKg)
        if not strength then
            strength = GetImpulseStrength()
            LogOutput("WARN", "Impulse: mass unavailable for %s; sending raw strength %.0f",
                actor:GetFullName(), strength)
        end
        local deltaV = massKg and (strength / massKg / KMH_TO_CMS) or nil
        local ix, iy, iz = GetImpulseDirectionUnit(forward)
        local relativeLocation, originLabel = GetImpulseRelativeLocation(actor, rootComponent, hitResult)

        LogOutput("INFO", "Impulse: mass=%s strength=%.0f mode=%s dir=%s origin=%s deltaV=%s",
            massKg and string.format("%.0fkg", massKg) or "unknown",
            strength,
            GetImpulseMode(),
            GetImpulseDirectionMode(),
            originLabel,
            deltaV and string.format("%.1fkm/h", deltaV) or "n/a")

        local impulse = {
            X = ix * strength,
            Y = iy * strength,
            Z = iz * strength,
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
        if not PC:IsValid() then return true end

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
        return true
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
---Ctrl+Shift+RMB action is selectable in the egui admin panel.
local function TriggerRightClick()
    local action = GetRightClickAction()
    if action == "trunk" then
        TriggerDoorToggle()
    elseif action == "engine" then
        TriggerEngineToggleAimed()
    else
        TriggerDespawnAimed()
    end
end

RegisterKeyBind(Key.RIGHT_MOUSE_BUTTON, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerRightClick)
RegisterKeyBind(Key.I, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerImpulseAimed)
RegisterKeyBind(Key.LEFT_MOUSE_BUTTON, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerImpulseAimed)
RegisterKeyBind(Key.O, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDoorToggle)
RegisterKeyBind(Key.E, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerEngineToggleAimed)
RegisterKeyBind(Key.T, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerTeleportDialog)
RegisterKeyBind(Key.D, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerDespawnDialog)
RegisterKeyBind(Key.G, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerGhostToggle)
RegisterKeyBind(Key.J, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerGodToggle)
RegisterKeyBind(Key.H, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerHideCostume)
RegisterKeyBind(Key.V, { ModifierKey.CONTROL, ModifierKey.SHIFT }, TriggerInvisibleToggle)

RegisterKeyBind(Key.F5, { ModifierKey.CONTROL, ModifierKey.SHIFT }, function()
  local PC = GetMyPlayerController()
  if PC:IsValid() and PC.LastVehicle and PC.LastVehicle:IsValid() then
    vehicleSaveSpawn.SaveVehicle("quicksave", vehicleSaveSpawn.SerializeVehicle(PC.LastVehicle))
    LogOutput("INFO", "Vehicle quick-saved")
  end
end)

-- Public API driven by OverlayBridge.lua (egui overlay) and by the keybinds.
return {
    GetImpulseMode = GetImpulseMode,
    GetImpulseStrength = GetImpulseStrength,
    GetSpeedKmh = GetSpeedKmh,
    GetImpulseDirectionMode = GetImpulseDirectionMode,
    GetImpulseOriginMode = GetImpulseOriginMode,
    GetRightClickAction = GetRightClickAction,
    GetAimedMassKg = function() return GetActorMassKg(GetAimedActorNow()) end,

    SetImpulseStrength = SetImpulseStrength,
    SetSpeedKmh = SetSpeedKmh,
    SetImpulseMode = SetImpulseMode,
    SetImpulseDirectionMode = SetImpulseDirectionMode,
    SetImpulseOriginMode = SetImpulseOriginMode,
    SetRightClickAction = SetRightClickAction,

    ImpulseAimed = TriggerImpulseAimed,
    DespawnAimed = TriggerDespawnAimed,
    DoorToggle = TriggerDoorToggle,
    EngineAimed = TriggerEngineToggleAimed,
}
