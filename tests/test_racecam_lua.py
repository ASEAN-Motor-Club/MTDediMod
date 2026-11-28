#!/usr/bin/env python3
"""Verification harness for the MTDediMod RaceCam runtime (Phases 1 & 2 + inbox).

Runs three classes of checks:
  1. Lua syntax: luac -p on every ClientScripts/RaceCam/*.lua, executed on the
     NixOS host via /opt/data/scripts/hostrun.sh + lua_syntax_check.sh.
  2. Static invariants: no hardcoded D: drive references; fail-closed token
     auth on every HTTP endpoint (incl. /api/inbox, /api/inbox_file,
     /api/my_pos); panel HTML comes from panel_ui.lua.
  3. Behavioural checks: real Lua 5.4 harnesses on the host exercise
     paths.ensure_token/read_token, live_events.list/current_event, init.lua
     plan hot-reload/status/flags, plus the inbox drop folder and local-pose
     endpoints (traversal rejection, size cap, exact file bodies, 503 fallback).

Run: python3 -m unittest discover -s tests -p 'test_racecam_lua.py' -v
"""

from __future__ import annotations

import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
RACECAM = REPO / "ClientScripts" / "RaceCam"
HTTP_PATH = RACECAM / "http.lua"
HOSTRUN = Path("/opt/data/scripts/hostrun.sh")
SYNTAX_CHECK = Path("/opt/data/scripts/lua_syntax_check.sh")
SCRATCH = Path("/opt/data/cache/scratch")


# Injected into the behavioural harness by test_lua_behaviour. DATA_DIR is a
# unique temp directory shared between this container and the NixOS host.
LUA_HARNESS = r'''
local DATA_DIR = "__DATA_DIR__"
local ROOT = "__REPO_ROOT__/ClientScripts"
package.path = ROOT .. "/?.lua;" .. ROOT .. "/?/init.lua;" .. package.path

local real_getenv = os.getenv
os.getenv = function(k)
  if k == "RACECAM_DIR" then return DATA_DIR end
  return real_getenv(k)
end

-- Minimal UE4SS / LuaSocket environment -------------------------------------
RequireSafe = function() return nil end
CreateInvalidObject = function() return { IsValid = function() return false end } end
FindAllOf = function() return {} end
FindFirstOf = function() return nil end
StaticFindObject = function() return nil end
GetCachedWorld = function() return CreateInvalidObject() end
LogOutput = function() end
LoopInGameThreadWithDelay = function() return true end
LoopInGameThreadAfterFrames = function() return true end
IsValid = function(o) return o ~= nil end
package.preload["socket"] = function()
  return { bind = function() error("socket.bind must not be called in this test") end }
end

local function fname(s) return { ToString = function() return s end } end
local function player(name, rank, dq)
  return { PlayerName = fname(name), Rank = rank, bDisqualified = dq or false }
end
local function wp(x, y, z, sy)
  return { Translation = { X = x, Y = y, Z = z }, Scale3D = { Y = sy } }
end

-- Two replicated events: one contains the local driver, one does not.
local EVENTS = {
  {
    EventGuid = { A = 1, B = 2, C = 3, D = 4 },
    EventName = fname("Aewol Sprint"),
    State = 2, bInCountdown = false,
    Players = { player("Alice", 1, false), player("LocalDriver", 2, false), player("DQ", 0, true) },
    RaceSetup = { Route = {
      RouteName = fname("Aewol"),
      Waypoints = { wp(100, 200, 300, 1.2), wp(400, 500, 600, 0) },
    } },
  },
  {
    EventGuid = { A = 9, B = 8, C = 7, D = 6 },
    EventName = fname("Quarry Rally"),
    State = 1, bInCountdown = true,
    Players = { player("Bob", 1, false) },
    RaceSetup = { Route = {
      RouteName = fname("Quarry"),
      Waypoints = { wp(1, 2, 3, 0.8) },
    } },
  },
}

GetMotorTownGameState = function()
  return {
    IsValid = function() return true end,
    Net_EventSystem = {
      IsValid = function() return true end,
      Net_Events = EVENTS,
    },
  }
end
GetMyPlayerController = function()
  return {
    IsValid = function() return true end,
    PlayerState = { IsValid = function() return true end, PlayerName = fname("LocalDriver") },
  }
end

-- paths.ensure_token / read_token --------------------------------------------
local Paths = require("RaceCam/paths")
local tok = Paths.ensure_token()
assert(type(tok) == "string" and #tok == 64 and tok:match("^%x+$"),
       "ensure_token must return 64 lowercase hex chars, got " .. tostring(tok))
assert(Paths.read_token() == tok, "read_token mismatch")
local f = io.open(Paths.token_path(), "w"); f:write("  \n\t "); f:close()
assert(Paths.ensure_token() == nil, "empty token file must NOT be overwritten (fail-closed)")
assert(Paths.read_token() == nil, "empty token must read as nil")
local f2 = io.open(Paths.token_path(), "w"); f2:write(tok); f2:close()
assert(Paths.read_token() == tok, "token not restored")

-- live_events.list / current_event -------------------------------------------
local LiveEvents = require("RaceCam/live_events")
local list = LiveEvents.list("LocalDriver")
assert(#list == 2, "expected 2 events, got " .. #list)
local e1, e2 = list[1], list[2]
assert(e1.name == "Aewol Sprint" and e1.route_name == "Aewol", "event/route name extraction")
assert(e1.state == 2 and e1.in_countdown == false, "state/countdown extraction")
assert(e1.is_member == true and e1.player_count == 3 and e1.waypoint_count == 2, "membership/counts")
assert(e1.leader_name == "Alice", "rank-1 leader expected, got " .. tostring(e1.leader_name))
assert(e1.waypoints[1].x == 100 and e1.waypoints[1].y == 200 and e1.waypoints[1].z == 300, "XYZ extraction")
assert(e1.waypoints[1].gate_m == 12, "Scale3D.Y=1.2 -> 12 m gate, got " .. tostring(e1.waypoints[1].gate_m))
assert(e1.waypoints[2].gate_m == 12, "non-positive scale -> 12 m default gate")
assert(e2.is_member == false and e2.leader_name == "Bob", "second event membership/leader")
assert(e2.waypoints[1].gate_m == 8, "Scale3D.Y=0.8 -> 8 m minimum gate")
local cur = LiveEvents.current_event("LocalDriver")
assert(cur and cur.name == "Aewol Sprint", "current_event must return the member event")
GetMotorTownGameState = nil
assert(#LiveEvents.list("LocalDriver") == 0, "no GameState -> empty list (must not crash)")
GetMotorTownGameState = function()
  return { IsValid = function() return true end, Net_EventSystem = CreateInvalidObject() }
end
assert(#LiveEvents.list("LocalDriver") == 0, "invalid EventSystem -> empty list (must not crash)")
GetMotorTownGameState = function()
  return {
    IsValid = function() return true end,
    Net_EventSystem = { IsValid = function() return true end, Net_Events = EVENTS },
  }
end

-- UE4SS TArray representation: ForEach passes a wrapper with :get().
local std_gs = GetMotorTownGameState
local function tarray(items)
  return {
    ForEach = function(self, cb)
      for i, v in ipairs(items) do cb(i - 1, { get = function() return v end }) end
    end,
  }
end
GetMotorTownGameState = function()
  return {
    IsValid = function() return true end,
    Net_EventSystem = {
      IsValid = function() return true end,
      Net_Events = tarray(EVENTS),
    },
  }
end
local wrapped = LiveEvents.list("LocalDriver")
assert(#wrapped == 2 and wrapped[1].leader_name == "Alice" and wrapped[1].waypoint_count == 2,
       "UE4SS ForEach wrapper must be unwrapped with :get()")
GetMotorTownGameState = std_gs

-- init.lua plan hot-reload / status / flags -----------------------------------
local Init = require("RaceCam/init")
local Core = require("RaceCam/core")
local Presets = require("RaceCam/presets")
local Engine = require("RaceCam/shot_engine")
assert(Init.panel_url(false) == "http://127.0.0.1:8767/#token=" .. tok, "panel_url")
assert(Init.panel_url(true) == "http://127.0.0.1:8767/#token=" .. tok .. "&autoload=current", "panel_url autoload")

Init.engine = Engine.new(Core, Presets, { shots = {} }, nil)
Init.engine.target_name = "Alice"
Init.engine.target_idx = 2
Core.rehearsal = true
local before = Init.engine
local saved, err = Init.reload_plan("smoke_plan",
  { source = { name = "Smoke" }, shots = { { id = "s1", kind = "follow" } } },
  { waypoints = {} })
assert(saved == "smoke_plan", "reload_plan failed: " .. tostring(err))
assert(Init.engine == before, "reload_plan must hot-swap in place (same engine object)")
assert(Init.engine.target_name == "Alice" and Init.engine.target_idx == 2, "target must survive reload")
assert(Core.rehearsal == true, "rehearsal must survive reload")
local pf = io.open(Paths.data_dir() .. "plan_smoke_plan.json"); assert(pf, "plan json not saved"); pf:close()
local rf = io.open(Paths.data_dir() .. "route_smoke_plan.json"); assert(rf, "route json not saved"); rf:close()
local af = io.open(Paths.data_dir() .. "active_plan.txt")
assert(af and af:read("*a") == "smoke_plan", "active_plan.txt not updated"); af:close()

local st = Init.status()
assert(st.armed == false and st.plan_id == "smoke_plan" and st.port == 8767, "status snapshot")
assert(st.current_event == "Aewol Sprint", "status.current_event: " .. tostring(st.current_event))
local plans = Init.list_plans()
assert(plans.active == "smoke_plan", "list_plans.active")
local found = false
for _, id in ipairs(plans.plans) do if id == "smoke_plan" then found = true end end
assert(found, "smoke_plan missing from plans_index.json")

local flags = Init.set_auto_flags({ auto_start = true, follow_leader = false })
assert(flags.auto_start == true and flags.follow_leader == false, "set_auto_flags")
assert(Init.panic_stop() == true, "panic_stop")

print("BEHAVIOR_OK")
'''


