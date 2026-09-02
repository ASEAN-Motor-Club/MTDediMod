local statics = require("Statics")

local vehicleClass = StaticFindObject("/Script/MotorTown.MTVehicle")

---RegisterHook wrapper: RegisterHook THROWS on an unregistrable UFunction
---(verified live 2026-08-31 — a bad top-level hook killed the whole main.lua
---chunk and bricked the mod API until a game restart). Fail soft instead:
---log loudly and continue. Hook failures are fail-open by design.
local function SafeRegisterHook(path, fn)
  local ok, err = pcall(RegisterHook, path, fn)
  if not ok then
    LogOutput("WARNING", "[RPManager] RegisterHook FAILED for " .. tostring(path) .. ": " .. tostring(err))
  end
  return ok
end

---Forward declaration: the poll loop lives below, but every RP hook triggers it
---on first invocation (see the boot comment near StartAutopilotPoll — on prod
---rc4 the boot-time NotifyOnNewObject defer NEVER fired, 2026-09-02, while the
---hooks demonstrably fire all day, so they are the reliable starter).
local EnsureAutopilotPoll

---Best-effort display name for log attribution (hooks log names so enforcement
---evidence is attributable per player).
local function GetPlayerName(playerController)
  if not playerController or not playerController:IsValid() then return "?" end
  local PS = playerController.PlayerState
  if not PS or not PS:IsValid() then return "?" end
  local ok, name = pcall(function()
    local n = PS:GetPlayerName()
    if type(n) == "userdata" then return n:ToString() end
    return tostring(n)
  end)
  if not ok or not name or name == "" then return "?" end
  return name
end

---Check if a player's display name contains an RP tag [R...] or wanted tag [*]
---(#15 semantics: match a leading [tag] whose contents contain R (RP mode /
---wanted) or * (wanted stars) — same semantics as the C++ should_block_teleport
---(dllmain.cpp). The previous ^%[R prefix check missed muted+RP players, whose
---tag is [XR...], leaving all server-side RP blocks bypassed.)
local function IsRPPlayer(playerController)
  local name = GetPlayerName(playerController)
  local tag = string.match(name, "^%[([^%]]*)%]")
  return tag ~= nil and string.find(tag, "[R*]") ~= nil
end

---Get the player's current pawn location.
local function GetPawnLocation(playerController)
  if not playerController or not playerController:IsValid() then return nil end
  local pawn = playerController:K2_GetPawn()
  if not pawn or not pawn:IsValid() then return nil end
  return pawn:K2_GetActorLocation()
end

---Racetrack allowance (YOUYU decision 2026-09-02: "racetracks resets not
---affected"): vehicle reset is part of legitimate racing. The game's Reset UI
---only exists at racetracks, but roadside TP fires the SAME
---ServerResetVehicleAt RPC, so a blanket allow would un-block roadside.
---Discriminator: the server tracks event membership on the PlayerState —
---allow the reset while the player is joined to an event (races/CTF run at
---tracks); roadside TP without event membership stays blocked.
local function IsInServerEvent(playerController)
  if not playerController or not playerController:IsValid() then return false end
  local PS = playerController.PlayerState
  if not PS or not PS:IsValid() then return false end
  local ok, n = pcall(function() return #PS.JoinedEventGuids end)
  return ok and (n or 0) > 0
end

-- ServerTeleportCharacter: replace AbsoluteLocation with current pawn pos
SafeRegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerTeleportCharacter", function(PC, AbsoluteLocation, bCharge, bIsRespawn)
  if EnsureAutopilotPoll then EnsureAutopilotPoll("hook:ServerTeleportCharacter") end
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end

  local loc = GetPawnLocation(playerController)
  if loc then
    local al = AbsoluteLocation:get()
    al.X = loc.X
    al.Y = loc.Y
    al.Z = loc.Z
    LogOutput("INFO", string.format("[RPManager] Blocked ServerTeleportCharacter for %s — replaced with current pos", GetPlayerName(playerController)))
  end
end)

-- ServerTeleportVehicle: replace AbsoluteLocation with current vehicle pos
SafeRegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerTeleportVehicle", function(PC, Vehicle, AbsoluteLocation)
  if EnsureAutopilotPoll then EnsureAutopilotPoll("hook:ServerTeleportVehicle") end
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end
  -- Event members: movement blocks waived (racetrack allowance), except
  -- character teleport + autopilot which stay enforced for everyone
  if IsInServerEvent(playerController) then
    LogOutput("INFO", string.format("[RPManager] Allowed ServerTeleportVehicle for %s — event member (racetrack allowance)", GetPlayerName(playerController)))
    return
  end

  local veh = Vehicle:get()
  if veh and veh:IsValid() then
    local loc = veh:K2_GetActorLocation()
    local al = AbsoluteLocation:get()
    al.X = loc.X
    al.Y = loc.Y
    al.Z = loc.Z
    LogOutput("INFO", string.format("[RPManager] Blocked ServerTeleportVehicle for %s — replaced with current pos", GetPlayerName(playerController)))
  end
end)

