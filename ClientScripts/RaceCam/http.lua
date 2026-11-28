-- RaceCam/http.lua — local HTTP control panel for AMC RaceCam.
-- Non-blocking LuaSocket server: all request work happens on the game thread in short slices.
-- Broadcast-grade features: heartbeat fail-safe, JSONL audit log, engine status passthrough,
-- and an operator panel with OBS WebSocket v5 control, tally, cue queue and rehearsal mode.
local Paths = require("RaceCam/paths")
local LiveEvents = require("RaceCam/live_events")
local H = {}
local D = Paths.data_dir()

-- Names listed by the overlay's background directory watcher (or injected by
-- the host Lua test harness). Nothing here enumerates the filesystem on the
-- game thread — that would flash a cmd.exe window on Windows.
local inbox_files = {}

local SAFE_JSON_NAME = "^[A-Za-z0-9._-]+%.json$"

--- Strict allow-list: only a single flat basename ending in .json is legal.
--- The regex already excludes path separators and NUL; the extra checks reject
--- `..` sequences that the regex alone would accept (e.g. `..json`).
---@param name any
---@return boolean
local function valid_json_name(name)
  return type(name) == "string"
    and name:match(SAFE_JSON_NAME) ~= nil
    and not name:find("%.%.")
    and not name:find("/")
    and not name:find("\\")
    and not name:find("%z")
end