# Second host harness: exercises the three new authenticated endpoints against
# real files on disk. `Http._make_response` is the module's test seam.
LUA_INBOX_HARNESS = r'''
local DATA_DIR = "__DATA_DIR__"
local ROOT = "__REPO_ROOT__/ClientScripts"
package.path = ROOT .. "/?.lua;" .. ROOT .. "/?/init.lua;" .. package.path

local real_getenv = os.getenv
os.getenv = function(k)
  if k == "RACECAM_DIR" then return DATA_DIR end
  return real_getenv(k)
end

RequireSafe = function() return nil end
CreateInvalidObject = function() return { IsValid = function() return false end } end
FindAllOf = function() return {} end
FindFirstOf = function() return nil end
StaticFindObject = function() return nil end
GetCachedWorld = function() return CreateInvalidObject() end
LogOutput = function() end
LoopInGameThreadWithDelay = function() return true end
LoopInGameThreadAfterFrames = function() return true end
IsValid = function(o) return o ~= nil end
GetMyPlayerController = function() return { IsValid = function() return true end } end
local original_pc = GetMyPlayerController

package.preload["socket"] = function()
  return { bind = function() error("socket.bind must not be called in this test") end }
end

-- Minimal JsonParser so json_encode in http.lua emits inspectable JSON.
package.loaded["JsonParser"] = (function()
  local function encode(v)
    if type(v) == "table" then
      if #v > 0 then
        local parts = {}
        for _, x in ipairs(v) do parts[#parts + 1] = encode(x) end
        return "[" .. table.concat(parts, ",") .. "]"
      end
      local keys = {}
      for k in pairs(v) do keys[#keys + 1] = k end
      table.sort(keys)
      local parts = {}
      for _, k in ipairs(keys) do
        parts[#parts + 1] = '"' .. tostring(k) .. '":' .. encode(v[k])
      end
      return "{" .. table.concat(parts, ",") .. "}"
    elseif type(v) == "string" then
      return '"' .. v:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
    elseif type(v) == "boolean" then
      return tostring(v)
    end
    return tostring(v)
  end
  return { stringify = encode, parse = function() return nil end, null = {} }
end)()

local Paths = require("RaceCam/paths")
local Http = require("RaceCam/http")
local tok = Paths.ensure_token()
assert(type(tok) == "string" and #tok == 64, "token setup failed")

local function req(method, path, token_value)
  return Http._make_response({
    method = method or "GET", path = path,
    headers = token_value and { ["x-racecam-token"] = token_value } or {},
    body = "",
  })
end
local function status(resp) return tonumber(resp:match("^HTTP/1.1 (%d+)")) end
local function body(resp) return resp:match("\r\n\r\n(.*)$") or "" end
local function has(hay, needle) return hay:find(needle, 1, true) ~= nil end
local function write_file(path, content)
  local f = assert(io.open(path, "wb"))
  f:write(content)
  f:close()
end

-- paths.lua surface + auto-created inbox -------------------------------------
assert(Paths.inbox_dir() == Paths.data_dir() .. "inbox/", "inbox_dir() mismatch")
assert(Paths.drop_file() == Paths.data_dir() .. "drop_event.json", "drop_file() mismatch")
assert(Paths.ensure_dir(Paths.inbox_dir()), "ensure_dir() must succeed")
local idir = Paths.inbox_dir()
local probe = io.open(idir .. ".ensure_probe", "w")
assert(probe, "ensure_dir() did not create inbox dir")
probe:close()
os.remove(idir .. ".ensure_probe")

-- Fail-closed auth on all three new endpoints --------------------------------
for _, path in ipairs({ "/api/inbox", "/api/inbox_file?name=a.json", "/api/my_pos" }) do
  local r = req("GET", path, nil)
  assert(status(r) == 400 and has(body(r), "bad token"),
         "no-token must fail closed: " .. path .. " -> " .. tostring(status(r)))
  r = req("GET", path, "wrong-token")
  assert(status(r) == 400 and has(body(r), "bad token"),
         "bad-token must fail closed: " .. path)
end

-- GET /api/inbox listing -----------------------------------------------------
Http.set_inbox_files({ "a.json", "../evil.json", "sub/b.json", "evil.lua", "ok.json", "..json" })
local b = body(req("GET", "/api/inbox", tok))
assert(has(b, '"a.json"') and has(b, '"ok.json"'), "valid inbox files must be listed: " .. b)
assert(not has(b, "evil") and not has(b, "sub/") and not has(b, "..json"),
       "invalid inbox names must be filtered: " .. b)
assert(has(b, '"has_drop_file":false'), "has_drop_file must start false: " .. b)
write_file(Paths.drop_file(), '{"drop":true}')
b = body(req("GET", "/api/inbox", tok))
assert(has(b, '"has_drop_file":true'), "has_drop_file must turn true: " .. b)

-- GET /api/inbox_file: path traversal is rejected ----------------------------
for _, name in ipairs({
  "../racecam_token.txt", "sub/a.json", "a\\b.json", "evil.lua", "",
  "..%2Fracecam_token.txt", "a.json%00.txt",
}) do
  local r = req("GET", "/api/inbox_file?name=" .. name, tok)
  assert(status(r) == 400 and has(body(r), "invalid filename"),
         "traversal must be rejected: " .. name .. " -> " .. tostring(status(r)) .. " " .. body(r))
end

-- GET /api/inbox_file: valid / missing / oversized ---------------------------
write_file(idir .. "my_event.json", '{"event":"ok"}')
local r = req("GET", "/api/inbox_file?name=my_event.json", tok)
assert(status(r) == 200 and body(r) == '{"event":"ok"}',
       "valid inbox file must return exact 200 body: " .. tostring(status(r)) .. " " .. body(r))
r = req("GET", "/api/inbox_file?name=drop_event.json", tok)
assert(status(r) == 200 and body(r) == '{"drop":true}', "drop_event.json must be served: " .. body(r))
r = req("GET", "/api/inbox_file?name=missing.json", tok)
assert(status(r) == 404 and has(body(r), "not found"), "missing file must be 404")
write_file(idir .. "big.json", string.rep("x", 512 * 1024 + 10))
r = req("GET", "/api/inbox_file?name=big.json", tok)
assert(status(r) == 413 and has(body(r), "file too large"), "oversized file must be 413")

-- GET /api/my_pos: hook, pawn, camera, unavailable ---------------------------
Http._pos_provider = nil
r = req("GET", "/api/my_pos", tok)
assert(status(r) == 503 and has(body(r), '"ok":false')
       and has(body(r), "no local pawn or camera"), "no pose must be 503: " .. body(r))

Http._pos_provider = function() return { x = 12.5, y = -3, z = 100, yaw = 45 } end
r = req("GET", "/api/my_pos", tok)
local pb = body(r)
assert(status(r) == 200 and has(pb, '"ok":true') and has(pb, '"x":12.5')
       and has(pb, '"y":-3') and has(pb, '"z":100') and has(pb, '"yaw":45'),
       "provider pose must be 200 with all fields: " .. tostring(status(r)) .. " " .. pb)

Http._pos_provider = function() error("provider boom") end
r = req("GET", "/api/my_pos", tok)
assert(status(r) == 503, "a throwing provider must fall back safely")

Http._pos_provider = nil
GetMyPlayerController = function()
  return {
    IsValid = function() return true end,
    Pawn = {
      IsValid = function() return true end,
      K2_GetActorLocation = function() return { X = 1, Y = 2, Z = 3 } end,
      K2_GetActorRotation = function() return { Yaw = 90 } end,
    },
  }
end
r = req("GET", "/api/my_pos", tok)
assert(status(r) == 200 and has(body(r), '"x":1') and has(body(r), '"yaw":90'),
       "pawn pose fallback must work: " .. body(r))

GetMyPlayerController = function() return nil end
_G.PlayerCameraManager = {
  IsValid = function() return true end,
  GetCameraLocation = function() return { X = 7, Y = 8, Z = 9 } end,
  GetCameraRotation = function() return { Yaw = 270 } end,
}
r = req("GET", "/api/my_pos", tok)
assert(status(r) == 200 and has(body(r), '"x":7') and has(body(r), '"yaw":270'),
       "camera pose fallback must work: " .. body(r))
_G.PlayerCameraManager = nil
GetMyPlayerController = original_pc

print("INBOX_OK")
'''


# Third host harness: live standings sorting/compact snapshot, the new
# /api/state `standings` field, and auto-disengage on manual /api/target.
LUA_STANDINGS_HARNESS = r'''
local DATA_DIR = "__DATA_DIR__"
local ROOT = "__REPO_ROOT__/ClientScripts"
package.path = ROOT .. "/?.lua;" .. ROOT .. "/?/init.lua;" .. package.path

local real_getenv = os.getenv
os.getenv = function(k)
  if k == "RACECAM_DIR" then return DATA_DIR end
  return real_getenv(k)
end

RequireSafe = function() return nil end
CreateInvalidObject = function() return { IsValid = function() return false end } end
FindAllOf = function() return {} end
FindFirstOf = function() return nil end
StaticFindObject = function() return nil end
GetCachedWorld = function() return CreateInvalidObject() end
LogOutput = function() end
LoopInGameThreadWithDelay = function() return true end
LoopInGameThreadAfterFrames = function() return true end
IsValid = function(o) return o ~= nil end
package.preload["socket"] = function()
  return { bind = function() error("socket.bind must not be called in this test") end }
end

-- JsonParser stub: state_json builds its JSON by hand; /api/target uses
-- json_field, so a minimal stringify is enough for the other routes.
package.loaded["JsonParser"] = (function()
  local function encode(v)
    if type(v) == "table" then
      if #v > 0 then
        local parts = {}
        for _, x in ipairs(v) do parts[#parts + 1] = encode(x) end
        return "[" .. table.concat(parts, ",") .. "]"
      end
      local keys, parts = {}, {}
      for k in pairs(v) do keys[#keys + 1] = k end
      table.sort(keys)
      for _, k in ipairs(keys) do parts[#parts + 1] = '"' .. tostring(k) .. '":' .. encode(v[k]) end
      return "{" .. table.concat(parts, ",") .. "}"
    elseif type(v) == "string" then
      return '"' .. v:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
    elseif type(v) == "boolean" then
      return tostring(v)
    end
    return tostring(v)
  end
  return { stringify = encode, parse = function() return nil end, null = {} }
end)()

local function fname(s) return { ToString = function() return s end } end
local function player(name, rank, laps, section, best, last, finished, dq)
  return {
    PlayerName = fname(name), Rank = rank,
    Laps = laps, SectionIndex = section,
    BestLapTime = best, LastSectionTotalTimeSeconds = last,
    bFinished = finished or false, bDisqualified = dq or false,
  }
end
local function wp(x, y, z, sy)
  return { Translation = { X = x, Y = y, Z = z }, Scale3D = { Y = sy } }
end

-- Deliberately shuffled: P2, DQ, P1, finished-P3. Expected order P1,P2,P3,DQ.
local EVENTS = {
  {
    EventGuid = { A = 1, B = 2, C = 3, D = 4 },
    EventName = fname("Grand Final"),
    State = 3, bInCountdown = false,
    Players = {
      player("P2", 2, 3, 5, 90.5, 180.0, false, false),
      player("DQ", 0, 1, 2, 88.0, 60.0, false, true),
      player("P1", 1, 4, 6, 88.2, 240.0, false, false),
      player("P3", 3, 5, 7, 87.0, 300.0, true, false),
    },
    RaceSetup = {
      NumLaps = 5,
      Route = {
        RouteName = fname("Coast"),
        Waypoints = { wp(1, 2, 3, 1.0), wp(4, 5, 6, 1.0) },
      },
    },
  },
}
GetMotorTownGameState = function()
  return {
    IsValid = function() return true end,
    Net_EventSystem = { IsValid = function() return true end, Net_Events = EVENTS },
  }
end
-- Local driver is a spectator (not one of the four contestants), which also
-- exercises the active_standings fallback to the first populated race.
GetMyPlayerController = function()
  return {
    IsValid = function() return true end,
    PlayerState = { IsValid = function() return true end, PlayerName = fname("Spectator") },
  }
end

local LiveEvents = require("RaceCam/live_events")
local evs = LiveEvents.list("Spectator")
assert(#evs == 1, "expected one event, got " .. tostring(#evs))
local ev = evs[1]
assert(ev.num_laps == 5, "num_laps must be read from RaceSetup.NumLaps, got " .. tostring(ev.num_laps))
local order = {}
for i, r in ipairs(ev.standings) do order[i] = r.name end
assert(table.concat(order, ",") == "P1,P2,P3,DQ",
       "standings sort order wrong: " .. table.concat(order, ","))
local p1 = ev.standings[1]
assert(p1.rank == 1 and p1.name == "P1" and p1.laps == 4 and p1.section == 6
       and p1.best_lap_s == 88.2 and p1.last_sec_s == 240.0
       and p1.finished == false and p1.disqualified == false,
       "P1 standings fields wrong: " .. tostring(p1.name))
assert(ev.standings[3].name == "P3" and ev.standings[3].finished == true,
       "finished-P3 must be third with finished=true")
assert(ev.standings[4].name == "DQ" and ev.standings[4].disqualified == true,
       "DQ must be last with disqualified=true")

LiveEvents.clear_cache()
local active = LiveEvents.active_standings("Spectator")
assert(active ~= nil, "active_standings must find the spectated race")
assert(active.event_name == "Grand Final" and type(active.event_guid) == "string"
       and #active.event_guid > 0, "compact snapshot identity fields")
assert(active.state == 3 and active.in_countdown == false and active.num_laps == 5
       and active.waypoint_count == 2, "compact snapshot race fields")
assert(#active.standings == 4 and active.standings[1].name == "P1", "compact snapshot standings")
assert(active.waypoints == nil, "active_standings must NOT copy waypoints[]")

local Init = require("RaceCam/init")
local Http = require("RaceCam/http")
local Paths = require("RaceCam/paths")
local tok = Paths.ensure_token()
assert(type(tok) == "string" and #tok == 64, "token setup failed")

_G.RACECAM_SHOTS = {
  target_name = nil,
  list_targets = function() return { "P1", "P2", "P3" } end,
  set_target_by_name = function(self, name)
    self.target_name = name
    return true, "target " .. name
  end,
}
Init.follow_leader = true

local function req(method, path, token_value, request_body)
  return Http._make_response({
    method = method or "GET", path = path,
    headers = token_value and { ["x-racecam-token"] = token_value } or {},
    body = request_body or "",
  })
end
local function status(resp) return tonumber(resp:match("^HTTP/1.1 (%d+)")) end
local function body(resp) return resp:match("\r\n\r\n(.*)$") or "" end
local function has(hay, needle) return hay:find(needle, 1, true) ~= nil end

local r = req("GET", "/api/state", tok)
local b = body(r)
assert(status(r) == 200, "GET /api/state failed: " .. tostring(status(r)))
assert(has(b, '"standings":[{"rank":1,"name":"P1"'),
       "/api/state must include sorted standings: " .. b)
for _, needle in ipairs({
  '"laps":4', '"section":6', '"best_lap_s":88.2', '"last_sec_s":240',
  '"finished":false', '"disqualified":false', '"finished":true', '"disqualified":true',
  '"event_name":"Grand Final"', '"num_laps":5', '"waypoint_count":2',
}) do
  assert(has(b, needle), "/api/state standings missing " .. needle .. ": " .. b)
end
assert(not has(b, '"waypoints"'), "/api/state must not include waypoints: " .. b)
assert(has(b, '"follow_leader":true'), "follow_leader must start on: " .. b)

local r2 = req("POST", "/api/target", tok, '{"name":"P3"}')
assert(status(r2) == 200 and has(body(r2), '"ok":true'),
       "POST /api/target must succeed: " .. tostring(status(r2)) .. " " .. body(r2))
local r3 = req("GET", "/api/state", tok)
assert(status(r3) == 200 and has(body(r3), '"follow_leader":false'),
       "manual /api/target must disengage follow_leader: " .. body(r3))

print("STANDINGS_OK")
'''