-- ServerRespawnCharacter: replace AbsoluteLocation with current pawn pos
SafeRegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerRespawnCharacter", function(PC, AbsoluteLocation)
  if EnsureAutopilotPoll then EnsureAutopilotPoll("hook:ServerRespawnCharacter") end
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end
  if IsInServerEvent(playerController) then return end

  local loc = GetPawnLocation(playerController)
  if loc then
    local al = AbsoluteLocation:get()
    al.X = loc.X
    al.Y = loc.Y
    al.Z = loc.Z
    LogOutput("INFO", string.format("[RPManager] Blocked ServerRespawnCharacter for %s — replaced with current pos", GetPlayerName(playerController)))
  end
end)

-- ServerResetVehicleAt: replace WorldLocation/Rotation with current vehicle transform
SafeRegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerResetVehicleAt", function(PC, Vehicle, WorldLocation, Rotation, bRemoveCargo, bResetCarriedVehicles)
  if EnsureAutopilotPoll then EnsureAutopilotPoll("hook:ServerResetVehicleAt") end
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end

  -- Racetrack allowance: event members may reset (see IsInServerEvent)
  if IsInServerEvent(playerController) then
    LogOutput("INFO", string.format("[RPManager] Allowed ServerResetVehicleAt for %s — event member (racetrack allowance)", GetPlayerName(playerController)))
    return
  end

  local veh = Vehicle:get()
  if veh and veh:IsValid() then
    local loc = veh:K2_GetActorLocation()
    local rot = veh:K2_GetActorRotation()
    local wl = WorldLocation:get()
    wl.X = loc.X
    wl.Y = loc.Y
    wl.Z = loc.Z
    local r = Rotation:get()
    r.Pitch = rot.Pitch
    r.Yaw = rot.Yaw
    r.Roll = rot.Roll
    LogOutput("INFO", string.format("[RPManager] Blocked ServerResetVehicleAt for %s — replaced with current transform", GetPlayerName(playerController)))
  end
end)

SafeRegisterHook("/Script/MotorTown.MotorTownPlayerController:ServerVehicleExControl", function(PC, Vehicle, Control)
  if EnsureAutopilotPoll then EnsureAutopilotPoll("hook:ServerVehicleExControl") end
  local playerController = PC:get()
  if not IsRPPlayer(playerController) then return end
  -- Event members: roadside service allowed (RaceSetup can enable roadside
  -- towing to garage — races legitimately use it; racetrack allowance)
  if IsInServerEvent(playerController) then return end
  if Control:get() == 2 then
    Control:set(0)
    LogOutput("INFO", string.format("[RPManager] Neutralized RoadsideService for %s", GetPlayerName(playerController)))
  end
end)

