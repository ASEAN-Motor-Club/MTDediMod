---TimeManager.lua
---World clock (time of day) as mod HTTP endpoints: GET /time, POST /time,
---POST /time/offset, POST /time/speed.
---
---THREADING (src/LuaHttpServer.cpp + live on staging 2026-11-13):
---  Requests are queued by the HTTP worker onto the game thread and the Lua
---  handler is invoked there, so UObject access from a handler is legal (that is
---  why AssetManager can call world:SpawnActor directly). Never call
---  ExecuteInGameThreadSync from a handler: it queues onto the queue the handler
---  is already running on and can never be drained — measured on staging, an 8 s
---  budget timed out and the queued callback ran 140 ms AFTER the handler
---  returned. Helpers.lua's sync helper is for other callers only.
---
---WHAT IS VERIFIED ON STAGING (2026-11-13, v0.7.19-era build):
---  * Read path works: GET /time returns the clock hour, minute, day, the game's
---    own street-lamp decision and each MTSunSky's derived SolarTime.
---  * Clock rate: Speed is a real-time multiplier. The stock world runs at 48
---    (one game day per 30 real minutes); measured 49x on a 20 s sample and the
---    config struct's default Speed reads back as 48.
---  * The stock dedicated-server world ships NO MTTimeOfDayConfig actor.
---  * The config actor is START-TIME ONLY. Spawning one at runtime and writing
---    TimeOfDayConfig{Start=22} or {Speed=0} is stored (the struct reads back the
---    written values) but the clock ignores it and keeps advancing at 48x. So
---    there is NO working runtime clock setter among the reflected primitives.
---  * Cheat_TimeOfDay does not work on the dedicated server (confirmed by the
---    club owner); AMTSunSky.SolarTime is DERIVED from the clock every frame, so
---    writing it is overwritten within a frame.
---  * Clients receive the clock by a periodic ClientSetTimeOfDay push every few
---    seconds, so a per-PC call is lag collapse for that sync, NOT a mechanism,
---    and an unprovoked broadcast strobes every player (night -> day, once per
---    sync). It is therefore gated behind a proven server-clock move, which on
---    this build never happens — the call is kept for the day a mechanism exists.
---
---CONSEQUENCE: these endpoints are an instrument, not yet a working /night.
---  Every apply reports before / short sample / settle sample / Held, so the day
---  a mechanism lands (a map-authored config actor, or a native hook on the clock
---  tick) the API contract is already in place and the verdict proves it. The
---  backend chat commands are deliberately NOT wired until then.

local UEHelpers = require("UEHelpers")
local json = require("JsonParser")

---Generation guard: a hot reload runs main.lua again while the previous copy's
---delayed sample callbacks are still alive. rawget/rawset, never `_G.<name>`:
---the repo smoke harness stubs unknown globals with a table, so a plain index
---returns that stub and `+ 1` throws.
local previousGen = rawget(_G, "__TimeManagerGen")
local GEN = (type(previousGen) == "number" and previousGen or 0) + 1
rawset(_G, "__TimeManagerGen", GEN)

local SHORT_SAMPLE_MS = 2500    -- first sample after an apply
local SETTLE_SAMPLE_MS = 15000  -- settle sample, exceeds the client sync period
local EPS_HOUR = 0.01           -- ~36 s of clock drift; sample/sync tolerance
local SCAN_TTL_S = 10           -- actor-list cache; FindAllOf is a GObjects walk

local sampleSeq = 0
local verification = nil

local configActorCache = nil
local sunSkyCache = nil
local lastScanAt = nil

---------------------------------------------------------------------------
-- primitives (handlers run on the game thread — see header)
---------------------------------------------------------------------------

---Resolve a static BlueprintLibrary function host. A static UFUNCTION has no
---instance; the CDO is the callable object, with the UClass as a fallback.
local function GetBlueprintLibrary()
  local cdo = StaticFindObject("/Script/MotorTown.Default__MTBlueprintLibrary")
  if cdo then return cdo end
  return StaticFindObject("/Script/MotorTown.MTBlueprintLibrary")
end

---@return number|nil hour, string|nil error
local function ReadTimeOfDay()
  local lib = GetBlueprintLibrary()
  if not lib then return nil, "MTBlueprintLibrary not found" end
  local gs = GetMotorTownGameState()
  if not gs:IsValid() then return nil, "GameState not valid" end
  local ok, value = pcall(function() return lib:GetTimeOfDay(gs) end)
  if not ok then return nil, tostring(value) end
  local hour = tonumber(value)
  if hour == nil then return nil, "GetTimeOfDay returned " .. tostring(value) end
  return hour, nil
