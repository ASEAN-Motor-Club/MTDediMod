-- Regression harness for the event-update path (Task B1: 1-based TArray write).
-- Runs with plain Lua 5.4:  lua test/event_manager_update_spec.lua
-- Stubs the UE4SS globals, loads the real Scripts/EventManager.lua and drives
-- the exported HandleUpdateEvent. Every write to a race waypoint TArray is
-- logged, so a 0-based write (Waypoints[index - 1]) is caught even though Lua
-- tables tolerate index 0 while a real UE TArray raises "index out of range".

local scriptDir = (arg and arg[0] and arg[0]:match("^(.*)/[^/]+$")) or "."
local root = scriptDir .. "/.."
package.path = root .. "/Scripts/?.lua;" .. package.path

local validStub = {}
validStub.IsValid = function() return true end
validStub.IsA = function() return true end
setmetatable(validStub, { __index = function() return function() return validStub end end })

package.preload["UEHelpers"] = function()
  return {
    GetGameInstance = function() return validStub end,
    GetPlayerController = function() return validStub end,
    GetGameStateBase = function() return validStub end,
    GetKismetSystemLibrary = function() return validStub end,
    GetKismetMathLibrary = function() return validStub end,
  }
end
package.preload["socket"] = function()
  return {
    sleep = function() end,
    gettime = function() return os.clock() end,
    bind = function() return { getsockname = function() return "127.0.0.1", 0 end, settimeout = function() end, accept = function() return nil end } end,
    select = function() return nil, nil, "timeout" end,
  }
end
package.preload["mime"] = function() return { b64 = function(s) return s end } end

function RequireSafe(name)
  if name == "cjson" then return nil end -- JsonParser has a pure-Lua fallback
  return require(name)
end
function RegisterHook(...) end
function RegisterConsoleCommandHandler(...) end
function RegisterKeyBind(...) end
function LogOutput(...) end
function ExecuteInGameThread(fn) fn() end
function EnqueueWebhookEvent(...) end
function GetPlayerGuid(...) return "E603C74946EFF3F8834C9AAB3D0E3181" end
function GetPlayerUniqueId(...) return "76561198378447512" end
function CreateInvalidObject()
  return setmetatable({}, { __index = function() return function() end end })
end
function StaticFindObject(...) return {} end
Key = setmetatable({}, { __index = function(_, k) return k end })
ModifierKey = setmetatable({}, { __index = function(_, k) return k end })

local function newArray()
  return setmetatable({}, {
    __index = {
      Empty = function(a) for i = #a, 1, -1 do a[i] = nil end end,
      ForEach = function(a, fn)
        for i, v in ipairs(a) do fn(i - 1, { get = function() return v end }) end
      end,
    },
  })
end