# Shared prelude for the five Stage-1/Stage-2 smoothing harnesses. The engine's
# clock is injected (`T`) so every test is fully deterministic under Lua 5.4.
SMOOTHING_PRELUDE = r'''
local DATA_DIR = "__DATA_DIR__"
local ROOT = "__REPO_ROOT__/ClientScripts"
package.path = ROOT .. "/?.lua;" .. ROOT .. "/?/init.lua;" .. package.path

local real_getenv = os.getenv
os.getenv = function(k)
  if k == "RACECAM_DIR" then return DATA_DIR end
  return real_getenv(k)
end

RequireSafe = function() return nil end
CreateInvalidObject = function() return { IsValid = function() return false end } end
FindAllOf = function() return {} end
FindFirstOf = function() return nil end
StaticFindObject = function() return nil end
GetCachedWorld = function() return CreateInvalidObject() end
LogOutput = function() end
LoopInGameThreadWithDelay = function() return true end
LoopInGameThreadAfterFrames = function() return true end
IsValid = function(o) return o ~= nil end
package.preload["socket"] = function()
  return { bind = function() error("socket.bind must not be called in this test") end }
end

local Presets = require("RaceCam/presets")
local Engine = require("RaceCam/shot_engine")
local verr = Presets.validate()
assert(#verr == 0, "presets.validate: " .. table.concat(verr, ";"))

local Core = { apply_pose = function() end, rehearsal = true }
local T = 0.0
local pawn = { _x = 0.0, _y = 0.0, _z = 0.0, _yaw = 0.0 }
function pawn:K2_GetActorLocation() return { X = self._x, Y = self._y, Z = self._z } end
function pawn:K2_GetActorRotation() return { Yaw = self._yaw } end
local function move(x, y, z) pawn._x, pawn._y, pawn._z = x, y or 0.0, z or 0.0 end
local function new_engine(shot)
  local e = Engine.new(Core, Presets, { shots = { shot } }, nil)
  e.clock = function() return T end
  e.target = pawn
  return e
end
local function pose_dist(a, b)
  local s = 0.0
  for i = 1, 3 do
    s = s + (a.pos[i] - b.pos[i])^2 + (a.look[i] - b.look[i])^2
  end
  return math.sqrt(s)
end
local DT60 = 1.0 / 60.0
'''

# 1. dt-invariance: identical 0.5 s convergence at 30 / 60 / 120 FPS.
SMOOTH_DT_HARNESS = r'''
local shot = { id = "f1", kind = "follow", preset = "chase_close" }
local function run(fps)
  T = 0.0
  local e = new_engine(shot)
  move(0, 0, 0); pawn._yaw = 0
  e:pose_of(shot) -- first tick snaps the estimator + rig
  e.follow_pos = { 0.0, -3000.0, 0.0 }
  e.follow_look = { 0.0, -3000.0, 0.0 }
  local dt = 1.0 / fps
  local p
  for _ = 1, math.floor(0.5 * fps) do T = T + dt; p = e:pose_of(shot) end
  return p
end
local p30, p60, p120 = run(30), run(60), run(120)
local d1, d2 = pose_dist(p30, p60), pose_dist(p30, p120)
-- 3% of the ~3000 cm transient amplitude is 90 cm; real result is ~1e-6 cm.
assert(d1 < 90.0 and d2 < 90.0,
  string.format("dt-invariance failed: d(30,60)=%.6f d(30,120)=%.6f", d1, d2))
print(string.format("SMOOTH_DT_OK d30_60=%.6f d30_120=%.6f", d1, d2))
'''

# 2. 15 Hz stepped + +-80 cm noisy packets at 60 FPS: aim jitter must drop >65%.
SMOOTH_JITTER_HARNESS = r'''
local shot = { id = "f2", kind = "follow", preset = "chase_close" }
T = 0.0
local e = new_engine(shot)
move(0, 0, 0); pawn._yaw = 0
local v = 2000.0
local seed = 12345
local function noise()
  seed = (seed * 48271) % 2147483647
  return (seed % 161) - 80
end
local raws = {}
local raw = { 0.0, 0.0, 0.0 }
for i = 1, 240 do
  if (i - 1) % 4 == 0 then -- every 4th frame = 15 Hz network packets
    local t = (i - 1) * DT60
    raw = { v * t + noise(), noise(), 0.0 }
  end
  raws[i] = raw
end
local looks = {}
for i = 1, 240 do
  local r = raws[i]
  move(r[1], r[2], r[3])
  T = T + DT60
  local p = e:pose_of(shot)
  looks[i] = { p.look[1], p.look[2], p.look[3] }
end
local function jitter(seq)
  local s = 0.0
  for i = 2, #seq - 1 do
    local ax = seq[i+1][1] - 2 * seq[i][1] + seq[i-1][1]
    local ay = seq[i+1][2] - 2 * seq[i][2] + seq[i-1][2]
    local az = seq[i+1][3] - 2 * seq[i][3] + seq[i-1][3]
    s = s + math.sqrt(ax * ax + ay * ay + az * az)
  end
  return s / (#seq - 2)
end
local raw_looks = {}
for i = 1, 240 do
  local r = raws[i]
  raw_looks[i] = { r[1] + 600.0, r[2], r[3] + 150.0 }
end
local j_raw, j_filt = jitter(raw_looks), jitter(looks)
local reduction = 1.0 - j_filt / j_raw
assert(reduction > 0.65,
  string.format("jitter reduction only %.4f (raw=%.3f filt=%.3f)", reduction, j_raw, j_filt))
print(string.format("SMOOTH_JITTER_OK reduction=%.4f raw=%.3f filt=%.3f", reduction, j_raw, j_filt))
'''

# 3. Alpha-beta predictor: zero steady-state lag on a 5000 cm/s car.
SMOOTH_LAG_HARNESS = r'''
local shot = { id = "f3", kind = "follow", preset = "chase_close" }
T = 0.0
local e = new_engine(shot)
move(0, 0, 0); pawn._yaw = 0
local v = 5000.0
for _ = 1, 180 do
  T = T + DT60
  move(v * T, 0, 0)
  e:pose_of(shot)
end
local f = e.tgt_filter
local lag = v * T - f.pos[1]
assert(math.abs(lag) < 50.0,
  string.format("steady-state lag %.2f cm exceeds 50 cm", lag))
assert(math.abs(f.vel[1] - v) < 200.0,
  string.format("velocity estimate %.2f does not converge to %.2f", f.vel[1], v))
print(string.format("SMOOTH_LAG_OK lag=%.3f vel=%.3f", lag, f.vel[1]))
'''

# 4. >25 m teleport / target cut snaps in one tick with no camera smear.
SMOOTH_SNAP_HARNESS = r'''
local shot = { id = "f4", kind = "follow", preset = "chase_close" }
T = 0.0
local e = new_engine(shot)
move(0, 0, 0); pawn._yaw = 0
for _ = 1, 30 do T = T + DT60; e:pose_of(shot) end
-- 50 m jump in one frame -> hard snap, not a 2.5 s pan across the map.
move(5000, 0, 0)
T = T + DT60
local p = e:pose_of(shot)
local f = e.tgt_filter
assert(math.abs(f.pos[1] - 5000.0) < 0.001
   and math.abs(f.pos[2]) < 0.001 and math.abs(f.pos[3]) < 0.001,
  string.format("teleport did not snap filter: %.3f,%.3f,%.3f", f.pos[1], f.pos[2], f.pos[3]))
assert(p.look[1] > 5000.0, "camera aim smeared across a teleport: " .. tostring(p.look[1]))
-- A different target actor must snap too (Alt+1 -> Alt+2 cut).
local other = { _x = 12000.0, _y = 0.0, _z = 0.0, _yaw = 0.0 }
function other:K2_GetActorLocation() return { X = self._x, Y = self._y, Z = self._z } end
function other:K2_GetActorRotation() return { Yaw = self._yaw } end
e.target = other
T = T + DT60
local p2 = e:pose_of(shot)
assert(math.abs(e.tgt_filter.pos[1] - 12000.0) < 0.001,
  "target actor switch did not snap: " .. tostring(e.tgt_filter.pos[1]))
assert(p2.look[1] > 12000.0, "aim smeared across a target switch")
print(string.format("SMOOTH_SNAP_OK jump_x=%.3f look_x=%.3f switch_x=%.3f",
  f.pos[1], p.look[1], e.tgt_filter.pos[1]))
'''

