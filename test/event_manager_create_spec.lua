-- Regression harness for the event-create path (prod 2026-11-27 TArray OOR).
-- Runs with plain Lua 5.4:  lua test/event_manager_create_spec.lua
-- Stubs the UE4SS globals, loads the real Scripts/EventManager.lua and drives
-- the exported HandleCreateNewEvent through the two race conditions that
-- produced "TArray index out of range" and silent wrong-event writes.

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

local function newArray(init)
  return setmetatable(init or {}, {
    __index = {
      Empty = function(a) for i = #a, 1, -1 do a[i] = nil end end,
      ForEach = function(a, fn)
        for i, v in ipairs(a) do fn(i - 1, { get = function() return v end }) end
      end,
    },
  })
end

function gstr(s)
  return setmetatable({}, { __index = { ToString = function() return s end } })
end
function FName(s) return gstr(s) end

local function guid(s) return { str = s } end
function StringToGuid(s) return guid(s or "00000000000000000000000000000000") end
function GuidToString(g)
  if type(g) == "table" and g.str then return g.str end
  return "00000000000000000000000000000000"
end

-- Helpers.lua supplies CharacterIdToTable / RewardToTable / RouteToTable.
dofile(root .. "/Scripts/Helpers.lua")
-- Its GuidToString rejects plain test tables, so re-assert our stubs.
function StringToGuid(s) return guid(s or "00000000000000000000000000000000") end
function GuidToString(g)
  if type(g) == "table" and g.str then return g.str end
  return "00000000000000000000000000000000"
end
-- Skip FVector/FQuat ToString conversion; this harness tests index selection.
TransformToTable = function(t)
  return { Location = t.Translation, Rotation = t.Rotation, Scale3D = t.Scale3D }
end
RouteToTable = function(route)
  local name = route.RouteName
  if type(name) == "table" and name.ToString then name = name:ToString() end
  return { RouteName = name or "", Waypoints = {} }
end

local netEvents = newArray()
local addBehavior = "append" -- append | defer | insert-first

local EventSystem = {}
function EventSystem:IsValid() return true end
function EventSystem:IsA() return true end
EventSystem.Net_Events = netEvents
function GetMotorTownGameState()
  return { IsValid = function() return true end, Net_EventSystem = EventSystem }
end

local noReward = { IsValid = function() return false end }
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
    Reward_Money = noReward,
    RaceSetup = {
      NumLaps = 0,
      EngineKeys = newArray(),
      VehicleKeys = newArray(),
      Route = { RouteName = gstr(""), Waypoints = newArray() },
    },
    CaptureTheFlagSetup = { ScoreToWin = 0, Route = {}, Slowness = 0 },
  }
end

local PC = {}
function PC:IsValid() return true end
function PC:ServerAddEvent(evt)
  if addBehavior == "defer" then return end
  local shaped = fullGameEvent(GuidToString(evt.EventGuid), "AMC Test")
  shaped.RaceSetup.NumLaps = evt.RaceSetup.NumLaps
  if addBehavior == "insert-first" then
    table.insert(netEvents, 1, shaped)
  else
    netEvents[#netEvents + 1] = shaped
  end
end
function PC:ServerSetEventRaceSetup(...) end
function GetPlayerControllerFromUniqueId(...) return PC end

local EM = dofile(root .. "/Scripts/EventManager.lua")
local json = require("JsonParser")

local GUID = "5B11926A45D1869C3AA6309F3F564829"
local payload = {
  EventGuid = GUID,
  EventName = "AMC Test",
  EventType = 1,
  OwnerCharacterId = {
    CharacterGuid = "E603C74946EFF3F8834C9AAB3D0E3181",
    UniqueNetId = "76561198378447512",
  },
  RaceSetup = {
    NumLaps = 2,
    VehicleKeys = { "Veh_01" },
    EngineKeys = {},
    Route = {
      RouteName = "Test Route",
      Waypoints = {
        {
          Translation = { X = 1, Y = 2, Z = 3 },
          Rotation = { X = 0, Y = 0, Z = 0, W = 1 },
          Scale3D = { X = 1, Y = 1, Z = 10 },
        },
      },
    },
  },
}
local session = { content = json.stringify(payload), pathComponents = {} }

local function reset(count)
  for i = #netEvents, 1, -1 do netEvents[i] = nil end
  for i = 1, count do
    netEvents[i] = fullGameEvent(string.format("%032X", i), "Existing " .. i)
  end
end

local function toStr(v)
  if type(v) == "string" then return v end
  if type(v) == "table" and v.ToString then return v:ToString() end
  return tostring(v)
end

local failures = 0
local function check(name, cond)
  print((cond and "PASS " or "FAIL ") .. name)
  if not cond then failures = failures + 1 end
end

-- 1. Empty server, add succeeds: setup must land on the created event.
reset(0)
addBehavior = "append"
local ok1, _, _, code1 = pcall(function() return EM.HandleCreateNewEvent(session) end)
check("append create returns 201", ok1 and code1 == 201)
check("setup on created event", toStr(netEvents[1].RaceSetup.Route.RouteName) == "Test Route")

-- 2. Deferred add (the prod race): clean failure, no index error.
reset(0)
addBehavior = "defer"
local ok2, _, _, code2 = pcall(function() return EM.HandleCreateNewEvent(session) end)
check("deferred add does not throw", ok2 == true)
check("deferred add returns 400", ok2 and code2 == 400)

-- 3. Concurrent insert at index 1: setup must follow the GUID, not #Net_Events.
reset(2)
addBehavior = "insert-first"
local ok3, _, _, code3 = pcall(function() return EM.HandleCreateNewEvent(session) end)
check("insert-first create returns 201", ok3 and code3 == 201)
check("setup on guid-matched event[1]", toStr(netEvents[1].RaceSetup.Route.RouteName) == "Test Route")
check("existing event[2] untouched", toStr(netEvents[2].RaceSetup.Route.RouteName) == "")

print(failures == 0 and "RESULT: OK" or ("RESULT: FAIL (" .. failures .. ")"))
os.exit(failures == 0 and 0 or 1)
