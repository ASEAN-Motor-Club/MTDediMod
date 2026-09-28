-- SpikePadManager.lua — spike pad probe + disarm scaffolding (research phase)
--
-- Goals (staging probe, per the 2026-09-28 spike-pad investigation):
--   P1  do BP overlap hooks fire server-side on SpikePad_01_C?
--   P2  which disarm method kills the native puncture (TriggerBox overlap /
--       collision / zero / registry entry) while keeping the bump?
--   P3  part-damage semantics (direction/scale; does 100 => native puncture?)
--   P4  wheel<->part mapping + dual-writer (client wear report) behaviour
--   P5  vanilla baseline: innocent vs wanted drive-over, Net_Suspects match
--   P6  expiry: destroy vs pool/reuse
--
-- Everything here is idempotent and pcall-guarded: a bad hook or a despawned
-- actor logs and continues (never bricks the mod API).
--
-- Endpoints (all under /debug/spikepad):
--   GET  /debug/spikepad              state dump (registry, counters, config)
--   POST /debug/spikepad/config       {disarmMethod=..., sweepSeconds=...}
--   POST /debug/spikepad/spawn        {x,y,z}   spawn SpikePadClass directly
--   POST /debug/spikepad/disarmnow    {method?} sweep + disarm all live now
--   POST /debug/spikepad/hooktest     re-register the BP hooks, report status
--   GET  /debug/spikepad/vehicle      dump first player vehicle's Net_Parts
--   POST /debug/spikepad/setdamage    {slot,value} ServerSetPartDamage probe
--
-- This module is PROBE scaffolding: it observes and can disarm, but it does
-- not yet implement the episode/damage-curve feature (that lands after the
-- probe answers P1-P9).

local json = require("JsonParser")
local UEHelpers = require("UEHelpers")

local PREFIX = "[SpikePad]"

---Runtime config (overridable at runtime via POST /debug/spikepad/config)
local cfg = {
  disarmMethod = "none", -- none|overlap|nocollision|zero|registry
  sweepSeconds = 10,
  verboseOverlaps = true,
}

---Registry keyed by barrier actor object (value: meta). Pruned by sweep.
local registry = {}
local counters = {
  barrierSpawns = 0,
  padSpawns = 0,
  beginOverlaps = 0,
  endOverlaps = 0,
  disarmAttempts = 0,
  sweepRuns = 0,
}
local hookStatus = { begin = "?", finish = "?" }

local function registryKeys()
  local n = 0
  for _ in pairs(registry) do n = n + 1 end
  return n
end

local function log(level, msg)
  -- Logging.lua only knows ERROR/WARN/INFO/VERBOSE/DEBUG
  local lvl = level == "WARNING" and "WARN" or level
  LogOutput(lvl, PREFIX .. " " .. tostring(msg))
end

local function safeName(obj)
  if not obj or not obj:IsValid() then return "<invalid>" end
  local ok, n = pcall(function() return obj:GetFullName() end)
  if ok then return tostring(n) end
  return "<name-error>"
end

local function safeLoc(obj)
  local ok, l = pcall(function() return obj:K2_GetActorLocation() end)
  if ok and l then return string.format("(%.0f, %.0f, %.0f)", l.X, l.Y, l.Z) end
  return "(?)"
end

--------------------------------------------------------------------------
-- Disarm methods (M1/M2/M3/M6 ladder). Idempotent: re-running on an already
-- disarmed pad is a no-op. Returns (applied, note).
--------------------------------------------------------------------------
local function disarmPad(padActor)
  -- TriggerBox lives on the PAD actor (SpikePad_01_C), not the barrier.
  if not padActor or not padActor:IsValid() then return false, "pad invalid" end
  local method = cfg.disarmMethod
  if method == "none" then return false, "method none" end
  local tb = padActor.TriggerBox
  if not tb or not tb:IsValid() then return false, "no TriggerBox" end

  if method == "overlap" then
    local ok = pcall(function() tb:SetGenerateOverlapEvents(false) end)
    return ok, "overlap events disabled"
  elseif method == "nocollision" then
    local ok = pcall(function() tb:SetCollisionEnabled(0) end) -- NoCollision
    return ok, "collision disabled"
  elseif method == "zero" then
    local ok = pcall(function() tb:SetBoxExtent({ X = 1, Y = 1, Z = 1 }, true) end)
    return ok, "box extent zeroed"
  end
  return false, "unknown method " .. tostring(method)
end

local function disarmRegistryEntry(police, index)
  -- M6: remove the barrier entry from AMTPolice.Server_SpikeBarriers while
  -- keeping the actor alive. TArray element write: best-effort (nil write is
  -- not guaranteed to be supported on TArray wrappers).
  local ok, err = pcall(function()
    police.Server_SpikeBarriers[index] = nil
  end)
  return ok, err