# 5. orbit / trackside_pan aim+fov smoothing, clean resets, smoothing modes.
SMOOTH_MODES_HARNESS = r'''
-- Orbit: aim chases the filtered target smoothly (no raw packet steps).
local orbit = { id = "o1", kind = "orbit", preset = "orbit_hero" }
T = 0.0
local eo = new_engine(orbit)
move(0, 0, 0); pawn._yaw = 0
eo:pose_of(orbit)
move(300, 0, 0)
local looks = {}
for _ = 1, 60 do T = T + DT60; looks[#looks + 1] = eo:pose_of(orbit).look[1] end
assert(looks[1] < 100.0 and looks[60] > 250.0,
  string.format("orbit aim not smooth: first=%.2f last=%.2f", looks[1], looks[60]))
-- Trackside pan: physical auto-zoom fov glides toward the new target (never
-- steps). The physical curve replaces the old 220000/dist heuristic.
local pan = { id = "p1", kind = "trackside_pan", location = { 0, 0, 0 }, preset = "trackside_low" }
T = 0.0
local ep = new_engine(pan)
move(4000, 0, 0); pawn._yaw = 0
local f0 = ep:pose_of(pan).fov
move(2000, 0, 0)
local fovs = {}
for _ = 1, 60 do T = T + DT60; fovs[#fovs + 1] = ep:pose_of(pan).fov end
assert(f0 > 25.0 and f0 < 30.0, "initial pan fov wrong: " .. tostring(f0))
assert(fovs[1] > f0 and fovs[10] < fovs[60] and fovs[60] > 45.0 and fovs[60] < 58.0,
  string.format("pan fov not smoothed: f0=%.2f f1=%.2f f10=%.2f f60=%.2f",
    f0, fovs[1], fovs[10], fovs[60]))
-- Modes: case-insensitive validation + multiplier applied to effective taus.
assert(Engine.set_smoothing_mode(ep, "TIGHT") == "tight" and ep.smoothing_scale == 0.5)
assert(Engine.set_smoothing_mode(ep, "normal") == "normal" and ep.smoothing_scale == 1.0)
assert(Engine.set_smoothing_mode(ep, "CINEMATIC") == "cinematic" and ep.smoothing_scale == 1.8)
local bad, msg = Engine.set_smoothing_mode(ep, "bogus")
assert(bad == nil and msg == "invalid mode", "invalid mode must be rejected")
local at = Engine.exp_alpha(DT60, 0.12 * 0.5)
local bn = Engine.exp_alpha(DT60, 0.12)
local cc = Engine.exp_alpha(DT60, 0.12 * 1.8)
assert(at > bn and bn > cc, "tight/normal/cinematic taus not ordered")
-- Clean reset: every smoothed field is cleared, next pose snaps (no smear).
ep:reset_smoothing()
assert(ep.follow_pos == nil and ep.follow_look == nil and ep.smooth_fov == nil and ep.tgt_filter == nil)
local cut = ep:pose_of(pan)
-- Post-reset first frame snaps to the physical fov at 20 m (~52 deg).
assert(math.abs(cut.look[1] - 2000.0) < 0.001 and cut.fov > 50.0 and cut.fov < 55.0,
  string.format("cut did not snap: look=%.2f fov=%.2f", cut.look[1], cut.fov))
-- activate() performs the same cut even when the new target is far away.
move(12000, 0, 0)
assert(ep:activate(orbit) == true, "activate(orbit) failed")
local oc = ep:pose_of(orbit)
assert(math.abs(oc.look[1] - 12000.0) < 1.0,
  "activate did not clear previous aim: " .. tostring(oc.look[1]))
-- Legacy plans using damping (no preset / no tau_*) still run.
T = 0.0
local legacy = { id = "l1", kind = "follow", damping = 0.12 }
local el = new_engine(legacy)
move(0, 0, 0)
for _ = 1, 30 do T = T + DT60; el:pose_of(legacy) end
assert(el.tgt_filter ~= nil, "legacy damping shot did not initialize the estimator")
print(string.format("SMOOTH_MODES_OK orbit=%.2f fov=%.2f cut=%.2f", looks[60], fovs[60], cut.look[1]))
'''

# Phase 1 (a): 16:9 viewport framing of the retuned follow presets.
FRAMING_HARNESS = r'''
-- Pinhole projection helper: nx/ny in [-1,+1], +/-1 == frame edge. UE's
-- FieldOfView is horizontal; vertical half-angle is derived from 16:9.
local function project(preset_id)
  local shot = { id = "p", kind = "follow", preset = preset_id }
  T = 0.0
  local e = new_engine(shot)
  move(0, 0, 0); pawn._yaw = 0
  local p = e:pose_of(shot)
  local fx, fy, fz = p.look[1] - p.pos[1], p.look[2] - p.pos[2], p.look[3] - p.pos[3]
  local fl = math.sqrt(fx * fx + fy * fy + fz * fz)
  fx, fy, fz = fx / fl, fy / fl, fz / fl
  local rx, ry = -fy, fx                       -- right = world_up x forward
  local rl = math.sqrt(rx * rx + ry * ry); rx, ry = rx / rl, ry / rl
  local ux, uy, uz = -fz * ry, fz * rx, fx * ry - fy * rx
  local dx, dy, dz = -p.pos[1], -p.pos[2], 110.0 - p.pos[3]  -- car body centre
  local depth = dx * fx + dy * fy + dz * fz
  local sx = dx * rx + dy * ry
  local sy = dx * ux + dy * uy + dz * uz
  local tan_h = math.tan(math.rad(p.fov * 0.5))
  local tan_v = tan_h / (16.0 / 9.0)
  return sx / (depth * tan_h), sy / (depth * tan_v), p.fov, p
end

local side_nx, side_ny = project("side_tracking")
-- 24% of the half-width == ~12% of the full frame width from centre. The
-- mandated right=620 / look_ahead=90 geometry cannot reach 12% of half-width
-- under a pinhole camera; this is the regression guard for the retune.
assert(math.abs(side_nx) < 0.28 and math.abs(side_ny) < 0.15,
  string.format("side_tracking off hero zone: nx=%.4f ny=%.4f", side_nx, side_ny))
local chase_ny = 0.0
for _, id in ipairs({ "chase_close", "chase_wide", "front_chase" }) do
  local nx, ny = project(id)
  chase_ny = ny
  assert(math.abs(nx) < 0.20 and ny > -0.35 and ny < 0.20,
    string.format("%s bad framing: nx=%.4f ny=%.4f", id, nx, ny))
end
local hx, hy, hfov, hp = project("heli_follow")
local hdist = math.sqrt(hp.pos[1]^2 + hp.pos[2]^2 + hp.pos[3]^2)
assert(hdist < 3600.0 and hfov <= 58.0 and math.abs(hx) < 0.20,
  string.format("heli not closer/centred: dist=%.1f fov=%.1f nx=%.4f", hdist, hfov, hx))
assert(Presets.get("heli_follow").flags.tau_hdg >= 1.0, "heli tau_hdg must glide hairpins")

-- Zero-spring check: car cruising at 3000 cm/s slams brakes to 0; camera
-- boom length to filtered target must stay constant (no longitudinal spring)
-- and filtered position must not ring/oscillate behind the stop point.
local e_brk = new_engine({ id = "brk", kind = "follow", preset = "chase_close" })
T = 0.0; move(0, 0, 0); pawn._yaw = 0
local x = 0.0
for _ = 1, 90 do
  T = T + DT60; x = x + 3000.0 * DT60; move(x, 0, 0)
  e_brk:pose_of({ id = "brk", kind = "follow", preset = "chase_close" })
end
local stop_x = x
local min_boom, max_boom = math.huge, 0.0
local peak_overshoot, min_undershoot = 0.0, 0.0
for _ = 1, 90 do
  T = T + DT60; move(stop_x, 0, 0)
  local p = e_brk:pose_of({ id = "brk", kind = "follow", preset = "chase_close" })
  local fpos = e_brk.tgt_filter.pos
  local boom = math.sqrt((fpos[1] - p.pos[1])^2 + (fpos[2] - p.pos[2])^2)
  if boom < min_boom then min_boom = boom end
  if boom > max_boom then max_boom = boom end
  local err = fpos[1] - stop_x
  if err > peak_overshoot then peak_overshoot = err end
  if err < min_undershoot then min_undershoot = err end
end
assert(max_boom - min_boom < 1.0,
  string.format("longitudinal spring detected: boom %.1f..%.1f", min_boom, max_boom))
assert(min_undershoot > -20.0,
  string.format("alpha-beta filter rang backward after stop: %.1f cm", min_undershoot))

-- New rig presets exist with complete, valid flags (validate() in prelude).
assert(Presets.types.pack_battle == true, "pack_battle type must be registered")
for _, id in ipairs({ "onboard_tcam", "rear_battle", "pack_battle" }) do
  local q = Presets.get(id)
  assert(q and q.id == id and q.flags.pin_view_target == true
         and type(q.flags.smoothing_alpha) == "number"
         and type(q.flags.use_route_tangent) == "boolean"
         and q.flags.tau_pos and q.flags.tau_look and q.flags.tau_hdg and q.flags.tau_fov,
    "missing/incomplete preset " .. id)
end
print(string.format("FRAMING_OK side_nx=%.4f chase_ny=%.4f heli_dist=%.0f", side_nx, chase_ny, hdist))
'''

# Phase 2 (b): physical-size telephoto auto-zoom curve + tau_fov glide.
ZOOM_HARNESS = r'''
local pan = { id = "z1", kind = "trackside_pan", location = { 0, 0, 0 } }
local function snap_fov(d)
  T = 0.0
  local e = new_engine(pan)
  move(d, 0, 0); pawn._yaw = 0
  return e:pose_of(pan).fov
end
local far_fov = snap_fov(12000.0)   -- 120 m: telephoto floor
local apex_fov = snap_fov(1200.0)   -- 12 m: wide apex pass
assert(far_fov >= 13.0 and far_fov <= 18.0,
  "120 m zoom not telephoto: " .. tostring(far_fov))
assert(apex_fov >= 45.0 and apex_fov <= 58.0,
  "12 m zoom not wide: " .. tostring(apex_fov))
local function trace(explicit_tau)
  T = 0.0
  local shot = { id = "z2", kind = "trackside_pan", location = { 0, 0, 0 } }
  if explicit_tau then shot.tau_fov = 0.22 end
  local e = new_engine(shot)
  move(12000, 0, 0); pawn._yaw = 0
  local prev = e:pose_of(shot).fov
  local max_step = 0.0
  for i = 1, 120 do
    T = T + DT60
    move(12000 - 10800.0 * (i / 120), 0, 0)
    local f = e:pose_of(shot).fov
    max_step = math.max(max_step, math.abs(f - prev)); prev = f
  end
  return prev, max_step
end
local final_fov, max_step = trace(false)
local explicit_fov, explicit_step = trace(true)
local alpha = Engine.exp_alpha(DT60, 0.22)
assert(max_step < (apex_fov - far_fov) * alpha + 1.0,
  string.format("zoom stepped: max_step=%.3f bound=%.3f", max_step, (apex_fov - far_fov) * alpha + 1.0))
-- Default tau_fov is 0.22: omitting it must be identical to setting it.
assert(math.abs(final_fov - explicit_fov) < 1.0e-6
       and math.abs(max_step - explicit_step) < 1.0e-6,
  "default tau_fov is not 0.22")
assert(final_fov > 40.0 and final_fov <= 58.0,
  "zoom did not widen toward the apex: " .. tostring(final_fov))
print(string.format("ZOOM_OK far=%.2f apex=%.2f final=%.2f maxstep=%.3f",
  far_fov, apex_fov, final_fov, max_step))
'''