--- Replace the advertised inbox listing. Invalid entries are dropped instead
--- of rejected so a buggy producer can never smuggle a traversal name through.
---@param list table?
function H.set_inbox_files(list)
  inbox_files = {}
  if type(list) ~= "table" then return end
  for _, name in ipairs(list) do
    if valid_json_name(name) then
      inbox_files[#inbox_files + 1] = name
    end
  end
end

local socket = require("socket")

local okj, JsonLib = pcall(require, "JsonParser")
local Json = (okj and type(JsonLib) == "table" and JsonLib) or nil

-- init.lua requires http.lua at boot, so resolve it lazily (after init has
-- finished loading) instead of at module scope: no circular require.
local function get_init()
  if type(_G.RACECAM_INIT) == "table" then return _G.RACECAM_INIT end
  local ok, mod = pcall(require, "RaceCam/init")
  if ok and type(mod) == "table" then return mod end
  return nil
end

local function json_encode(v)
  if Json and type(Json.stringify) == "function" then
    local ok, s = pcall(Json.stringify, v)
    if ok and s then return s end
  end
  return '{"error":"json unavailable"}'
end

local function parse_json(body)
  if not Json or type(Json.parse) ~= "function" then return nil end
  local ok, obj = pcall(Json.parse, body or "")
  if ok and type(obj) == "table" then
    if Json.null and obj == Json.null then return nil end
    return obj
  end
  return nil
end

local function readfile(path)
  local f = io.open(path, "r"); if not f then return nil end
  local c = f:read("*a"); f:close()
  return c and c:gsub("^%s+", ""):gsub("%s+$", "")
end

local server = nil
local pending = {}
local last_result = "idle"

-- Heartbeat fail-safe state: armed by the first authenticated request, so the
-- panel only becomes load-bearing once an operator is actually watching.
local hb_armed = false
local hb_last_seen = 0
local degraded = false
local degraded_reported = false
local timeout_cache = { v = 120, t = 0 }

local function log(s)
  if _G.RACECAM_LOG == 1 then
    local o = io.open(D .. "http.txt", "a"); if o then o:write(s .. "\n"); o:close() end
  end
end

local function jstr(s)
  s = tostring(s or "")
  s = s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\r\n", " "):gsub("\r", " "):gsub("\n", " "):gsub("\t", " ")
  return s
end

local function active_shot_id()
  local e = _G.RACECAM_SHOTS
  return e and e.active and e.active.id or "none"
end

-- Audit log: one small JSON line per command. Never logs IPs or token values.
local function audit(event, cmd, result)
  local path = D .. "events.jsonl"
  local f = io.open(path, "r")
  if f then
    local pos = f:seek("end")
    if pos and pos > 1048576 then
      f:close()
      pcall(function()
        os.remove(D .. "events.1.jsonl")
        os.rename(path, D .. "events.1.jsonl")
      end)
    else
      f:close()
    end
  end
  local line = '{"ts":"' .. os.date("!%Y-%m-%dT%H:%M:%SZ") .. '","event":"' .. jstr(event) ..
    '","cmd":"' .. jstr(cmd) .. '","result":"' .. jstr(result) ..
    '","active_shot":"' .. jstr(active_shot_id()) .. '"}\n'
  local f = io.open(D .. "events.jsonl", "a")
  if f then f:write(line); f:close() end
end

local function hb_timeout()
  local now = os.time()
  if now - timeout_cache.t > 5 then
    timeout_cache.v = tonumber(readfile(D .. "racecam_timeout.txt")) or 120
    if timeout_cache.v <= 0 then timeout_cache.v = 120 end
    timeout_cache.t = now
  end
  return timeout_cache.v
end

-- Called on every authenticated request; refreshes the heartbeat window.
-- Degraded clears only after the panel has seen the degraded state at least
-- once, so the operator's banner is actually displayed before recovery.
local function touch()
  hb_last_seen = os.time()
  hb_armed = true
  if degraded then
    local core = _G.RACECAM_CORE
    if core and core.running then
      degraded = false
      degraded_reported = false
      last_result = "recovered"
      audit("restored", "heartbeat", "operator back online")
    end
  end
end

-- Fail-safe: if no authenticated request inside the timeout window, stop the
-- shot engine exactly once and flip to degraded until the heartbeat returns.
local function fail_safe_tick()
  if not hb_armed or degraded then return end
  if os.time() - hb_last_seen > hb_timeout() then
    degraded = true
    local e = _G.RACECAM_SHOTS
    if e and type(e.stop) == "function" then
      pcall(function() e:stop() end)
    end
    if _G.RACECAM_CORE and type(_G.RACECAM_CORE.stop) == "function" then
      pcall(function() _G.RACECAM_CORE:stop() end)
    end
    last_result = "FAILSAFE no heartbeat"
    audit("degraded", "failsafe_stop", "no heartbeat for " .. tostring(hb_timeout()) .. "s; shots stopped")
  end
end

-- Panel markup lives in its own module so the UI can be owned/edited
-- independently of the HTTP plumbing. Fail closed with a tiny placeholder.
local ok_ui, ui = pcall(require, "RaceCam/panel_ui")
local PANEL = (ok_ui and ui and ui.HTML) or "<html><body>RaceCam Panel UI missing</body></html>"

local function engine_status()
  local e = _G.RACECAM_SHOTS
  if not e then return nil end
  local ok, st = pcall(function() return e:status() end)
  if ok and type(st) == "table" then return st end
  return nil
end

local function id_of(v)
  if type(v) == "table" then return tostring(v.id or v.name or "") end
  return tostring(v)
end

local function idlist(t)
  local q = {}
  for _, v in ipairs(t) do q[#q + 1] = '"' .. jstr(id_of(v)) .. '"' end
  return "[" .. table.concat(q, ",") .. "]"
end

local function speclist(t)
  local q = {}
  for _, v in ipairs(t) do
    if type(v) == "table" then
      local id = '"' .. jstr(tostring(v.id or "")) .. '"'
      q[#q + 1] = v.at_t and ('{"id":' .. id .. ',"at_t":' .. tostring(v.at_t) .. '}') or ('{"id":' .. id .. '}')
    else
      q[#q + 1] = '{"id":"' .. jstr(id_of(v)) .. '"}'
    end
  end
  return "[" .. table.concat(q, ",") .. "]"
end

--- Compact JSON for one active leaderboard (never includes waypoints[]).
local function standings_json(s)
  if not s then return "null" end
  local parts = {}
  parts[#parts + 1] = '"event_name":"' .. jstr(s.event_name) .. '"'
  parts[#parts + 1] = '"event_guid":"' .. jstr(s.event_guid) .. '"'
  parts[#parts + 1] = '"state":' .. tostring(tonumber(s.state) or 0)
  parts[#parts + 1] = '"in_countdown":' .. tostring(s.in_countdown and true or false)
  parts[#parts + 1] = '"num_laps":' .. tostring(tonumber(s.num_laps) or 0)
  parts[#parts + 1] = '"waypoint_count":' .. tostring(tonumber(s.waypoint_count) or 0)
  local rows = {}
  for _, r in ipairs(s.standings or {}) do
    rows[#rows + 1] = '{"rank":' .. tostring(tonumber(r.rank) or 0) ..
      ',"name":"' .. jstr(r.name) .. '"' ..
      ',"laps":' .. tostring(tonumber(r.laps) or 0) ..
      ',"section":' .. tostring(tonumber(r.section) or 0) ..
      ',"best_lap_s":' .. tostring(tonumber(r.best_lap_s) or 0) ..
      ',"last_sec_s":' .. tostring(tonumber(r.last_sec_s) or 0) ..
      ',"finished":' .. tostring(r.finished and true or false) ..
      ',"disqualified":' .. tostring(r.disqualified and true or false) .. '}'
  end
  parts[#parts + 1] = '"standings":[' .. table.concat(rows, ",") .. ']'
  return "{" .. table.concat(parts, ",") .. "}"
end

local function state_json()
  local e = _G.RACECAM_SHOTS
  local st = engine_status()
  local parts = {}
  if degraded then degraded_reported = true end
  local cur = (st and (st.shot or st.current)) or (e and e.active and e.active.id or "none")
  local nxt = st and (st.next_shot or st.next) or nil
  local fov = e and e.last and e.last.fov or 0
  parts[#parts + 1] = '"active_shot":"' .. jstr(id_of(cur)) .. '"'
  parts[#parts + 1] = '"fov":' .. tostring(tonumber(fov) or 0)
  local plan_id = (e and e.plan and e.plan.source and e.plan.source.plan_id) or (e and e.plan and e.plan.name) or "unknown"
  parts[#parts + 1] = '"plan":"' .. jstr(tostring(plan_id)) .. '"'
  local tname = (e and e.target_name) or (st and st.target_name) or nil
  if tname and tname ~= "" then
    parts[#parts + 1] = '"target_name":"' .. jstr(tostring(tname)) .. '"'
  else
    parts[#parts + 1] = '"target_name":null'
  end
  if st and st.target_lost ~= nil then parts[#parts + 1] = '"target_lost":' .. tostring(st.target_lost) end
  if st and st.target_lost_for then parts[#parts + 1] = '"target_lost_for":' .. string.format("%.1f", st.target_lost_for) end
  parts[#parts + 1] = '"result":"' .. jstr(last_result) .. '"'
  parts[#parts + 1] = '"last_result":"' .. jstr(last_result) .. '"'
  parts[#parts + 1] = '"degraded":' .. tostring(degraded)
  parts[#parts + 1] = '"running":' .. tostring(_G.RACECAM_CORE and _G.RACECAM_CORE.running and true or false)
  if hb_armed then
    parts[#parts + 1] = '"heartbeat_age":' .. tostring(os.time() - hb_last_seen)
  else
    parts[#parts + 1] = '"heartbeat_age":null'
  end
  parts[#parts + 1] = '"rehearsal":' .. tostring(_G.RACECAM_CORE and _G.RACECAM_CORE.rehearsal and true or false)
  local init = get_init()
  parts[#parts + 1] = '"auto_start":' .. tostring(init and init.auto_start and true or false)
  parts[#parts + 1] = '"follow_leader":' .. tostring(init and init.follow_leader and true or false)
  parts[#parts + 1] = '"director_mode":"' .. jstr((init and init.director_mode) or "off") .. '"'
  parts[#parts + 1] = '"director_reason":"' .. jstr((init and init.director_reason) or "") .. '"'
  parts[#parts + 1] = '"director_override_s":' ..
    tostring(tonumber((init and init.director_override_s) or 0) or 0)
  parts[#parts + 1] = '"hud_mode":"' .. jstr((init and init.hud_mode) or "full") .. '"'
  local smoothing = (e and e.smoothing_mode) or (init and init.smoothing_mode) or "normal"
  if type(smoothing) ~= "string" or smoothing == "" then smoothing = "normal" end
  parts[#parts + 1] = '"smoothing":"' .. jstr(smoothing) .. '"'
  local ok_ev, ev = pcall(function() return LiveEvents.current_event() end)
  parts[#parts + 1] = '"active_event":' ..
    ((ok_ev and ev and ev.name and ev.name ~= "") and ('"' .. jstr(ev.name) .. '"') or "null")
  -- Live leaderboard: cached 500 ms in live_events.lua, no waypoints copied.
  local ok_s, active_standings = pcall(function() return LiveEvents.active_standings() end)
  parts[#parts + 1] = '"standings":' .. (ok_s and standings_json(active_standings) or "null")
  local targets = {}
  if e and type(e.list_targets) == "function" then
    local ok, found = pcall(function() return e:list_targets() end)
    if ok and type(found) == "table" then targets = found end
  end
  parts[#parts + 1] = '"targets":' .. idlist(targets)
  if st then
    if cur ~= nil then parts[#parts + 1] = '"current":"' .. jstr(id_of(cur)) .. '"' end
    if nxt ~= nil then parts[#parts + 1] = '"next":"' .. jstr(id_of(nxt)) .. '"' end
    local cd = tonumber(st.countdown)
    if cd then parts[#parts + 1] = '"countdown":' .. string.format("%.2f", cd) end
    if type(st.queue) == "table" then
      parts[#parts + 1] = '"queue":' .. idlist(st.queue)
      parts[#parts + 1] = '"queue_spec":' .. speclist(st.queue)
    end
    local ids = {}
    if e and e.plan and type(e.plan.shots) == "table" then
      for _, s in ipairs(e.plan.shots) do ids[#ids + 1] = s.id end
    elseif type(st.shots) == "table" then
      ids = st.shots
    end
    if #ids > 0 then parts[#parts + 1] = '"shots":' .. idlist(ids) end
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function json_field(body, key)
  local pat = '"' .. key .. '"%s*:%s*"'
  local _, s = body:find(pat)
  if not s then return nil end
  local i, out = s + 1, {}
  while i <= #body do
    local c = body:sub(i, i)
    if c == '"' then break
    elseif c == '\\' then
      local n = body:sub(i + 1, i + 1)
      if n == "n" then out[#out + 1] = "\n"
      elseif n == "r" then out[#out + 1] = "\r"
      elseif n == "t" then out[#out + 1] = "\t"
      else out[#out + 1] = n end
      i = i + 2
    else
      out[#out + 1] = c
      i = i + 1
    end
  end
  return table.concat(out)
end

local function parse_queue(s)
  local list = {}
  for obj in tostring(s or ""):gmatch("{(.-)}") do
    local id = obj:match('"id"%s*:%s*"([^"]+)"')
    local at = tonumber(obj:match('"at_t"%s*:%s*([%d%.%-]+)'))
    if id then list[#list + 1] = { id = id, at_t = at } end
  end
  if #list > 0 then return list end
  local ids = {}
  for id in tostring(s or ""):gmatch('"([^"]+)"') do ids[#ids + 1] = id end
  if #ids == 0 then
    for id in tostring(s or ""):gmatch("[^%s,%[%]{}:]+") do ids[#ids + 1] = id end
  end
  return ids
end

local function dispatch(item)
  local e, core = _G.RACECAM_SHOTS, _G.RACECAM_CORE
  if not e or not core then return "NOENGINE" end
  local cmd, args = item.cmd, item.args or ""
  if cmd == "start" then e:signal("start"); return "started"
  elseif cmd == "stop" then
    core.stop()
    local init = get_init()
    if init and type(init.set_hud_mode) == "function" and init.hud_mode ~= "full" then
      pcall(function() init.set_hud_mode("full") end)
    end
    return "stopped"
  elseif cmd == "hud" then
    local init = get_init()
    if init and type(init.set_hud_mode) == "function" then
      local ok, applied = pcall(function() return init.set_hud_mode(args) end)
      if ok and applied then return "hud:" .. applied end
    end
    return "ERR invalid hud mode"
  elseif cmd == "arm" then
    if core.running then return "already armed" end
    local ok, r = pcall(function() return core.restart() end)
    if ok then return "rearmed " .. tostring(r or "ok") end
    return "ERR " .. tostring(r)
  elseif cmd == "rehearsal" then
    core.rehearsal = (args == "on" or args == "true" or args == "1")
    e:log("REHEARSAL " .. (core.rehearsal and "on" or "off"))
    return core.rehearsal and "rehearsal on" or "rehearsal off"
  elseif cmd == "trigger" or cmd == "shot" or cmd == "cue" then return e:manual(args)
  elseif cmd == "select" then
    local name_err = "no target API"
    if type(e.set_target_by_name) == "function" then
      local ok, selok, msg = pcall(function() return e:set_target_by_name(args) end)
      if ok and selok then return tostring(msg or ("target " .. args)) end
      name_err = ok and tostring(msg) or tostring(selok)
    end
    local idx = tonumber(args)
    if idx and type(e.set_target_by_index) == "function" then
      local r = e:set_target_by_index(idx)
      if r and not tostring(r):match("^no pawn") then return tostring(r) end
      name_err = tostring(r)
    end
    return "ERR " .. name_err
  elseif cmd == "next" then
    if type(e.queue_next) == "function" then
      local ok, r = pcall(function() return e:queue_next() end)
      if ok then return tostring(r or "queued next") end
      return "ERR " .. tostring(r)
    end
    return "NOQUEUE"
  elseif cmd == "queue" then
    if type(e.queue) == "function" then
      local ok, r = pcall(function() return e:queue(parse_queue(args)) end)
      if ok then return tostring(r or "queued") end
      return "ERR " .. tostring(r)
    end
    return "NOQUEUE"
  elseif cmd == "queue_clear" then
    if type(e.queue_clear) == "function" then
      local ok, r = pcall(function() return e:queue_clear() end)
      if ok then return tostring(r or "queue cleared") end
      return "ERR " .. tostring(r)
    end
    return "NOQUEUE"
  elseif cmd == "status" then return "ok"
  end
  return "unknown " .. jstr(cmd)
end

--- Decode application/x-www-form-urlencoded query values, including `%00`.
local function url_decode(s)
  s = tostring(s or "")
  s = s:gsub("+", " ")
  s = s:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
  return s
end

local function query_value(path, key)
  local q = path:match("%?(.*)$")
  if not q then return nil end
  for part in q:gmatch("[^&]+") do
    local k, v = part:match("^([^=]+)=(.*)$")
    if k == key then return url_decode(v) end
  end
  return nil
end

local function vec_xyz(v)
  if type(v) ~= "table" then return nil end
  local x, y, z = tonumber(v.X or v.x), tonumber(v.Y or v.y), tonumber(v.Z or v.z)
  if not x or not y or not z then return nil end
  return x, y, z
end

local function pose_from(loc, rot)
  if not loc or not rot then return nil end
  local x, y, z = vec_xyz(loc)
  if not x then return nil end
  local yaw = tonumber(rot.Yaw or rot.yaw)
  if not yaw then return nil end
  return { x = x, y = y, z = z, yaw = yaw }
end

--- Best-effort local pawn/camera pose. Every UE4SS call is pcall-guarded so a
--- missing global or invalid UObject can never break the HTTP tick. `M._pos_provider`
--- is a test seam for the Lua 5.4 host harness (and harmless in production).
local function local_pose()
  local ok, res = pcall(function()
    local pc = type(GetMyPlayerController) == "function" and GetMyPlayerController() or nil
    if not pc then return nil end
    if type(pc.IsValid) == "function" and pc:IsValid() == false then return nil end
    local pawn = pc.Pawn
    if not pawn and type(pc.GetPawn) == "function" then pawn = pc:GetPawn() end
    if not pawn then return nil end
    if type(pawn.IsValid) == "function" and pawn:IsValid() == false then return nil end
    local loc = type(pawn.K2_GetActorLocation) == "function" and pawn:K2_GetActorLocation() or nil
    local rot = type(pawn.K2_GetActorRotation) == "function" and pawn:K2_GetActorRotation() or nil
    return pose_from(loc, rot)
  end)
  if ok and type(res) == "table" then return res end

  local okc, cres = pcall(function()
    local mgr = nil
    if type(_G.PlayerCameraManager) == "function" then
      mgr = _G.PlayerCameraManager()
    elseif type(_G.PlayerCameraManager) == "table" then
      mgr = _G.PlayerCameraManager
    elseif type(_G.GetPlayerCameraManager) == "function" then
      mgr = _G.GetPlayerCameraManager()
    end
    if not mgr then return nil end
    if type(mgr.IsValid) == "function" and mgr:IsValid() == false then return nil end
    local loc = type(mgr.GetCameraLocation) == "function" and mgr:GetCameraLocation() or nil
    local rot = type(mgr.GetCameraRotation) == "function" and mgr:GetCameraRotation() or nil
    return pose_from(loc, rot)
  end)
  if okc and type(cres) == "table" then return cres end
  return nil
end

local function make_response(req)
  if req.too_large then
    local b = '{"error":"body too large"}'
    return "HTTP/1.1 413 Payload Too Large\r\nContent-Type: application/json\r\nContent-Length: " ..
      #b .. "\r\nConnection: close\r\n\r\n" .. b
  end
  local token = Paths.read_token()
  local code, body, ctype = 400, '{"error":"not found"}', "application/json"
  local authed = false
  if req.method == "GET" and (req.path == "/" or req.path == "/index.html") then
    code, body, ctype = 200, PANEL, "text/html"
  elseif not token or token == "" or req.headers["x-racecam-token"] ~= token then
    body = '{"error":"bad token"}'
  elseif req.method == "GET" and req.path == "/api/state" then
    authed = true
    touch()
    code, body = 200, state_json()
  elseif req.method == "GET" and req.path == "/api/live_events" then
    authed = true
    touch()
    local ok, events = pcall(function() return LiveEvents.list() end)
    code, body = 200, json_encode({ events = (ok and type(events) == "table") and events or {} })
  elseif req.method == "GET" and req.path == "/api/inbox" then
    authed = true
    touch()
    local has_drop = false
    local ok, f = pcall(io.open, Paths.drop_file(), "rb")
    if ok and f then
      has_drop = true
      pcall(function() f:close() end)
    end
    code, body = 200, json_encode({ files = inbox_files, has_drop_file = has_drop })
  elseif req.method == "GET" and (req.path == "/api/inbox_file" or req.path:match("^/api/inbox_file%?")) then
    authed = true
    touch()
    local name = query_value(req.path, "name")
    local target = nil
    if name == "drop_event.json" then
      target = Paths.drop_file()
    elseif valid_json_name(name) then
      target = Paths.inbox_dir() .. name
    else
      code, body = 400, '{"error":"invalid filename"}'
    end
    if target then
      local ok, f = pcall(io.open, target, "rb")
      if not ok or not f then
        code, body = 404, '{"error":"not found"}'
      else
        local okr, content = pcall(f.read, f, 512 * 1024 + 1)
        pcall(function() f:close() end)
        if not okr or type(content) ~= "string" then
          code, body = 404, '{"error":"not found"}'
        elseif #content > 512 * 1024 then
          code, body = 413, '{"error":"file too large"}'
        else
          code, body, ctype = 200, content, "application/json"
        end
      end
    end
  elseif req.method == "GET" and req.path == "/api/my_pos" then
    authed = true
    touch()
    local pose = nil
    local hook_ok, hook_pose = pcall(function()
      return type(H._pos_provider) == "function" and H._pos_provider() or nil
    end)
    if hook_ok and type(hook_pose) == "table" then
      pose = {
        x = tonumber(hook_pose.x), y = tonumber(hook_pose.y),
        z = tonumber(hook_pose.z), yaw = tonumber(hook_pose.yaw),
      }
    end
    if not (pose and pose.x and pose.y and pose.z and pose.yaw) then
      pose = local_pose()
    end
    if pose and pose.x and pose.y and pose.z and pose.yaw then
      code, body = 200, json_encode({
        ok = true, x = pose.x, y = pose.y, z = pose.z, yaw = pose.yaw,
      })
    else
      code, body = 503, '{"ok":false,"error":"no local pawn or camera"}'
    end
  elseif req.method == "GET" and req.path == "/api/plans" then
    authed = true
    touch()
    local init = get_init()
    local ok, result = pcall(function() return init.list_plans() end)
    if ok and type(result) == "table" then
      code, body = 200, json_encode(result)
    else
      code, body = 500, '{"error":"plans unavailable"}'
    end
  elseif req.method == "POST" and req.path == "/api/plan" then
    authed = true
    touch()
    local payload = parse_json(req.body)
    local pid = payload and payload.plan_id
    if type(pid) ~= "string" or not pid:match("^[A-Za-z0-9_%-]+$") or type(payload.plan) ~= "table" then
      code, body = 400, '{"error":"invalid plan"}'
    else
      local route = payload.route
      if Json and route == Json.null then route = nil end
      local init = get_init()
      local ok, saved = pcall(function() return init.reload_plan(pid, payload.plan, route) end)
      if ok and saved then
        code, body = 200, '{"ok":true,"plan_id":"' .. jstr(pid) .. '"}'
        audit("plan", pid, "hot-reloaded")
      else
        code, body = 400, '{"error":"' .. jstr(tostring(saved)) .. '"}'
      end
    end
  elseif req.method == "POST" and req.path == "/api/auto_flags" then
    authed = true
    touch()
    local payload = parse_json(req.body)
    if not payload then
      code, body = 400, '{"error":"invalid json"}'
    else
      local init = get_init()
      local ok, flags = pcall(function()
        return init.set_auto_flags({ auto_start = payload.auto_start, follow_leader = payload.follow_leader })
      end)
      if ok and type(flags) == "table" then
        code, body = 200, json_encode({
          ok = true,
          auto_start = flags.auto_start and true or false,
          follow_leader = flags.follow_leader and true or false,
        })
        audit("auto_flags", "", tostring(flags.auto_start) .. "/" .. tostring(flags.follow_leader))
      else
        code, body = 400, '{"error":"' .. jstr(tostring(flags)) .. '"}'
      end
    end
  elseif req.method == "POST" and req.path == "/api/command" then
    authed = true
    touch()
    local cmd = json_field(req.body, "cmd") or ""
    local args = json_field(req.body, "args") or ""
    if cmd == "smoothing" then
      -- Operator preset: tight | normal | cinematic. Validated here as well
      -- as in init.lua so a malformed panel request can never reach the rig.
      if args ~= "tight" and args ~= "normal" and args ~= "cinematic" then
        code, body = 400, '{"ok":false,"error":"invalid smoothing mode"}'
        last_result = "ERR invalid smoothing mode"
        audit("command", cmd, last_result)
      else
        local init = get_init()
        local applied = false
        if init and type(init.set_smoothing_mode) == "function" then
          local ok, setok = pcall(function() return init.set_smoothing_mode(args) end)
          applied = (ok and setok ~= false)
        elseif _G.RACECAM_SHOTS then
          -- Engine-only fallback when init has not armed yet: persist on the
          -- live engine, init will pick it up on the next arming pass.
          _G.RACECAM_SHOTS.smoothing_mode = args
          applied = true
        end
        if not applied then
          code, body = 400, '{"ok":false,"error":"smoothing unavailable"}'
          last_result = "ERR smoothing unavailable"
        else
          last_result = "smoothing:" .. args
          code, body = 200, '{"ok":true,"status":"smoothing:' .. jstr(args) ..
            '","smoothing":"' .. jstr(args) .. '"}'
        end
        log("CMD " .. cmd .. " " .. args .. " -> " .. last_result)
        audit("command", cmd, last_result)
      end
    elseif cmd == "hud" then
      local mode = string.lower(tostring(args or ""))
      if mode ~= "full" and mode ~= "tags_only" and mode ~= "clean" then
        code, body = 400, '{"ok":false,"error":"invalid mode"}'
        last_result = "ERR invalid mode"
        audit("command", cmd, last_result)
      else
        local init = get_init()
        if init then init.hud_mode = mode end
        enqueue("hud", mode)
        last_result = "hud:" .. mode
        code, body = 200, '{"ok":true,"status":"hud:' .. jstr(mode) ..
          '","hud_mode":"' .. jstr(mode) .. '"}'
        log("CMD hud " .. mode .. " -> queued")
        audit("command", cmd, last_result)
      end
    elseif cmd == "director" then
      -- Off | Shots | Full. init validates case-insensitively; anything else
      -- is rejected here so the operator can never leave a stale mode behind.
      local init = get_init()
      local mode = nil
      if init and type(init.set_director_mode) == "function" then
        local ok, applied = pcall(function() return init.set_director_mode(args) end)
        if ok then mode = applied end
      end
      if not mode then
        code, body = 400, '{"ok":false,"error":"invalid mode"}'
        last_result = "ERR invalid mode"
        audit("command", cmd, last_result)
      else
        last_result = "director:" .. mode
        code, body = 200, '{"ok":true,"status":"director:' .. jstr(mode) ..
          '","director_mode":"' .. jstr(mode) .. '"}'
        audit("command", cmd, last_result)
      end
      log("CMD " .. cmd .. " " .. args .. " -> " .. last_result)
    else
      local manual_shot = (cmd == "trigger" or cmd == "shot" or cmd == "cue" or cmd == "next")
      local ok, result = pcall(dispatch, { cmd = cmd, args = args })
      if manual_shot then
        local init = get_init()
        if init and type(init.note_manual_shot) == "function" then
          pcall(function() init.note_manual_shot() end)
        end
      end
      last_result = ok and tostring(result) or ("ERR " .. tostring(result))
      log("CMD " .. cmd .. " " .. args .. " -> " .. last_result)
      audit("command", cmd, last_result)
      code, body = 200, '{"status":"' .. jstr(last_result) .. '"}'
    end
  elseif req.method == "POST" and req.path == "/api/target" then
    authed = true
    touch()
    -- Manual "follow this driver" click. json_field keeps this working even
    -- when JsonParser is unavailable on the client.
    local name = json_field(req.body, "name") or json_field(req.body, "target")
    if type(name) ~= "string" or name == "" then
      code, body = 400, '{"error":"invalid target"}'
    else
      local e = _G.RACECAM_SHOTS
      local ok, selok, msg = false, nil, nil
      if e and type(e.set_target_by_name) == "function" then
        ok, selok, msg = pcall(function() return e:set_target_by_name(name) end)
      end
      if ok and selok then
        code, body = 200, '{"ok":true,"target":"' .. jstr(name) .. '"}'
        -- The producer chose a driver explicitly; automation must not yank
        -- the camera back to the leader on the next tick.
        local init = get_init()
        if init and type(init.disengage_follow_leader) == "function" then
          pcall(function() init.disengage_follow_leader() end)
        end
        -- A manual contestant click pauses Auto Director target switching.
        if init and type(init.note_manual_target) == "function" then
          pcall(function() init.note_manual_target() end)
        end
        audit("target", name, "manual target; follow_leader disengaged")
      else
        code, body = 400, '{"error":"' .. jstr(tostring(ok and msg or selok)) .. '"}'
      end
    end
  end
  local reasons = {
    [200] = "OK", [400] = "Bad Request", [404] = "Not Found",
    [413] = "Payload Too Large", [500] = "Internal Server Error",
    [503] = "Service Unavailable",
  }
  local reason = reasons[code] or "Bad Request"
  return "HTTP/1.1 " .. code .. " " .. reason .. "\r\nContent-Type: " .. ctype ..
    "\r\nContent-Length: " .. #body .. "\r\nConnection: close\r\n\r\n" .. body
end

local function parse_request(buf)
  local head, body = buf:match("^(.-)\r?\n\r?\n(.*)$")
  if not head then return nil, nil end
  local headers = {}
  for line in head:gmatch("[^\r\n]+") do
    local k, v = line:match("^([^:]+):%s*(.+)$")
    if k then headers[k:lower()] = v end
  end
  local method, path = head:match("^(%u+)%s+(%S+)")
  local len = tonumber(headers["content-length"] or "0") or 0
  if len > 524288 then
    return { method = method, path = path, headers = headers, body = "", too_large = true }, headers
  end
  if #body < len then return nil, headers end
  return { method = method, path = path, headers = headers, body = body:sub(1, len) }, headers
end

local function pump(conn)
  local skt = conn.skt
  skt:settimeout(0)

  if not conn.response then
    -- Drain up to 64 KB per tick so large route POSTs finish in < 0.4 s
    -- without monopolising the game thread. Buffered body capped at 512 KB.
    local drained = 0
    while drained < 65536 and #conn.buf < 524288 do
      local want = math.min(16384, 65536 - drained, 524288 - #conn.buf)
      local data, err, last = skt:receive(want)
      local chunk = data or last
      if not chunk or chunk == "" then break end
      conn.buf = conn.buf .. chunk
      drained = drained + #chunk
    end
    -- Honour Expect: 100-continue on the first tick that has the headers,
    -- before parse_request runs, so the client sends its body immediately.
    if not conn.expect_done and conn.buf:find("\r\n\r\n", 1, true) then
      local head = conn.buf:match("^(.-)\r?\n\r?\n")
      if head and head:lower():find("expect:%s*100%-continue") then
        pcall(function() skt:send("HTTP/1.1 100 Continue\r\n\r\n") end)
      end
      conn.expect_done = true
    end
    local req, headers = parse_request(conn.buf)
    if req then
      conn.response = make_response(req)
      conn.buf = ""
    elseif headers and os.time() - conn.t0 > 3 then
      return nil
    end
  end

  if conn.response then
    local sent, err, last = skt:send(conn.response)
    local n = tonumber(sent) or tonumber(last) or 0
    if n > 0 then conn.response = conn.response:sub(n + 1) end
    if conn.response == "" then skt:close(); return nil end
  end

  if os.time() - conn.t0 > 5 then skt:close(); return nil end
  return conn
end

function H.tick()
  if not server then return false end
  for _ = 1, 8 do
    local skt = server:accept()
    if not skt then break end
    pending[#pending + 1] = { skt = skt, buf = "", t0 = os.time() }
  end
  for i = #pending, 1, -1 do
    local ok, alive = pcall(pump, pending[i])
    if not ok then log("PUMPERR " .. tostring(alive)) end
    if not ok or not alive then
      pcall(function() pending[i].skt:close() end)
      table.remove(pending, i)
    end
  end
  fail_safe_tick()
  return true
end

function H.stop()
  if server then pcall(function() server:close() end); server = nil end
  for _, c in ipairs(pending) do pcall(function() c.skt:close() end) end
  pending = {}
  _G.RACECAM_HTTP = nil
  return "stopped"
end

function H.start()
  if server then return "already started" end
  local host = readfile(D .. "racecam_bind.txt") or "127.0.0.1"
  local ok, s = pcall(function()
    local b = assert(socket.bind(host, 8767))
    b:setoption("reuseaddr", true)
    b:settimeout(0)
    return b
  end)
  if not ok then log("BIND " .. tostring(s)); return "BIND " .. tostring(s) end
  server = s
  _G.RACECAM_HTTP = H
  LoopInGameThreadWithDelay(100, H.tick)
  log("HTTP local panel on " .. host .. ":8767 token=" .. tostring(Paths.read_token() ~= nil) ..
    " failsafe_timeout=" .. tostring(hb_timeout()) .. "s")
  return "listening " .. host .. ":8767"
end

-- Test seam for the Lua 5.4 host harness: exercise make_response without
-- binding a socket. Production callers never touch this field.
H._make_response = make_response

return H