end

--------------------------------------------------------------------------
-- Barrier / pad discovery
--------------------------------------------------------------------------
local function registerPad(padActor)
  counters.padSpawns = counters.padSpawns + 1
  if cfg.disarmMethod ~= "none" then
    counters.disarmAttempts = counters.disarmAttempts + 1
    local applied, note = disarmPad(padActor)
    log("INFO", string.format("pad spawn %s disarm=%s applied=%s (%s)",
      safeName(padActor), cfg.disarmMethod, tostring(applied), tostring(note)))
  else
    log("INFO", "pad spawn (disarm=none): " .. safeName(padActor) .. " " .. safeLoc(padActor))
  end
end

local function registerBarrier(barrier)
  counters.barrierSpawns = counters.barrierSpawns + 1
  registry[barrier] = {
    name = safeName(barrier),
    spawnedAt = os.time(),
    spawner = "?",
  }
  local okSp = pcall(function()
    local pc = barrier.Server_SpawnerPC
    registry[barrier].spawner = (pc and pc:IsValid()) and safeName(pc) or "AI/native"
  end)
  if not okSp then registry[barrier].spawner = "<read-error>" end
  log("INFO", string.format("barrier spawn: %s at %s spawner=%s (live=%d)",
    safeName(barrier), safeLoc(barrier), registry[barrier].spawner, registryKeys()))
end

--------------------------------------------------------------------------
-- P5 helper: vanilla suspect list dump
--------------------------------------------------------------------------
local function dumpSuspects()
  local out = {}
  local ok, police = pcall(FindFirstOf, "MTPolice")
  if not ok or not police or not police:IsValid() then
    return { error = "no AMTPolice found" }
  end
  local okArr, arr = pcall(function() return police.Net_Suspects end)
  if not okArr or not arr then return { error = "Net_Suspects unreadable" } end
  local n = #arr
  for i = 1, n do
    local s = arr[i]
    local okS = pcall(function()
      local ch = s.Character
      table.insert(out, {
        index = i,
        character = ch and ch:IsValid() and safeName(ch) or "<none>",
        location = string.format("(%.0f, %.0f)", s.LastSeenLocation.X, s.LastSeenLocation.Y),
      })
    end)
    if not okS then table.insert(out, { index = i, error = "entry unreadable" }) end
  end
  return { suspectCount = n, suspects = out }
end

--------------------------------------------------------------------------
-- P3/P4 helper: vehicle parts dump / damage write probe
--------------------------------------------------------------------------
local function firstPlayerVehicle()
  local ok, pc = pcall(FindFirstOf, "MotorTownPlayerController")
  if not ok or not pc or not pc:IsValid() then return nil, "no player controller" end
  local okV, veh = pcall(function() return pc.Pawn end)
  if not okV or not veh or not veh:IsValid() then return nil, "no pawn" end
  return veh, nil
end

local function dumpVehicleParts()
  local veh, err = firstPlayerVehicle()
  if not veh then return { error = err } end
  local parts = {}
  local okArr, arr = pcall(function() return veh.Net_Parts end)
  if not okArr or not arr then return { error = "Net_Parts unreadable" } end
  local n = #arr
  for i = 1, n do
    pcall(function()
      local p = arr[i]
      table.insert(parts, {
        index = i,
        key = p.Key and tostring(p.Key) or "<no-key>",
        slot = tostring(p.Slot),
        damage = p.Damage,
      })
    end)
  end
  return { vehicle = safeName(veh), partCount = n, parts = parts }
end

--------------------------------------------------------------------------
-- P1: BP overlap hooks on the pad class
--------------------------------------------------------------------------
---Resolve the BP function object first: RegisterHook on a missing BP function
---aborts the whole Lua chunk (even inside pcall — observed live 2026-09-28:
---Begin registered, End's attempted registration silenced everything after
---it; endpoints never registered). Check existence, then register.
local function findBPFunction(functionName)
  local ok, fn = pcall(StaticFindObject,
    "/Game/Objects/Mission/Police/SpikePad_01.SpikePad_01_C:" .. functionName)
  if ok and fn and fn:IsValid() then return fn end
  return nil
end