# Phase 2 (c): approach-first director with minimum hold + cut snap.
DIRECTOR_HARNESS = r'''
local auto = { id = "auto", kind = "auto_trackside", preset = "trackside_low" }
local function cam(id, x)
  return { id = id, kind = "trackside_pan", location = { x, -800, 240 },
           role = "trackside", preset = "trackside_low" }
end
local plan = { shots = { auto, cam("camA", 0), cam("camB", 5000), cam("camC", 10000) } }
local e = Engine.new(Core, Presets, plan, nil)
e.clock = function() return T end
e.target = pawn
T = 0.0; move(-2000, 0, 0); pawn._yaw = 0
e:pose_of(auto)
assert(e.auto_cam_id == "camA" and e.auto_cam_since == 0.0,
  "director must open on the approaching camera: " .. tostring(e.auto_cam_id))
-- Still on camera A after passing it by 20 m: minimum hold not yet expired.
while pawn._x < 2000 do
  T = T + DT60; move(pawn._x + 2000.0 * DT60, 0, 0); e:pose_of(auto)
end
assert(e.auto_cam_id == "camA" and T < 2.8,
  string.format("min hold violated: id=%s T=%.3f", tostring(e.auto_cam_id), T))
-- Seed stale smoothing right before the early-release cut; the new lens must
-- snap straight onto the car at its own telephoto FOV.
local prev_id, cut_pose = e.auto_cam_id, nil
for _ = 1, 600 do
  T = T + DT60; move(pawn._x + 2000.0 * DT60, 0, 0)
  if e.auto_cam_id == "camA" and pawn._x > 3500.0 then
    e.smooth_fov = 1234.0
    e.follow_look = { 99999.0, 99999.0, 99999.0 }
  end
  local p = e:pose_of(auto)
  if e.auto_cam_id ~= prev_id then cut_pose = p; break end
end
assert(e.auto_cam_id == "camB", "did not hand off to camera B: " .. tostring(e.auto_cam_id))
local f = e.tgt_filter.pos
local dx, dy, dz = f[1] - 5000.0, f[2] + 800.0, f[3] + 110.0 - 240.0
local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
local raw_fov = math.max(13.0, math.min(58.0,
  math.deg(2.0 * math.atan((550.0 / 0.28) / (2.0 * math.max(dist, 600.0))))))
assert(cut_pose and math.abs(cut_pose.fov - raw_fov) < 0.01,
  string.format("cut did not snap fov: got=%s want=%.4f",
    cut_pose and cut_pose.fov or "nil", raw_fov))
assert(math.abs(cut_pose.look[1] - f[1]) < 400.0, "cut did not snap aim onto the car")
assert(math.abs(e.auto_cam_since - T) < 1.0e-9, "cut did not restart the hold timer")
-- Hand off again once the car is >35 m past camera B.
for _ = 1, 600 do
  T = T + DT60; move(pawn._x + 2000.0 * DT60, 0, 0); e:pose_of(auto)
  if e.auto_cam_id == "camC" then break end
end
assert(e.auto_cam_id == "camC", "no handoff to camera C: " .. tostring(e.auto_cam_id))
-- Approach-first scoring: with the hold expired, prefer the camera ahead
-- (camB, along=+3000) over the nearer-but-behind current camera (camA).
T = 10.0; move(2000, 0, 0); pawn._yaw = 0
local e2 = Engine.new(Core, Presets, plan, nil)
e2.clock = function() return T end
e2.target = pawn
e2:pose_of(auto)
e2.auto_cam_id = "camA"; e2.auto_cam_since = 0.0
T = 11.0
e2:pose_of(auto)
assert(e2.auto_cam_id == "camB",
  "approach-first bias failed: " .. tostring(e2.auto_cam_id))
print(string.format("DIRECTOR_OK cut=%s at_x=%.0f handoff=%s", "camB", pawn._x, e.auto_cam_id))
'''

# Phase 1 (d): pack_battle two-car midpoint framing + solo fallback.
PACK_HARNESS = r'''
local rival = { _x = 2000.0, _y = 0.0, _z = 0.0 }
function rival:K2_GetActorLocation() return { X = self._x, Y = self._y, Z = self._z } end
function rival:K2_GetActorRotation() return { Yaw = 0 } end
local pawns = { pawn, rival }
_G.FindAllOf = function(cls)
  if cls == "MTPlayerCharacter_C" then return pawns end
  return {}
end
local shot = { id = "pb", kind = "pack_battle", preset = "pack_battle" }
T = 0.0
local e = new_engine(shot)
move(0, 0, 0); pawn._yaw = 0
local p = e:pose_of(shot)
-- Midpoint = 0.6*focus + 0.4*rival = (800, 0, 110); camera sits behind it.
assert(math.abs(p.look[1] - 800.0) < 5.0 and math.abs(p.look[3] - 110.0) < 5.0,
  string.format("pack midpoint wrong: %.1f,%.1f,%.1f", p.look[1], p.look[2], p.look[3]))
assert(math.abs(p.pos[1] + 400.0) < 5.0 and math.abs(p.pos[2] - 180.0) < 5.0
       and math.abs(p.pos[3] - 420.0) < 5.0,
  string.format("pack camera wrong: %.1f,%.1f,%.1f", p.pos[1], p.pos[2], p.pos[3]))
assert(p.fov >= 56.0 and p.fov <= 84.0,
  "pack fov out of broadcast range: " .. tostring(p.fov))
-- Side-by-side rival 12 m right widens FOV more than nose-to-tail.
rival._x = 0.0; rival._y = 1200.0
local e_side = new_engine(shot)
T = 0.0; move(0, 0, 0); pawn._yaw = 0
local p_side = e_side:pose_of(shot)
assert(p_side.fov > p.fov and p_side.fov <= 84.0,
  string.format("side-by-side must widen more than nose-to-tail: side=%.1f n2t=%.1f", p_side.fov, p.fov))
-- Rival beyond max_rival_cm: clean fallback to the follow rig (preset fov).
rival._x = 8000.0
local e2 = new_engine(shot)
T = 0.0; move(0, 0, 0); pawn._yaw = 0
local solo = e2:pose_of(shot)
assert(math.abs(solo.pos[1] + 1200.0) < 5.0 and math.abs(solo.fov - 68.0) < 0.01,
  string.format("solo fallback wrong: pos=%.1f fov=%.2f", solo.pos[1], solo.fov))
print(string.format("PACK_OK look=%.0f fov=%.1f solo_fov=%.1f", p.look[1], p.fov, solo.fov))
'''

# Phase 1: vehicle-root tracking with safe fallback.
VEHICLE_HARNESS = r'''
local veh = { _x = 500.0, _y = 0.0, _z = 0.0, _yaw = 90.0 }
function veh:IsValid() return true end
function veh:K2_GetActorLocation() return { X = self._x, Y = self._y, Z = self._z } end
function veh:K2_GetActorRotation() return { Yaw = self._yaw } end
function pawn:GetVehicle() return veh end
local shot = { id = "v1", kind = "follow", preset = "chase_close" }
T = 0.0; move(0, 0, 0); pawn._yaw = 0
local e = new_engine(shot)
local p = e:pose_of(shot)
assert(e.seated_vehicle and e.seated_vehicle(pawn) == veh, "seated vehicle not detected")
-- Vehicle root at (500,0,0), yaw 90 deg -> camera at (500,-1100,340).
assert(math.abs(p.pos[1] - 500.0) < 1.0 and math.abs(p.pos[2] + 1100.0) < 1.0,
  string.format("vehicle-root position wrong: %.1f,%.1f,%.1f", p.pos[1], p.pos[2], p.pos[3]))
assert(math.abs(p.look[1] - 500.0) < 1.0 and math.abs(p.look[2] - 250.0) < 1.0,
  string.format("vehicle-root yaw wrong: %.1f,%.1f", p.look[1], p.look[2]))
-- Invalid vehicle / throwing GetVehicle must fall back to the pawn cleanly.
local bad = { IsValid = function() return false end,
              K2_GetActorLocation = veh.K2_GetActorLocation,
              K2_GetActorRotation = veh.K2_GetActorRotation }
function pawn:GetVehicle() return bad end
local e2 = new_engine(shot)
T = 0.0; move(0, 0, 0); pawn._yaw = 0
local p2 = e2:pose_of(shot)
assert(e2.seated_vehicle(pawn) == nil and math.abs(p2.pos[1] + 1100.0) < 1.0,
  "invalid vehicle did not fall back to the pawn")
function pawn:GetVehicle() error("vehicle probe exploded") end
local e3 = new_engine(shot)
T = 0.0; move(0, 0, 0); pawn._yaw = 0
local p3 = e3:pose_of(shot)
assert(p3 and math.abs(p3.pos[1] + 1100.0) < 1.0, "throwing GetVehicle broke the tick")
print(string.format("VEHICLE_OK seated=%.0f,%.0f fallback=%.0f", p.pos[1], p.pos[2], p3.pos[1]))
'''

# Auto Director prelude: director.lua is pure Lua, so no UE4SS stubs or temp
# data dir are needed -- only the module path and a few snapshot builders.
AUTO_DIRECTOR_PRELUDE = r'''
local DATA_DIR = "__DATA_DIR__"
local ROOT = "__REPO_ROOT__/ClientScripts"
package.path = ROOT .. "/?.lua;" .. ROOT .. "/?/init.lua;" .. package.path

local D = require("RaceCam/director")

local ALL = {}
for _, id in ipairs({
  "pack_battle", "front_chase", "rear_battle", "heli_follow", "auto_trackside",
  "onboard_tcam", "side_tracking", "chase_close", "chase_wide", "follow_focus",
  "start_line", "orbit_hero", "start_crane", "finish_line",
}) do ALL[id] = true end

local function row(name, rank, laps, section, split, finished, dq)
  return { name = name, rank = rank, laps = laps or 2, section = section or 5,
           split_s = split, finished = finished or false, dq = dq or false }
end
local function car(x, spd, streamed)
  return { pos = { x = x, y = 0, z = 0 }, spd_cm_s = spd, streamed_in = streamed }
end
local function mk_snap(over)
  local s = {
    now = 0, mode = "full", event_state = "RACING", num_laps = 5,
    standings = {}, cars = {}, available_shots = ALL,
    finish_pos = { x = 90000, y = 0, z = 0 },
    current_target = nil, current_shot = nil,
  }
  for k, v in pairs(over or {}) do s[k] = v end
  return s
end
local function contains(s, needle) return s:find(needle, 1, true) ~= nil end
'''