end

---@return boolean|nil lampOn the game's own day/night decision
local function ReadStreetLamp()
  local lib = GetBlueprintLibrary()
  if not lib then return nil end
  local gs = GetMotorTownGameState()
  if not gs:IsValid() then return nil end
  local ok, value = pcall(function() return lib:IsTurnOnStreetLamp(gs) end)
  if not ok then return nil end
  return value and true or false
end

---Actor lists are cached: the two FindAllOf calls measured ~106 ms on staging,
---too much for a 1 Hz ops poll.
local function RefreshScan()
  local now = os.time()
  if configActorCache ~= nil and lastScanAt ~= nil
      and (now - lastScanAt) < SCAN_TTL_S then
    return
  end
  configActorCache = {}
  local actors = FindAllOf("MTTimeOfDayConfig")
  if actors then
    for _, actor in ipairs(actors) do
      local ok, valid = pcall(function() return actor:IsValid() end)
      if ok and valid then
        configActorCache[#configActorCache + 1] = actor
      end
    end
  end
  sunSkyCache = {}
  local suns = FindAllOf("MTSunSky")
  if suns then
    for _, sun in ipairs(suns) do
      local ok, valid = pcall(function() return sun:IsValid() end)
      if ok and valid then
        sunSkyCache[#sunSkyCache + 1] = sun
      end
    end
  end
  lastScanAt = now
end

---The struct value comes back as a UScriptStruct handle on this build, not a Lua
---table, so each field is probed with pcall instead of being indexed as a table.
---@param actor UObject
---@return number|nil start, number|nil speed
local function ReadConfigStruct(actor)
  local ok, cfg = pcall(function() return actor.TimeOfDayConfig end)
  if not ok or cfg == nil then return nil, nil end
  local start, speed = nil, nil
  local okS, v = pcall(function() return cfg.Start end)
  if okS then start = tonumber(v) end
  local okP, w = pcall(function() return cfg.Speed end)
  if okP then speed = tonumber(w) end
  return start, speed
end

---@return table[] { actor=UObject, start=number|nil, speed=number|nil }
local function ConfigActors()
  RefreshScan()
  local result = {}
  for _, actor in ipairs(configActorCache or {}) do
    local start, speed = ReadConfigStruct(actor)
    result[#result + 1] = { actor = actor, start = start, speed = speed }
  end
  return result
end

---Write Start/Speed on every config actor. This is the only persistent store,
---and on this build the clock ignores it at runtime (see header) — the write is
---still performed because the sample is what proves or disproves that.
---@return number written, table values
local function ApplyConfig(hour, speed)
  local written = 0
  local values = {}
  for _, entry in ipairs(ConfigActors()) do
    local start = hour
    local rate = speed
    if start == nil then start = entry.start end
    if rate == nil then rate = entry.speed end
    local ok = pcall(function()
      -- struct property: assign the whole struct back, never mutate a copy
      entry.actor.TimeOfDayConfig = { Start = start, Speed = rate }
    end)
    if ok then
      written = written + 1
      values[#values + 1] = { Start = start, Speed = rate }
    else
      LogOutput("ERROR", "[TimeManager] config write failed on %s",
        tostring(entry.actor:GetFullName()))
    end
  end
  return written, values
end

---Collapse the client sync lag. Gated: only called after the settle sample
---proves the SERVER clock moved, because an unprovoked broadcast strobes every
---player once per sync. Kept for the day a working server-side setter exists.
---@return number sent
local function BroadcastToClients(hour, speed)
  local sent = 0
  local gs = GetMotorTownGameState()
  if not gs:IsValid() then return 0 end
  pcall(function()
    gs.PlayerArray:ForEach(function(_, element)
      local ps = element:get()
      if ps and ps:IsValid() then
        local okPc, pc = pcall(function() return ps:GetPlayerController() end)
        if okPc and pc and pc:IsValid() then
          local ok = pcall(function() pc:ClientSetTimeOfDay(hour, speed) end)
          if ok then sent = sent + 1 end
        end
      end
    end)
  end)
  LogOutput("INFO", "[TimeManager] ClientSetTimeOfDay(%s, %s) -> %d client(s)",
    tostring(hour), tostring(speed), sent)
  return sent
end

---------------------------------------------------------------------------
-- verification: two samples after an apply, on the game thread
---------------------------------------------------------------------------

local function FinishVerification(record)
  local hour = ReadTimeOfDay()
  record.SettleSample = hour
  record.Completed = true

  local moved = false
  if record.Before ~= nil and hour ~= nil then
    moved = math.abs(hour - record.Before) > EPS_HOUR
  end

  local held = nil
  if record.WantedHour ~= nil and hour ~= nil then
    -- A held hour equals the request, or has advanced from it by no more than
    -- the settle window allows (~0.2 h at the stock 48x rate).
    local drift = math.abs(hour - record.WantedHour)
    if drift > 12.0 then drift = 24.0 - drift end
    held = drift <= EPS_HOUR
  elseif record.WantedSpeed == 0 and record.Before ~= nil and hour ~= nil then
    -- Speed 0 must freeze the clock: any advance disproves it.
    held = math.abs(hour - record.Before) <= EPS_HOUR
  end
  record.Held = held
  record.Moved = moved

  if held and moved and record.Broadcast ~= false and record.WantedHour ~= nil then
    record.BroadcastSent = BroadcastToClients(hour, record.WantedSpeed)
  end

  LogOutput("INFO",
    "[TimeManager] verify #%d wanted=%s before=%s short=%s settle=%s held=%s moved=%s",
    record.Id, tostring(record.WantedHour), tostring(record.Before),
    tostring(record.ShortSample), tostring(hour), tostring(held), tostring(moved))
end

---@param record table verification record (WantedHour/WantedSpeed/Before)
local function ScheduleVerification(record)
  sampleSeq = sampleSeq + 1
  record.Id = sampleSeq
  verification = record
  local mySeq = sampleSeq
  local myGen = GEN

  ExecuteInGameThreadWithDelay(SHORT_SAMPLE_MS, function()
    if GEN ~= myGen or sampleSeq ~= mySeq then return end
    record.ShortSample = ReadTimeOfDay()
  end)

  ExecuteInGameThreadWithDelay(SETTLE_SAMPLE_MS, function()
    if GEN ~= myGen or sampleSeq ~= mySeq then return end
    FinishVerification(record)
  end)
end

---------------------------------------------------------------------------
-- request handlers
---------------------------------------------------------------------------

local function ParseBody(session)
  if not session.content or session.content == "" then return nil end
  local ok, parsed = pcall(json.parse, session.content)
  if not ok or type(parsed) ~= "table" then return nil end
  return parsed
end

---GET /time — pure read, never mutates.
---@type RequestPathHandler
local function HandleGetTime(session)
  local data = {}
  local hour, err = ReadTimeOfDay()
  data.Hour = hour
  data.Error = err
  data.IsStreetLampOn = ReadStreetLamp()

  local skies = {}
  RefreshScan()
  for _, sun in ipairs(sunSkyCache or {}) do
    local entry = {}
    local okT, solar = pcall(function() return sun.SolarTime end)
    entry.SolarTime = okT and tonumber(solar) or nil
    local okD, day = pcall(function() return sun.Day end)
    entry.Day = okD and tonumber(day) or nil
    local okM, month = pcall(function() return sun.Month end)
    entry.Month = okM and tonumber(month) or nil
    skies[#skies + 1] = entry
  end
  data.SunSkies = skies

  local configs = {}
  for _, entry in ipairs(ConfigActors()) do
    configs[#configs + 1] = { Start = entry.start, Speed = entry.speed }
  end
  data.ConfigActors = configs
  data.ConfigActorCount = #configs
  data.Verification = verification

  if hour then
    local whole = math.floor(hour)
    data.HourWhole = whole
    data.Minute = math.floor((hour - whole) * 60)
  end
  return { data = data }, nil, 200
end

---POST /time — body {"Hour": 22, "Speed": 1, "Broadcast": true}.
---Applies now, returns before/applied; the two samples land later, read them
---from GET /time -> data.Verification.
---@type RequestPathHandler
local function HandleSetTime(session)
  local body = ParseBody(session)
  if body == nil then
    return { error = "Invalid or missing JSON body" }, nil, 400
  end

  local hour = tonumber(body.Hour)
  local speed = tonumber(body.Speed)
  if hour == nil and speed == nil then
    return { error = "Hour or Speed required" }, nil, 400
  end
  if hour ~= nil and (hour < 0 or hour > 24) then
    return { error = "Hour out of range (0-24)" }, nil, 400
  end
  if speed ~= nil and (speed < 0 or speed > 600) then
    return { error = "Speed out of range (0-600; 48 = stock, 0 = frozen)" }, nil, 400
  end

  local result = { Hour = hour, Speed = speed }
  result.Before = ReadTimeOfDay()

  local written, values = ApplyConfig(hour, speed)
  result.ConfigActorsWritten = written
  result.ConfigValues = values
  result.Mechanism = written > 0 and "config_actor" or "none"
  if written == 0 then
    result.Note = "no MTTimeOfDayConfig actor in the world (stock dedicated server) " ..
      "and the actor is start-time only, so no runtime setter exists on this build"
  end

  ScheduleVerification({
    Kind = "set",
    WantedHour = hour,
    WantedSpeed = speed,
    Before = result.Before,
    Broadcast = body.Broadcast,
  })

  LogOutput("INFO", "[TimeManager] set hour=%s speed=%s before=%s actors=%d",
    tostring(hour), tostring(speed), tostring(result.Before), written)

  return {
    status = written > 0 and "applied" or "no_mechanism",
    data = result,
    sample = { ShortMs = SHORT_SAMPLE_MS, SettleMs = SETTLE_SAMPLE_MS },
    readBack = "GET /time -> data.Verification",
  }, nil, 200
end

---POST /time/offset — body {"Hours": 2}. Relative shift, read-modify-write with
---wrap at 24 h.
---@type RequestPathHandler
local function HandleOffsetTime(session)
  local body = ParseBody(session)
  local delta = body and tonumber(body.Hours)
  if delta == nil then
    return { error = "Hours required" }, nil, 400
  end

  local before, err = ReadTimeOfDay()
  if before == nil then
    return { error = "Clock unreadable: " .. tostring(err) }, nil, 409
  end
  local target = (before + delta) % 24
  if target < 0 then target = target + 24 end

  local written, values = ApplyConfig(target, nil)
  local result = {
    Before = before,
    Delta = delta,
    Applied = target,
    ConfigActorsWritten = written,
    ConfigValues = values,
    Mechanism = written > 0 and "config_actor" or "none",
  }
  ScheduleVerification({
    Kind = "offset",
    WantedHour = target,
    Before = before,
    Broadcast = body.Broadcast,
  })
  return {
    status = written > 0 and "applied" or "no_mechanism",
    data = result,
    readBack = "GET /time -> data.Verification",
  }, nil, 200
end

---POST /time/speed — body {"Speed": 0} freeze, {"Speed": 48} stock.
---Speed is a real-time multiplier and it persists in the world save, so this is
---the operation that needs a restore; PreviousSpeed is read before writing.
---@type RequestPathHandler
local function HandleSetTimeSpeed(session)
  local body = ParseBody(session)
  local speed = body and tonumber(body.Speed)
  if speed == nil then
    return { error = "Speed required" }, nil, 400
  end
  if speed < 0 or speed > 600 then
    return { error = "Speed out of range (0-600; 48 = stock, 0 = frozen)" }, nil, 400
  end

  local before = ReadTimeOfDay()
  local previous = nil
  for _, entry in ipairs(ConfigActors()) do
    if entry.speed ~= nil then previous = entry.speed end
  end
  local written, values = ApplyConfig(nil, speed)
  local result = {
    Speed = speed,
    PreviousSpeed = previous,
    Before = before,
    ConfigActorsWritten = written,
    ConfigValues = values,
    Mechanism = written > 0 and "config_actor" or "none",
    RestoreHint = speed == 0 and "restore with POST /time/speed {\"Speed\":<PreviousSpeed>}"
      or nil,
  }
  ScheduleVerification({
    Kind = "speed",
    WantedSpeed = speed,
    Before = before,
    Broadcast = body.Broadcast,
  })
  LogOutput("INFO", "[TimeManager] speed=%s (was %s) applied to %d actor(s), before=%s",
    tostring(speed), tostring(previous), written, tostring(before))
  return {
    status = written > 0 and "applied" or "no_mechanism",
    data = result,
    readBack = "GET /time -> data.Verification",
  }, nil, 200
end

return {
  HandleGetTime = HandleGetTime,
  HandleSetTime = HandleSetTime,
  HandleOffsetTime = HandleOffsetTime,
  HandleSetTimeSpeed = HandleSetTimeSpeed,
}