local function registerPadHooks()
  local results = {}
  local beginPath = "/Game/Objects/Mission/Police/SpikePad_01.SpikePad_01_C:ReceiveActorBeginOverlap"
  local okB, errB = pcall(RegisterHook, beginPath, function(Context, OtherActor)
    counters.beginOverlaps = counters.beginOverlaps + 1
    if cfg.verboseOverlaps then
      local actor = OtherActor:get()
      log("INFO", string.format("pad BEGIN overlap #%d other=%s",
        counters.beginOverlaps, actor and safeName(actor) or "<nil>"))
    end
  end)
  hookStatus.begin = okB and "registered" or ("FAILED: " .. tostring(errB))
  table.insert(results, { hook = "ReceiveActorBeginOverlap", ok = okB, err = errB })

  if findBPFunction("ReceiveActorEndOverlap") then
    local endPath = "/Game/Objects/Mission/Police/SpikePad_01.SpikePad_01_C:ReceiveActorEndOverlap"
    local okE, errE = pcall(RegisterHook, endPath, function(Context, OtherActor)
      counters.endOverlaps = counters.endOverlaps + 1
      if cfg.verboseOverlaps then
        local actor = OtherActor:get()
        log("INFO", string.format("pad END overlap #%d other=%s",
          counters.endOverlaps, actor and safeName(actor) or "<nil>"))
      end
    end)
    hookStatus.finish = okE and "registered" or ("FAILED: " .. tostring(errE))
    table.insert(results, { hook = "ReceiveActorEndOverlap", ok = okE, err = errE })
  else
    hookStatus.finish = "function not found on class (skipped — BP does not override it)"
    table.insert(results, { hook = "ReceiveActorEndOverlap", ok = false, err = "not found" })
  end

  for _, r in ipairs(results) do
    log(r.ok and "INFO" or "WARNING", string.format("hook %s: %s",
      r.hook, r.ok and "registered" or tostring(r.err)))
  end
  return results
end

