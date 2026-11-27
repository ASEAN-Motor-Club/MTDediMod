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


if __name__ == "__main__":
    unittest.main(verbosity=2)