# Scenario 1: a close midfield battle outscores a lonely (air-time-decayed)
# leader, and cars stationary for >4 s are never selected during RACING.
AUTO_DIRECTOR_BATTLE_HARNESS = r'''
local d = D.new()
local snap = mk_snap{
  standings = { row("P1", 1, 2, 5, nil), row("P2", 2, 2, 5, 30),
                row("P3", 3, 2, 5, 0.8), row("P4", 4, 2, 4, 40),
                row("P5", 5, 2, 4, 50) },
  cars = { P1 = car(0, 3000), P2 = car(5000, 3000), P3 = car(5100, 3000),
           P4 = car(10000, 40), P5 = car(11000, 30) },
  current_target = "P1",
}
local dead_seen, battle_seen, battle_reason = false, false, false
for t = 0, 20 do
  snap.now = t
  local r = d:step(snap)
  if r.target == "P4" or r.target == "P5" then dead_seen = true end
  if r.target == "P2" or r.target == "P3" then battle_seen = true end
  if r.target and contains(r.reason, "battle") then battle_reason = true end
  assert(r.next_cut_in >= 0 and r.next_cut_in <= 16.001,
         "next_cut_in out of range at " .. t .. ": " .. tostring(r.next_cut_in))
  snap.current_target = r.target or snap.current_target
end
assert(not dead_seen, "dead/stopped car must never be selected during RACING")
assert(battle_seen, "close battle never became the target")
assert(battle_reason, "close-battle reason missing from step() output")
assert(snap.current_target == "P2" or snap.current_target == "P3",
       "final target not in the close battle: " .. tostring(snap.current_target))

-- Zero split_s (missing/pre-gate timing) must NOT fabricate a close battle.
local dz = D.new()
local rz = dz:step(mk_snap{
  standings = { row("P1", 1, 0, 0, 0), row("P2", 2, 0, 0, 0) },
  cars = { P1 = car(0, 3000), P2 = car(50000, 3000) },
  current_target = "P1",
})
assert(not contains(rz.reason, "battle"), "zero split_s fabricated a fake battle: " .. rz.reason)

-- A long-watched solo leader must rotate to a fresh rival once air-time decay
-- overcomes the +25% stickiness (12 s grace, 2.5/s, capped at -45).
local d2 = D.new()
local s2 = mk_snap{
  standings = { row("P1", 1, 2, 5, nil), row("P6", 2, 2, 5, 30) },
  cars = { P1 = car(0, 3000), P6 = car(50000, 3000) },
  current_target = "P1",
}
local switched = nil
for t = 0, 30 do
  s2.now = t
  local r = d2:step(s2)
  s2.current_target = r.target or s2.current_target
  if switched == nil and s2.current_target == "P6" then switched = t end
end
assert(switched ~= nil and switched > 12,
       "air-time decay did not rotate the lonely leader: " .. tostring(switched))
print("AUTO_DIRECTOR_BATTLE_OK battle=" .. tostring(battle_seen)
      .. " dead=" .. tostring(dead_seen) .. " rotate_at=" .. tostring(switched))
'''

# Scenario 2: rank swap cuts immediately; final-lap finish sprint locks
# finish_line (and falls back to start_crane when finish_line is not loaded).
AUTO_DIRECTOR_SPRINT_HARNESS = r'''
local d = D.new()
local snap = mk_snap{
  num_laps = 3,
  standings = { row("P1", 1, 2, 5, nil), row("P2", 2, 2, 5, 20) },
  cars = { P1 = car(0, 3000), P2 = car(50000, 3000) },
  current_target = "P1",
}
local r = d:step(snap)
assert(r.shot ~= nil, "no opening shot produced")
snap.now = 1
snap.standings = { row("P2", 1, 2, 5, nil), row("P1", 2, 2, 5, 20) }
snap.current_target = r.target or "P1"
r = d:step(snap)
assert(r.target == "P2", "rank swap must cut the target immediately: " .. tostring(r.target))
assert(contains(r.reason, "overtake"), "overtake reason missing: " .. r.reason)
snap.now = 2
snap.cars.P2 = car(89500, 3000)  -- 500 cm from finish, inside 250 m sprint zone
snap.current_target = r.target or snap.current_target
r = d:step(snap)
assert(r.shot == "finish_line", "final lap must lock finish_line: " .. tostring(r.shot))
assert(contains(r.reason, "finish_line"), "finish reason missing: " .. r.reason)

local limited = {}
for k, v in pairs(ALL) do limited[k] = v end
limited.finish_line = nil
local d2 = D.new()
local s2 = mk_snap{
  num_laps = 3,
  standings = { row("P1", 1, 2, 5, nil) },
  cars = { P1 = car(89500, 3000) },
  available_shots = limited, current_target = "P1",
}
r = d2:step(s2)
assert(r.shot == "start_crane",
       "finish_line fallback must be start_crane: " .. tostring(r.shot))
print("AUTO_DIRECTOR_SPRINT_OK overtake_target=P2 shot=" .. tostring(r.shot))
'''

# Scenario 3: alternating advantages between two equal battles must not
# ping-pong the target; min_shot_hold (4.5 s) spaces shot cuts.
AUTO_DIRECTOR_HOLD_HARNESS = r'''
local d = D.new()
local ct = "P1"
local switches, cuts = 0, {}
for t = 0, 50 do
  local sa = (t % 2 == 0) and 0.8 or 3.0
  local sb = (t % 2 == 0) and 3.0 or 0.8
  local snap = mk_snap{
    now = t,
    standings = { row("P1", 1, 2, 5, nil), row("P2", 2, 2, 5, sa),
                  row("P3", 3, 2, 5, nil), row("P4", 4, 2, 5, sb) },
    cars = { P1 = car(0, 3000), P2 = car(500, 3000),
             P3 = car(20000, 3000), P4 = car(20500, 3000) },
    current_target = ct,
    current_shot = (#cuts > 0) and cuts[#cuts].id or nil,
  }
  local r = d:step(snap)
  if r.target and r.target ~= ct then switches = switches + 1; ct = r.target end
  if r.shot then
    if #cuts > 0 then
      assert(t - cuts[#cuts].t >= 4.499,
             "min_shot_hold violated: cut at " .. cuts[#cuts].t .. " then " .. t)
    end
    cuts[#cuts + 1] = { t = t, id = r.shot }
  end
  assert(r.next_cut_in >= 0 and r.next_cut_in <= 16.001)
end
assert(switches <= 1, "target ping-ponged between equal battles: " .. tostring(switches))
assert(#cuts >= 4, "too few shot cuts over 50 s: " .. tostring(#cuts))
for i = 2, #cuts do
  assert(cuts[i].id ~= cuts[i - 1].id, "same shot repeated back-to-back")
end
print("AUTO_DIRECTOR_HOLD_OK switches=" .. tostring(switches) .. " cuts=" .. tostring(#cuts))
'''

# Scenario 4: a manual shot/target click pauses only that axis of the Auto
# Director for the 15 s cooldown, without fighting the operator.
AUTO_DIRECTOR_OVERRIDE_HARNESS = r'''
local d = D.new()
local snap = mk_snap{
  standings = { row("P1", 1, 2, 5, nil), row("P2", 2, 2, 5, 20) },
  cars = { P1 = car(0, 3000), P2 = car(50000, 3000) },
  current_target = "P1",
}
local opening = d:step(snap)
assert(opening.target ~= nil or opening.shot ~= nil, "director must be active before override")
d:note_manual_shot(1)
d:note_manual_target(1)
for t = 2, 15 do
  snap.now = t
  local r = d:step(snap)
  assert(r.target == nil and r.shot == nil,
         "director fought the override at t=" .. t .. ": " .. r.reason)
  assert(contains(r.reason, "override"), "override reason missing: " .. r.reason)
  assert(math.abs(r.override_s - d:override_remaining(t)) < 1e-9,
         "override_s disagrees with override_remaining()")
end
assert(d:override_remaining(16) == 0, "15 s cooldown did not expire")
snap.now = 16
local after = d:step(snap)
assert(not contains(after.reason, "override"), "override still reported after cooldown")

-- Shot-only override must leave target selection automatic.
local d2 = D.new()
d2:note_manual_shot(5)
snap.current_target = nil
local got_target = false
for t = 5, 19 do
  snap.now = t
  local r = d2:step(snap)
  assert(r.shot == nil, "shot override leaked at t=" .. t)
  if r.target then got_target = true end
end
assert(got_target, "target selection must stay automatic during a shot-only override")
print("AUTO_DIRECTOR_OVERRIDE_OK cooldown=15 target_still_auto=" .. tostring(got_target))
'''

# Scenario 5: a remote (not streamed-in) target is restricted to angles that
# work on PlayerState location; streamed-in targets get the full solo pool.
AUTO_DIRECTOR_REMOTE_HARNESS = r'''
local d = D.new()
local snap = mk_snap{
  mode = "shots",
  standings = { row("P1", 1, 2, 5, nil) },
  cars = { P1 = car(0, 3000, false) },
  current_target = "P1",
}
local shots = {}
for i = 0, 20 do
  snap.now = i * 16
  local r = d:step(snap)
  if r.shot then shots[#shots + 1] = r.shot; snap.current_shot = r.shot end
end
assert(#shots >= 10, "too few remote shot cuts: " .. tostring(#shots))
local allowed = { auto_trackside = true, heli_follow = true,
                  chase_wide = true, follow_focus = true }
for i, s in ipairs(shots) do
  assert(allowed[s], "remote target got disallowed shot " .. tostring(s))
  assert(s ~= "onboard_tcam" and s ~= "side_tracking",
         "remote target must never use onboard_tcam/side_tracking: " .. s)
  if i > 1 then assert(s ~= shots[i - 1], "back-to-back shot repeat") end
end

-- Remote stays restricted even when it is part of a close battle.
local d2 = D.new()
local s2 = mk_snap{
  mode = "shots",
  standings = { row("P1", 1, 2, 5, nil), row("P2", 2, 2, 5, 0.5) },
  cars = { P1 = car(0, 3000, false), P2 = car(500, 3000, true) },
  current_target = "P1",
}
for i = 0, 9 do
  s2.now = i * 5
  local r = d2:step(s2)
  if r.shot then
    assert(allowed[r.shot], "remote battle got disallowed shot " .. tostring(r.shot))
    s2.current_shot = r.shot
  end
end

-- A streamed-in solo target may use onboard_tcam, side_tracking, and follow_focus.
local d3 = D.new()
local s3 = mk_snap{
  mode = "shots",
  standings = { row("P1", 1, 2, 5, nil) },
  cars = { P1 = car(0, 3000, true) },
  current_target = "P1",
}
local onboard, side, follow_focus = false, false, false
for i = 0, 14 do
  s3.now = i * 16
  local r = d3:step(s3)
  if r.shot then
    s3.current_shot = r.shot
    if r.shot == "onboard_tcam" then onboard = true end
    if r.shot == "side_tracking" then side = true end
    if r.shot == "follow_focus" then follow_focus = true end
  end
end
assert(onboard and side and follow_focus,
       "streamed-in target missing expected solo shots: onboard=" .. tostring(onboard)
       .. " side=" .. tostring(side) .. " follow_focus=" .. tostring(follow_focus))

-- Switching from a streamed-in target to a remote target on the SAME tick must
-- check remoteness against the NEW target (never pick onboard_tcam).
local d4 = D.new()
local s4 = mk_snap{
  mode = "full",
  standings = { row("Near", 1, 2, 5, nil), row("Far", 2, 2, 5, 20) },
  cars = { Near = car(0, 3000, true), Far = car(90000, 3000, false) },
  current_target = "Near",
  current_shot = "auto_trackside",
}
d4:step(s4)
s4.now = 5
s4.standings = { row("Far", 1, 2, 5, nil), row("Near", 2, 2, 5, 20) } -- rank swap to remote
local r4 = d4:step(s4)
assert(r4.target == "Far", "expected switch to Far: " .. tostring(r4.target))
if r4.shot then
  assert(allowed[r4.shot], "same-tick switch to remote picked disallowed shot: " .. tostring(r4.shot))
end
print("AUTO_DIRECTOR_REMOTE_OK remote_shots=" .. table.concat(shots, ","))
'''

class RaceCamLuaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.lua_files = sorted(RACECAM.glob("*.lua"))
        assert cls.lua_files, f"no Lua files under {RACECAM}"

    def test_lua_syntax_all_files(self) -> None:
        """luac -p every RaceCam Lua file via the NixOS host wrapper."""
        self.assertGreaterEqual(len(self.lua_files), 6)
        for path in self.lua_files:
            with self.subTest(file=path.name):
                proc = subprocess.run(
                    [str(HOSTRUN), str(SYNTAX_CHECK), str(path)],
                    capture_output=True,
                    text=True,
                    timeout=180,
                )
                self.assertEqual(
                    0,
                    proc.returncode,
                    f"hostrun failed for {path.name}: {proc.stdout}{proc.stderr}",
                )
                self.assertIn(
                    f"SYNTAX_OK {path}",
                    proc.stdout,
                    f"luac -p failed for {path.name}: {proc.stdout}{proc.stderr}",
                )

    def test_no_d_drive_references(self) -> None:
        """Runtime Lua must not hardcode a D: drive or SteamLibrary path."""
        pattern = re.compile(r"\bD\s*:\s*[\\/]", re.IGNORECASE)
        for path in self.lua_files:
            with self.subTest(file=path.name):
                text = path.read_text(encoding="utf-8", errors="replace")
                matches = [m.group(0) for m in pattern.finditer(text)]
                self.assertFalse(matches, f"{path.name} contains D: drive references: {matches}")

    def test_http_fail_closed_auth_on_all_endpoints(self) -> None:
        """All API routes, including the new ones, sit behind the token gate."""
        src = HTTP_PATH.read_text(encoding="utf-8")
        self.assertIn(
            'local token = Paths.read_token()',
            src,
            "HTTP auth must use the canonical Paths.read_token()",
        )
        gate = 'not token or token == "" or req.headers["x-racecam-token"] ~= token'
        self.assertIn(gate, src, "fail-closed token gate missing")
        gate_pos = src.index(gate)

        # The public panel is the ONLY route allowed before the auth gate.
        panel_pos = src.index('req.path == "/" or req.path == "/index.html"')
        self.assertLess(panel_pos, gate_pos, "panel route must precede auth gate")

        for endpoint in (
            "/api/state",
            "/api/command",
            "/api/live_events",
            "/api/plans",
            "/api/plan",
            "/api/auto_flags",
            "/api/inbox",
            "/api/inbox_file",
            "/api/my_pos",
        ):
            with self.subTest(endpoint=endpoint):
                needle = f'req.path == "{endpoint}"'
                self.assertIn(needle, src, f"{endpoint} route missing")
                self.assertGreater(
                    src.index(needle),
                    gate_pos,
                    f"{endpoint} is reachable without auth",
                )

        # Registration/plan POSTs must validate the plan_id and use JsonParser.
        self.assertIn('^[A-Za-z0-9_%-]+$', src)
        self.assertIn('parse_json(req.body)', src)
        self.assertIn('pcall(require, "JsonParser")', src)

        # Panel HTML must come from the sibling-owned module, not be inlined.
        self.assertIn('pcall(require, "RaceCam/panel_ui")', src)
        self.assertNotIn('local PANEL = [==[<!doctype', src)

        # 64 KB/tick drain and 512 KB body cap.
        self.assertIn('65536', src, "64 KB per-tick read drain missing")
        self.assertIn('524288', src, "512 KB body cap missing")

    def test_static_phase12_surface(self) -> None:
        """Phase 1 & 2 entry points exist in their owning modules."""
        paths = (RACECAM / "paths.lua").read_text(encoding="utf-8")
        self.assertIn("function P.ensure_token()", paths)
        self.assertIn("function P.read_token()", paths)

        live = (RACECAM / "live_events.lua").read_text(encoding="utf-8")
        for needle in ("Net_EventSystem", "Net_Events", "pcall", "IsValid", "gate_m", "leader_name", "is_member"):
            self.assertIn(needle, live, f"live_events.lua missing {needle}")

        init = (RACECAM / "init.lua").read_text(encoding="utf-8")
        for needle in (
            "Paths.ensure_token()",
            "function M.reload_plan(",
            "function M.list_plans()",
            "function M.status()",
            "function M.panel_url(",
            "function M.panic_stop()",
            "function M.set_auto_flags(",
            'pcall(require, "JsonParser")',
            "plans_index.json",
        ):
            self.assertIn(needle, init, f"init.lua missing {needle}")
        self.assertNotIn("io.popen", init, "plan discovery must not use io.popen")

        state = HTTP_PATH.read_text(encoding="utf-8")
        for needle in ('"auto_start":', '"follow_leader":', '"active_event":'):
            self.assertIn(needle, state, f"/api/state missing {needle}")

    def test_inbox_and_pos_static_surface(self) -> None:
        """Source-level invariants for the inbox/drop and local-pose routes."""
        paths = (RACECAM / "paths.lua").read_text(encoding="utf-8")
        for needle in (
            "function P.inbox_dir()",
            'P.data_dir() .. "inbox/"',
            "function P.drop_file()",
            'P.data_dir() .. "drop_event.json"',
            "function P.ensure_dir(",
            "P.inbox_dir()",
        ):
            with self.subTest(file="paths.lua", needle=needle):
                self.assertIn(needle, paths, f"paths.lua missing {needle}")

        src = HTTP_PATH.read_text(encoding="utf-8")
        gate = 'not token or token == "" or req.headers["x-racecam-token"] ~= token'
        gate_pos = src.index(gate)
        for endpoint in ("/api/inbox", "/api/inbox_file", "/api/my_pos"):
            with self.subTest(endpoint=endpoint):
                needle = f'req.path == "{endpoint}"'
                pos = src.index(needle)
                self.assertGreater(pos, gate_pos, f"{endpoint} precedes auth gate")
                # Every new branch must refresh the heartbeat like every other
                # authenticated route (next `elseif` delimits the branch).
                end = src.find("\n  elseif ", pos)
                block = src[pos:end if end > 0 else len(src)]
                self.assertIn("touch()", block, f"{endpoint} does not call touch()")

        for needle in (
            "local inbox_files = {}",
            "function H.set_inbox_files(list)",
            "^[A-Za-z0-9._-]+%.json$",
            'name == "drop_event.json"',
            'Paths.inbox_dir() .. name',
            "512 * 1024 + 1",
            '{"error":"invalid filename"}',
            '{"error":"not found"}',
            '{"error":"file too large"}',
            '{"ok":false,"error":"no local pawn or camera"}',
            "_pos_provider",
            "K2_GetActorLocation",
            "K2_GetActorRotation",
            "GetCameraLocation",
            "GetCameraRotation",
        ):
            with self.subTest(needle=needle):
                self.assertIn(needle, src, f"http.lua missing {needle}")

    def test_lua_inbox_and_pos_behaviour(self) -> None:
        """Real Lua 5.4 harness: traversal-safe inbox API and local pose."""
        tmpdir = Path(tempfile.mkdtemp(prefix="racecam_inbox_", dir=SCRATCH))
        try:
            harness = LUA_INBOX_HARNESS.replace("__DATA_DIR__", str(tmpdir)).replace(
                "__REPO_ROOT__", str(REPO)
            )
            harness_path = tmpdir / "harness.lua"
            harness_path.write_text(harness, encoding="utf-8")
            wrapper_path = tmpdir / "run_harness.sh"
            wrapper_path.write_text(
                "#!/usr/bin/env bash\nset -u\n"
                f'nix shell nixpkgs#lua5_4 -c lua "{harness_path}"\n',
                encoding="utf-8",
            )
            proc = subprocess.run(
                [str(HOSTRUN), str(wrapper_path)],
                capture_output=True,
                text=True,
                timeout=180,
            )
            self.assertEqual(
                0,
                proc.returncode,
                f"inbox harness failed:\n{proc.stdout}\n{proc.stderr}",
            )
            self.assertIn("INBOX_OK", proc.stdout, f"{proc.stdout}\n{proc.stderr}")
        finally:
            shutil.rmtree(tmpdir, ignore_errors=True)

    def test_lua_behaviour(self) -> None:
        """Execute a real Lua 5.4 harness on the host against the actual modules."""
        tmpdir = Path(tempfile.mkdtemp(prefix="racecam_behavior_", dir=SCRATCH))
        try:
            harness = LUA_HARNESS.replace("__DATA_DIR__", str(tmpdir)).replace("__REPO_ROOT__", str(REPO))
            harness_path = tmpdir / "harness.lua"
            harness_path.write_text(harness, encoding="utf-8")
            wrapper_path = tmpdir / "run_harness.sh"
            wrapper_path.write_text(
                "#!/usr/bin/env bash\nset -u\n"
                f'nix shell nixpkgs#lua5_4 -c lua "{harness_path}"\n',
                encoding="utf-8",
            )
            proc = subprocess.run(
                [str(HOSTRUN), str(wrapper_path)],
                capture_output=True,
                text=True,
                timeout=180,
            )
            self.assertEqual(
                0,
                proc.returncode,
                f"behaviour harness failed:\n{proc.stdout}\n{proc.stderr}",
            )
            self.assertIn("BEHAVIOR_OK", proc.stdout, f"{proc.stdout}\n{proc.stderr}")
        finally:
            shutil.rmtree(tmpdir, ignore_errors=True)


    def test_lua_live_standings_and_manual_target(self) -> None:
        """Lua 5.4 harness: sorted standings in /api/state, manual target hands control off."""
        tmpdir = Path(tempfile.mkdtemp(prefix="racecam_standings_", dir=SCRATCH))
        try:
            harness = LUA_STANDINGS_HARNESS.replace("__DATA_DIR__", str(tmpdir)).replace(
                "__REPO_ROOT__", str(REPO)
            )
            harness_path = tmpdir / "harness.lua"
            harness_path.write_text(harness, encoding="utf-8")
            wrapper_path = tmpdir / "run_harness.sh"
            wrapper_path.write_text(
                "#!/usr/bin/env bash\nset -u\n"
                f'nix shell nixpkgs#lua5_4 -c lua "{harness_path}"\n',
                encoding="utf-8",
            )
            proc = subprocess.run(
                [str(HOSTRUN), str(wrapper_path)],
                capture_output=True,
                text=True,
                timeout=180,
            )
            self.assertEqual(
                0,
                proc.returncode,
                f"standings harness failed:\n{proc.stdout}\n{proc.stderr}",
            )
            self.assertIn("STANDINGS_OK", proc.stdout, f"{proc.stdout}\n{proc.stderr}")
        finally:
            shutil.rmtree(tmpdir, ignore_errors=True)


    def _run_smoothing_harness(self, body: str, token: str, prefix: str) -> None:
        """Run one deterministic Lua 5.4 smoothing harness on the NixOS host."""
        tmpdir = Path(tempfile.mkdtemp(prefix=f"racecam_{prefix}_", dir=SCRATCH))
        try:
            harness = (SMOOTHING_PRELUDE + body).replace("__DATA_DIR__", str(tmpdir)).replace(
                "__REPO_ROOT__", str(REPO)
            )
            harness_path = tmpdir / "harness.lua"
            harness_path.write_text(harness, encoding="utf-8")
            wrapper_path = tmpdir / "run_harness.sh"
            wrapper_path.write_text(
                "#!/usr/bin/env bash\nset -u\n"
                f'nix shell nixpkgs#lua5_4 -c lua "{harness_path}"\n',
                encoding="utf-8",
            )
            proc = subprocess.run(
                [str(HOSTRUN), str(wrapper_path)],
                capture_output=True,
                text=True,
                timeout=180,
            )
            self.assertEqual(
                0,
                proc.returncode,
                f"{prefix} harness failed:\n{proc.stdout}\n{proc.stderr}",
            )
            self.assertIn(token, proc.stdout, f"{proc.stdout}\n{proc.stderr}")
        finally:
            shutil.rmtree(tmpdir, ignore_errors=True)

    def test_lua_smoothing_dt_invariance(self) -> None:
        """30/60/120 FPS converge to the same pose after 0.5 s (within 3%)."""
        self._run_smoothing_harness(SMOOTH_DT_HARNESS, "SMOOTH_DT_OK", "smoothdt")

    def test_lua_smoothing_network_jitter(self) -> None:
        """15 Hz stepped +-80 cm packets: aim jitter drops by > 65% at 60 FPS."""
        self._run_smoothing_harness(SMOOTH_JITTER_HARNESS, "SMOOTH_JITTER_OK", "smoothjit")

    def test_lua_smoothing_zero_steady_state_lag(self) -> None:
        """Alpha-beta estimator has zero lag on a constant 5000 cm/s car."""
        self._run_smoothing_harness(SMOOTH_LAG_HARNESS, "SMOOTH_LAG_OK", "smoothlag")

    def test_lua_smoothing_teleport_snap(self) -> None:
        ">25 m respawns and target-actor cuts snap in one tick, no camera smear."
        self._run_smoothing_harness(SMOOTH_SNAP_HARNESS, "SMOOTH_SNAP_OK", "smoothsnap")

    def test_lua_smoothing_orbit_pan_modes_and_reset(self) -> None:
        """Orbit/pan aim+fov smoothing, clean cut resets, smoothing modes."""
        self._run_smoothing_harness(SMOOTH_MODES_HARNESS, "SMOOTH_MODES_OK", "smoothmodes")

    def test_lua_preset_framing_projection(self) -> None:
        """Follow presets frame the car inside the 16:9 hero zone."""
        self._run_smoothing_harness(FRAMING_HARNESS, "FRAMING_OK", "framing")

    def test_lua_trackside_physical_auto_zoom(self) -> None:
        """Physical telephoto curve (13-58 deg) glides with the 0.22 s tau."""
        self._run_smoothing_harness(ZOOM_HARNESS, "ZOOM_OK", "zoom")

    def test_lua_auto_trackside_approach_director(self) -> None:
        """Approach-first camera picks, min hold, handoff and cut snapping."""
        self._run_smoothing_harness(DIRECTOR_HARNESS, "DIRECTOR_OK", "director")

    def test_lua_pack_battle_framing(self) -> None:
        """Two-car midpoint framing widens FOV; solo falls back to follow."""
        self._run_smoothing_harness(PACK_HARNESS, "PACK_OK", "packbattle")

    def test_lua_vehicle_root_tracking(self) -> None:
        """Seated drivers are tracked from the vehicle root with safe fallback."""
        self._run_smoothing_harness(VEHICLE_HARNESS, "VEHICLE_OK", "vehicle")

    def test_lua_player_array_full_server_roster_and_remote_fallback(self) -> None:
        """list_targets merges GameState.PlayerArray; far drivers track PlayerState.Location and upgrade when streamed in."""
        harness = r'''
local function mk_str(s) return { ToString = function() return s end } end
local near_pawn = {
  PlayerState = { GetPlayerName = function() return mk_str("NearDriver") end },
  K2_GetActorLocation = function() return { X = 100, Y = 200, Z = 50 } end,
  K2_GetActorRotation = function() return { Yaw = 0 } end,
}
local far_ps = {
  IsValid = function() return true end,
  GetPlayerName = function() return mk_str("FarDriver") end,
  Location = { X = 50000, Y = 60000, Z = 300 },
}
local near_ps = {
  IsValid = function() return true end,
  GetPlayerName = function() return mk_str("NearDriver") end,
  Location = { X = 100, Y = 200, Z = 50 },
}
local extra_ps = {
  IsValid = function() return true end,
  GetPlayerName = function() return mk_str("AnotherFar") end,
  Location = { X = 80000, Y = 10000, Z = 100 },
}
local live_pawns = { near_pawn }
_G.FindAllOf = function(cls)
  if cls == "MTPlayerCharacter_C" then return live_pawns end
  return {}
end
_G.FindFirstOf = function(cls)
  if cls == "MotorTownGameState" then
    return {
      IsValid = function() return true end,
      PlayerArray = { near_ps, far_ps, extra_ps },
    }
  end
  return nil
end

local shot = { id = "f1", kind = "follow", preset = "chase_close" }
local e = Engine.new(Core, Presets, { shots = { shot } }, nil)
e.clock = function() return T end

-- 1. Full-server roster: nearby first, remote sorted alphabetically, deduplicated.
local roster = e:list_targets()
assert(#roster == 3, "expected 3 drivers, got " .. tostring(#roster))
assert(roster[1] == "NearDriver" and roster[2] == "AnotherFar" and roster[3] == "FarDriver",
  "unexpected roster order: " .. table.concat(roster, ","))

-- 2. Target a far driver outside UE5 relevancy bubble: tracks PlayerState.Location.
local ok, msg = e:set_target_by_name("FarDriver")
assert(ok and e.target == nil and e.target_ps == far_ps, "far target failed: " .. tostring(msg))
T = 1.0
local pose1 = e:pose_of(shot)
assert(pose1 and not e.target_lost, "pose1 failed for remote PlayerState")
assert(math.abs(pose1.look[1] - 50000) < 3000 and math.abs(pose1.look[2] - 60000) < 3000,
  "remote look not near PlayerState.Location")

-- 3. FarDriver streams into relevancy: resolve_target upgrades seamlessly to live pawn.
local far_pawn = {
  PlayerState = { GetPlayerName = function() return mk_str("FarDriver") end },
  K2_GetActorLocation = function() return { X = 50100, Y = 60000, Z = 300 } end,
  K2_GetActorRotation = function() return { Yaw = 0 } end,
}
live_pawns = { near_pawn, far_pawn }
T = 2.0
local pose2 = e:pose_of(shot)
assert(pose2 and e.target == far_pawn and e.target_ps == nil and not e.target_lost,
  "did not upgrade from remote PlayerState to streamed-in pawn")
print("PLAYER_ARRAY_ROSTER_OK count=3 upgraded=true")
'''
        self._run_smoothing_harness(harness, "PLAYER_ARRAY_ROSTER_OK", "roster")


    # ----- Auto Director: pure-Lua state machine -----------------------------

    def _run_director_harness(self, body: str, token: str, prefix: str) -> None:
        """Run one deterministic Lua 5.4 Auto Director harness on the host."""
        tmpdir = Path(tempfile.mkdtemp(prefix=f"racecam_director_{prefix}_", dir=SCRATCH))
        try:
            harness = (AUTO_DIRECTOR_PRELUDE + body).replace("__DATA_DIR__", str(tmpdir)).replace(
                "__REPO_ROOT__", str(REPO)
            )
            harness_path = tmpdir / "harness.lua"
            harness_path.write_text(harness, encoding="utf-8")
            wrapper_path = tmpdir / "run_harness.sh"
            wrapper_path.write_text(
                "#!/usr/bin/env bash\nset -u\n"
                f'nix shell nixpkgs#lua5_4 -c lua "{harness_path}"\n',
                encoding="utf-8",
            )
            proc = subprocess.run(
                [str(HOSTRUN), str(wrapper_path)],
                capture_output=True,
                text=True,
                timeout=180,
            )
            self.assertEqual(
                0,
                proc.returncode,
                f"{prefix} harness failed:\n{proc.stdout}\n{proc.stderr}",
            )
            self.assertIn(token, proc.stdout, f"{proc.stdout}\n{proc.stderr}")
        finally:
            shutil.rmtree(tmpdir, ignore_errors=True)

    def test_director_static_surface(self) -> None:
        """director.lua is pure Lua and exports the agreed wiring contract."""
        src = (RACECAM / "director.lua").read_text(encoding="utf-8")
        for needle in (
            "D.MODES = { off = true, shots = true, full = true }",
            "function D.normalize_mode(",
            "function D.new(",
            "function D:reset()",
            "function D:note_manual_shot(now)",
            "function D:note_manual_target(now)",
            "function D:override_remaining(now)",
            "function D:step(snap)",
        ):
            with self.subTest(needle=needle):
                self.assertIn(needle, src, f"director.lua missing {needle}")
        for forbidden in (
            "FindAllOf", "FindFirstOf", "StaticFindObject", "GetCachedWorld",
            "LoopInGameThread", "os.getenv", "io.open", "require(",
        ):
            with self.subTest(forbidden=forbidden):
                self.assertNotIn(forbidden, src, f"director.lua must not use {forbidden}")

    def test_lua_director_close_battle_beats_lonely_leader(self) -> None:
        """Close battle + air-time decay win; stopped cars are filtered out."""
        self._run_director_harness(
            AUTO_DIRECTOR_BATTLE_HARNESS, "AUTO_DIRECTOR_BATTLE_OK", "autobattle"
        )

    def test_lua_director_overtake_and_finish_sprint(self) -> None:
        """Rank swap cuts instantly; final lap locks finish_line (or fallback)."""
        self._run_director_harness(
            AUTO_DIRECTOR_SPRINT_HARNESS, "AUTO_DIRECTOR_SPRINT_OK", "autosprint"
        )

    def test_lua_director_hold_and_hysteresis(self) -> None:
        """Equal alternating battles never ping-pong; shot cuts respect 4.5 s."""
        self._run_director_harness(
            AUTO_DIRECTOR_HOLD_HARNESS, "AUTO_DIRECTOR_HOLD_OK", "autohold"
        )

    def test_lua_director_manual_override_pauses(self) -> None:
        """Manual shot/target clicks pause the director for 15 s, no fighting."""
        self._run_director_harness(
            AUTO_DIRECTOR_OVERRIDE_HARNESS, "AUTO_DIRECTOR_OVERRIDE_OK", "autooverride"
        )

    def test_lua_director_remote_target_shot_pool(self) -> None:
        """Remote targets avoid onboard_tcam/side_tracking; streamed ones may use them."""
        self._run_director_harness(
            AUTO_DIRECTOR_REMOTE_HARNESS, "AUTO_DIRECTOR_REMOTE_OK", "autoremote"
        )


if __name__ == "__main__":
    unittest.main(verbosity=2)