--------------------------------------------------------------------------
-- Sweep: reconcile registry vs AMTPolice.Server_SpikeBarriers, prune dead
--------------------------------------------------------------------------
local function sweep()
  counters.sweepRuns = counters.sweepRuns + 1
  -- prune dead entries
  for barrier in pairs(registry) do
    local okValid, valid = pcall(function() return barrier:IsValid() end)
    if not okValid or not valid then
      registry[barrier] = nil
    end
  end
  -- enumerate live barriers
  local live = {}
  local ok, police = pcall(FindFirstOf, "MTPolice")
  if ok and police and police:IsValid() then
    local okArr, arr = pcall(function() return police.Server_SpikeBarriers end)
    if okArr and arr then
      local n = #arr
      for i = 1, n do
        local b = arr[i]
        if b and b:IsValid() then
          table.insert(live, { index = i, name = safeName(b), loc = safeLoc(b) })
          if cfg.disarmMethod == "registry" then
            local done, err = disarmRegistryEntry(police, i)
            log(done and "INFO" or "WARNING",
              "registry-disarm index=" .. tostring(i) .. " applied=" .. tostring(done) .. " err=" .. tostring(err))
          end
        end
      end
    end
  end
  log("INFO", string.format("sweep #%d live_barriers=%d registry_entries=%d disarm=%s",
    counters.sweepRuns, #live, registryKeys(), cfg.disarmMethod))
  return live
end

local sweepStarted = false
local function ensureSweepLoop()
  if sweepStarted then return end
  sweepStarted = true
  LoopInGameThreadWithDelay(cfg.sweepSeconds * 1000, function()
    local ok, err = pcall(sweep)
    if not ok then log("WARNING", "sweep error: " .. tostring(err)) end
    return false -- return TRUE stops the loop; FALSE keeps it running
  end)
  log("INFO", "sweep loop started (" .. tostring(cfg.sweepSeconds) .. "s)")
end

--------------------------------------------------------------------------
-- Spawn pad directly (testing without a police officer)
--------------------------------------------------------------------------
local function spawnPadAt(x, y, z)
  local okRes, res = pcall(function()
    local gr = FindFirstOf("MTGameResource")
    if not gr or not gr:IsValid() then return { error = "no MTGameResource" } end
    local okCls, cls = pcall(function() return gr.SpikePadClass end)
    if not okCls or not cls or not cls:IsValid() then return { error = "SpikePadClass not set/loaded" } end
    local world = UEHelpers.GetWorld()
    if not world or not world:IsValid() then return { error = "no world" } end
    local loc = { X = x or 0, Y = y or 0, Z = z or 200 }
    -- TSubclassOf wrapper: adapt to the usable UClass (direct / Get() / GetClass())
    local actor = nil
    local okSpawn = pcall(function() actor = world:SpawnActor(cls, loc, { Roll = 0, Pitch = 0, Yaw = 0 }) end)
    if not okSpawn or not actor then
      local okGet, clsU = pcall(function() return cls:Get() end)
      if okGet and clsU and clsU:IsValid() then
        pcall(function() actor = world:SpawnActor(clsU, loc, { Roll = 0, Pitch = 0, Yaw = 0 }) end)
      else
        local okGC, clsU2 = pcall(function() return cls:GetClass() end)
        if okGC and clsU2 and clsU2:IsValid() then
          pcall(function() actor = world:SpawnActor(clsU2, loc, { Roll = 0, Pitch = 0, Yaw = 0 }) end)
        end
      end
    end
    if actor then
      return { spawned = safeName(actor), loc = safeLoc(actor) }
    end
    return { error = "SpawnActor returned nil" }
  end)
  if not okRes then return { error = tostring(res) } end
  return res
end

--------------------------------------------------------------------------
-- Webserver endpoints
--------------------------------------------------------------------------
local function parseBody(session)
  local ok, content = pcall(json.parse, session and session.content)
  if ok and type(content) == "table" then return content end
  return {}
end

local function registerEndpoints()
  local okWS, webserver = pcall(require, "Webserver")
  if not okWS or not webserver or not webserver.registerHandler then
    log("WARNING", "webserver unavailable — endpoints not registered")
    return
  end
  local reg = webserver.registerHandler

  reg("/debug/spikepad", "GET", function(session)
    return {
      config = cfg,
      counters = counters,
      hookStatus = hookStatus,
      liveRegistryCount = registryKeys(),
      suspects = dumpSuspects(),
      status = "ok",
    }
  end)

  reg("/debug/spikepad/config", "POST", function(session)
    local body = parseBody(session)
    if body.disarmMethod ~= nil then
      cfg.disarmMethod = tostring(body.disarmMethod)
      log("INFO", "disarmMethod set to " .. cfg.disarmMethod)
    end
    if body.sweepSeconds ~= nil then
      cfg.sweepSeconds = tonumber(body.sweepSeconds) or cfg.sweepSeconds
    end
    if body.verboseOverlaps ~= nil then
      cfg.verboseOverlaps = body.verboseOverlaps and true or false
    end
    return { config = cfg, status = "ok" }
  end)

  reg("/debug/spikepad/spawn", "POST", function(session)
    local body = parseBody(session)
    return spawnPadAt(tonumber(body.x), tonumber(body.y), tonumber(body.z))
  end)

  reg("/debug/spikepad/disarmnow", "POST", function(session)
    local body = parseBody(session)
    if body.method then cfg.disarmMethod = tostring(body.method) end
    local live = sweep()
    return { method = cfg.disarmMethod, live = live, status = "ok" }
  end)

  reg("/debug/spikepad/hooktest", "POST", function(session)
    local results = registerPadHooks()
    return { hookStatus = hookStatus, results = results, status = "ok" }
  end)

  reg("/debug/spikepad/vehicle", "GET", function(session)
    return dumpVehicleParts()
  end)

  reg("/debug/spikepad/setdamage", "POST", function(session)
    local body = parseBody(session)
    local veh, err = firstPlayerVehicle()
    if not veh then return { error = err } end
    local slot = tonumber(body.slot) or 9
    local value = tonumber(body.value) or 0
    local ok, res = pcall(function() veh:ServerSetPartDamage(slot, value) end)
    return { applied = ok, err = ok and nil or tostring(res), slot = slot, value = value }
  end)

  log("INFO", "debug endpoints registered under /debug/spikepad")
end

--------------------------------------------------------------------------
-- Boot
--------------------------------------------------------------------------
local function boot()
  log("INFO", "module loading (probe scaffolding)")

  local okN, errN = pcall(NotifyOnNewObject, "/Script/MotorTown.MTSpikePadBarrier", function(barrier)
    ExecuteInGameThread(function()
      pcall(registerBarrier, barrier)
      ensureSweepLoop()
    end)
  end)
  log(okN and "INFO" or "WARNING", "NotifyOnNewObject MTSpikePadBarrier: "
    .. (okN and "registered" or tostring(errN)))

  local okP, errP = pcall(NotifyOnNewObject, "/Script/MotorTown.MTSpikePad", function(pad)
    ExecuteInGameThread(function()
      pcall(registerPad, pad)
    end)
  end)
  log(okP and "INFO" or "WARNING", "NotifyOnNewObject MTSpikePad: "
    .. (okP and "registered" or tostring(errP)))

  -- endpoints FIRST: a failed hook registration must never take the
  -- debug surface down with it (observed live 2026-09-28).
  registerEndpoints()

  pcall(registerPadHooks)
  if not hookStatus.begin:find("registered") or not hookStatus.finish:find("registered") then
    log("WARNING", "initial hook registration incomplete (see /debug/spikepad/hooktest)")
  end

  -- sweep start: BalanceManager's proven pattern — issue the loop directly at
  -- load (an ExecuteInGameThreadWithDelay wrapper silently never fired on
  -- staging 2026-09-28; the direct call demonstrably works).
  pcall(ensureSweepLoop)
  pcall(sweep)

  log("INFO", "module loaded")
end

local okBoot, errBoot = pcall(boot)
if not okBoot then
  LogOutput("ERROR", PREFIX .. " boot FAILED: " .. tostring(errBoot))
end

return {}