-- TArray stand-in that records every numeric index written. __newindex fires
-- on the 1..N writes (the array is emptied first) AND on a stray index 0.
local function newTrackingArray(log)
  return setmetatable({}, {
    __index = {
      Empty = function(a) for i = #a, 1, -1 do a[i] = nil end end,
      ForEach = function(a, fn)
        for i, v in ipairs(a) do fn(i - 1, { get = function() return v end }) end
      end,
    },
    __newindex = function(t, k, v)
      if type(k) == "number" then log[#log + 1] = k end
      rawset(t, k, v)
    end,
  })
end

function gstr(s)
  return setmetatable({}, { __index = { ToString = function() return s end } })
end
function FName(s) return gstr(s) end

local function guid(s) return { __nativeGuid = true, str = s } end
function StringToGuid(s)
  local p = {}
  for i = 1, 32, 8 do p[#p+1] = tonumber((s or "00000000000000000000000000000000"):sub(i, i+7), 16) end
  return { A=p[1], B=p[2], C=p[3], D=p[4] }
end
function GuidToString(g)
  if type(g) == "table" and g.__nativeGuid then return g.str end
  return "0000"
end

dofile(root .. "/Scripts/Helpers.lua")
-- Helpers.lua redefines the guid helpers; re-assert the test semantics.
function StringToGuid(s)
  local p = {}
  for i = 1, 32, 8 do p[#p+1] = tonumber((s or "00000000000000000000000000000000"):sub(i, i+7), 16) end
  return { A=p[1], B=p[2], C=p[3], D=p[4] }
end
function GuidToString(g)
  if type(g) == "table" and g.__nativeGuid then return g.str end
  return "0000"
end
-- GetEvents() is called on the success path; keep the conversion shallow.
TransformToTable = function(t)
  return { Location = t.Translation, Rotation = t.Rotation, Scale3D = t.Scale3D }
end
RouteToTable = function(route)
  local name = route.RouteName
  if type(name) == "table" and name.ToString then name = name:ToString() end
  return { RouteName = name or "", Waypoints = {} }
end

local netEvents = newArray()
local EventSystem = {}
function EventSystem:IsValid() return true end
function EventSystem:IsA() return true end
EventSystem.Net_Events = netEvents
function GetMotorTownGameState()
  return { IsValid = function() return true end, Net_EventSystem = EventSystem }
end

local writeLog = {}
local function fullGameEvent(guidStr, name)
  return {
    EventGuid = guid(guidStr),
    EventName = gstr(name),
    EventType = 1,
    OwnerCharacterId = {
      CharacterGuid = guid("E603C74946EFF3F8834C9AAB3D0E3181"),
      UniqueNetId = gstr("76561198378447512"),
    },
    Players = newArray(),
    bInCountdown = false,
    State = 1,
    RaceSetup = {
      NumLaps = 0,
      EngineKeys = newArray(),
      VehicleKeys = newArray(),
      Route = { RouteName = gstr(""), Waypoints = newTrackingArray(writeLog) },
    },
    CaptureTheFlagSetup = { ScoreToWin = 0, Route = {}, Slowness = 0 },
  }
end

local EM = dofile(root .. "/Scripts/EventManager.lua")
local json = require("JsonParser")

local TARGET = "5B11926A45D1869C3AA6309F3F564829"
local DECOY  = "00000000000000000000000000000001"

local failures = 0
local function check(name, cond)
  print((cond and "PASS " or "FAIL ") .. name)
  if not cond then failures = failures + 1 end
end

-- Build one waypoint per index with a unique marker so ordering is checkable.
local function waypoint(n)
  return {
    Translation = { X = n * 10, Y = 0, Z = 0 },
    Rotation = { X = 0, Y = 0, Z = 0, W = 1 },
    Scale3D = { X = 1, Y = 1, Z = 1 },
  }
end

local function toStr(v)
  if type(v) == "string" then return v end
  if type(v) == "table" and v.ToString then return v:ToString() end
  return tostring(v)
end

local function runUpdate(count, indexOfTarget)
  for i = #netEvents, 1, -1 do netEvents[i] = nil end
  for i = 1, indexOfTarget do
    local g = (i == indexOfTarget) and TARGET or DECOY
    netEvents[i] = fullGameEvent(g, "Event " .. i)
  end
  for i = #writeLog, 1, -1 do writeLog[i] = nil end

  local waypoints = {}
  for i = 1, count do waypoints[i] = waypoint(i) end
  local payload = {
    EventSetup = {
      NumLaps = 3,
      EngineKeys = {},
      VehicleKeys = {},
      Route = { RouteName = "Updated Route", Waypoints = waypoints },
    },
  }
  local session = { content = json.stringify(payload), pathComponents = {} }
  session.pathComponents[2] = TARGET

  local ok, response = pcall(function() return EM.HandleUpdateEvent(session) end)
  return ok, response, netEvents[indexOfTarget].RaceSetup.Route.Waypoints
end

local function assertOneBased(label, ok, response, wp, count)
  check(label .. ": handle succeeds", ok and type(response) == "table" and response.data ~= nil)
  check(label .. ": no write at index 0", (function()
    for _, k in ipairs(writeLog) do if k == 0 then return false end end
    return true
  end)())
  check(label .. ": #waypoints == " .. count, #wp == count)
  local seen = {}
  for _, k in ipairs(writeLog) do seen[k] = true end
  local exact = true
  for k in pairs(seen) do if type(k) ~= "number" or k < 1 or k > count then exact = false end end
  for i = 1, count do if not seen[i] then exact = false end end
  check(label .. ": writes exactly indices 1.." .. count, exact)
  local ordered = true
  for i = 1, count do
    if not wp[i] or type(wp[i].Translation) ~= "table" or wp[i].Translation.X ~= i * 10 then
      ordered = false
    end
  end
  check(label .. ": values land at 1-based positions", ordered)
end

-- Case 1: single waypoint on the first event.
local ok1, resp1, wp1 = runUpdate(1, 1)
assertOneBased("single", ok1, resp1, wp1, 1)

-- Case 2: three waypoints on the second event (decoy at index 1 untouched).
local ok2, resp2, wp2 = runUpdate(3, 2)
assertOneBased("multi", ok2, resp2, wp2, 3)
check("multi: decoy event waypoints untouched", #netEvents[1].RaceSetup.Route.Waypoints == 0)
check("multi: target RouteName updated", toStr(netEvents[2].RaceSetup.Route.RouteName) == "Updated Route")

print(failures == 0 and "RESULT: OK" or ("RESULT: FAIL (" .. failures .. ")"))
os.exit(failures == 0 and 0 or 1)