---Block autopilot (AI driving) for RP players — FINAL design (v9, freeman
---2026-08-31: "ejection is the last option. Let's do that"): warn popup, then
---popup + ServerExitVehicle. Poll the server replica every 3s on the game
---thread (LoopAsync is the forbidden Jan-2026 crash pattern; toggling AP does
---NOT emit ServerSyncColdState — the flag replicates as a property).
---WHY eject: three server-owned vehicle-state levers were live-falsified on
---staging (fuel starvation v5, engine cold-state latch v7b, parking brake v8 —
---each RPC succeeded server-side while the client sim kept driving; fuel kept
---draining through all three). The client owns vehicle physics; pawn
---possession (ServerExitVehicle) is the only server-authoritative physical
---action. Field-proven: 5 clean ejects (v3-composite, 07:28–07:29 UTC).
---Humane ladder: 1st detection -> warning popup only; 2nd (5s debounce) ->
---popup + eject. Toggling AP off at any point resets the cycle. After an
---ejection the cycle restarts fresh on re-entry (AP stays armed across
---re-entry — the client re-arms it — so repeat offenders get warned again
---before each ejection). Economy gate (no RP payout for AP-assisted jobs)
---remains KIV as the long-term deterrent.
---State keyed by player NAME (userdata keys are fresh wrappers every poll and
---never matched — the old 5s debounce provably fired every 3s poll).
---AP_DEBUG enables per-tick state dumps for field diagnosis (log noise:
---one line per RP player per tick). Keep off in production; the 30s heartbeat
---always runs and is enough to verify the loop is alive (boot-race check).
local AP_DEBUG = false
local AP_WARN_LIMIT = 2     -- actions before eject (1 warning, then eject)
local AP_DEBOUNCE = 5       -- seconds between poll actions per player
local AP_STATE = {}         -- name -> { warns = n, last = os.time() }
local POLL_TICKS = 0
local POLL_STARTED = false

---The poll loop must be registered only once the engine's game-thread hooks
---are available. At BOOT, RPManager is required before BalanceManager (main.lua
---requires Helpers first, so GetMotorTownGameState is usable at require time),
---and if our LoopInGameThreadWithDelay call is the FIRST of the process the
---EngineTick hook install races (not yet scannable) and the action silently
---falls back to the ProcessEvent executor — which never fires on this build
---(verified live 2026-08-31: a boot-registered loop never ticked; the identical
---code hot-reloaded post-world ticks every 3s). So: register immediately when
---the game state already exists (hot reload), otherwise defer until
---MTGameResource is created (world up — the same signal BalanceManager relies on).
---FIELD FAILURE (prod rc4, 2026-09-02): the boot-time NotifyOnNewObject callback
---NEVER fired — "Registered notification" logged at require time, MTGameResource
---was created, yet zero "poll loop registered" lines and zero heartbeats all
---day. Starter is therefore MULTI-TRIGGER and idempotent (first one lands wins):
---  1. any of the 5 RP hooks — fire for every player, proven to fire all day
---  2. HTTP /status/general + /events GET handlers — backend polls them
---  3. NotifyOnNewObject (kept — harmless, may work on other builds)
---  4. FindAllOf retry loop (BalanceManager's pattern; dead if boot-registered
---     loops never tick on this build, harmless then)
local function StartAutopilotPoll(source)
  if POLL_STARTED then return end
  POLL_STARTED = true
  LogOutput("INFO", "[RPManager] Autopilot poll loop registered (3s game-thread) via " .. tostring(source))
  LoopInGameThreadWithDelay(3000, function()
  POLL_TICKS = POLL_TICKS + 1
  local gameState = GetMotorTownGameState()
  if not gameState or not gameState:IsValid() then return end

  local seen, rpSeen = {}, 0
  local now = os.time()
  for i = 1, #gameState.PlayerArray, 1 do
    local PS = gameState.PlayerArray[i]
    if PS and PS:IsValid() then
      local okPC, pc = pcall(function() return PS:GetPlayerController() end)
      if okPC and pc and pc:IsValid() and IsRPPlayer(pc) then
        rpSeen = rpSeen + 1
        local okName, name = pcall(function()
          local n = PS:GetPlayerName()
          if type(n) == "userdata" then return n:ToString() end
          return tostring(n)
        end)
        name = (okName and name) or "unknown"
        seen[name] = true

        local okVeh, veh = pcall(function() return pc:K2_GetPawn() end)
        local inVeh = okVeh and veh and veh:IsValid() and not veh:IsActorBeingDestroyed()
        local ai, fuel = false, "n/a"
        local pawnCls, hasCS = "n/a", "n/a"
        if inVeh then
          local okCls, c = pcall(function() return veh:GetClass():GetFName():ToString() end)
          if okCls and c then pawnCls = c end
          local okCS, cs = pcall(function() return veh.NetLC_ColdState ~= nil end)
          if okCS then hasCS = tostring(cs) end
          local okAI, v = pcall(function()
            return veh.NetLC_ColdState and veh.NetLC_ColdState.bIsAIDriving
          end)
          ai = okAI and v == true
          local okFuel, f = pcall(function()
            if veh.NetLC_VehicleState and veh.NetLC_VehicleState:IsValid() then
              return veh.NetLC_VehicleState.Fuel
            end
            return nil
          end)
          if okFuel then fuel = tostring(f) end
        end

        if AP_DEBUG then
          LogOutput("INFO", string.format(
            "[RPManager] POLL name=%s pawn=%s cs=%s ai=%s fuel=%s",
            tostring(name), pawnCls, hasCS, tostring(ai), fuel))
        end

        if ai then
          local st = AP_STATE[name] or { warns = 0, last = 0 }
          if now - st.last >= AP_DEBOUNCE then
            st.last = now
            st.warns = st.warns + 1
            if st.warns >= AP_WARN_LIMIT then
              pcall(function()
                pc:ClientShowSystemMessage(FText("Autopilot is not allowed in RP mode. Ejecting."))
              end)
              pcall(function() pc:ServerExitVehicle() end)
              LogOutput("INFO", "[RPManager] Ejected driver (autopilot attempt) for RP player")
              AP_STATE[name] = nil  -- fresh warn cycle on next re-entry
            else
              AP_STATE[name] = st
              pcall(function()
                pc:ClientShowSystemMessage(FText("Autopilot is not allowed in RP mode. Toggle it off or you will be ejected."))
              end)
              LogOutput("INFO", string.format("[RPManager] Warned RP player (autopilot attempt %d/%d)", st.warns, AP_WARN_LIMIT))
            end
          else
            AP_STATE[name] = st
          end
        else
          -- AP off (or not in a vehicle): reset the warn cycle
          AP_STATE[name] = nil
        end
      end
    end
  end

  -- prune state for players who left or dropped the RP tag
  for name in pairs(AP_STATE) do
    if not seen[name] then AP_STATE[name] = nil end
  end

  -- heartbeat: proves the poll is alive even when no RP player is online
  if POLL_TICKS % 10 == 0 then
    LogOutput("INFO", string.format("[RPManager] POLL alive (tick %d, rpSeen=%d)", POLL_TICKS, rpSeen))
  end
end)
end
EnsureAutopilotPoll = StartAutopilotPoll

-- Register now if the world already exists (hot reload); otherwise defer until
-- MTGameResource is created at world load (boot), which also guarantees the
-- EngineTick hook is installable (see the comment above StartAutopilotPoll).
local okGS, bootGameState = pcall(GetMotorTownGameState)
if okGS and bootGameState and bootGameState:IsValid() then
  StartAutopilotPoll("hot-reload: world exists")
else
  pcall(function()
    NotifyOnNewObject("/Script/MotorTown.MTGameResource", function(obj)
      if obj and obj:IsValid() then
        StartAutopilotPoll("notify:new MTGameResource")
      end
    end)
  end)
  -- Best-effort belt: FindAllOf retry (BalanceManager's proven pattern). If
  -- boot-registered game-thread loops never tick on this build this never
  -- runs — the hook/http triggers are the reliable path then.
  pcall(function()
    LoopInGameThreadWithDelay(5000, function()
      local okFound, found = pcall(FindAllOf, "MTGameResource")
      if okFound and found and #found > 0 then
        StartAutopilotPoll("findallof retry")
        return true
      end
      return false
    end)
  end)
  LogOutput("INFO", "[RPManager] Poll loop deferred until world (MTGameResource) exists")
end

LogOutput("INFO", "[RPManager] Loaded (v%s)", statics.ModVersion)

return {
  EnsureAutopilotPoll = EnsureAutopilotPoll,
}
