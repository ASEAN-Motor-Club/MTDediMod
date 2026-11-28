--- AMC RaceCam admin-only module entry point for MotorTownClientMod.
---
--- Starts the local HTTP operator panel (127.0.0.1:8767, fail-closed on
--- racecam_token.txt) in STANDBY mode without taking over the camera.
--- Camera takeover only occurs when the operator clicks Arm (A) in the panel,
--- and Panic Stop (X) or the 120s heartbeat fail-safe restores the player view.
---
--- Plans may be legacy .lua files or .json files (parsed with JsonParser.lua).
--- Both live side by side; active_plan.txt selects one.

local Paths = require("RaceCam/paths")
local Core = require("RaceCam/core")
local Presets = require("RaceCam/presets")
local Engine = require("RaceCam/shot_engine")
local Http = require("RaceCam/http")
local LiveEvents = require("RaceCam/live_events")

local okj, JsonLib = pcall(require, "JsonParser")
local Json = (okj and type(JsonLib) == "table" and JsonLib) or nil

local M = {
    name = "shot_engine",
    log_every = 5,
    auto_start = false,
    follow_leader = false,
}
_G.RACECAM_INIT = M

local PLAN_ID_PATTERN = "^[A-Za-z0-9_%-]+$"

local automation = {
    last_check = 0.0,
    last_cd = nil,
    last_state = nil,
    last_leader = nil,
    started = {},
}

local function log(fmt, ...)
    if LogOutput then pcall(LogOutput, "INFO", fmt, ...) end
end

local function try_loadlua(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local c = f:read("*a")
    f:close()
    local fn, err = load(c, path)
    if not fn then
        if LogOutput then LogOutput("ERROR", "RaceCam syntax error in %s: %s", path, tostring(err)) end
        return nil
    end
    local ok, res = pcall(fn)
    if not ok then
        if LogOutput then LogOutput("ERROR", "RaceCam load error in %s: %s", path, tostring(res)) end
        return nil
    end
    return res
end

local function active_plan_id(dir)
    local f = io.open(dir .. "active_plan.txt", "r")
    if not f then return nil end
    local id = (f:read("*a") or ""):match("^%s*([A-Za-z0-9_%-]+)")
    f:close()
    return id
end

local function read_json(path)
    local f = io.open(path, "rb")
    if not f then return nil end
    local c = f:read("*a")
    f:close()
    if not c or c == "" or not Json or type(Json.parse) ~= "function" then return nil end
    local ok, v = pcall(Json.parse, c)
    if ok and type(v) == "table" then return v end
    return nil
end

local function write_raw(path, content)
    local f = io.open(path, "wb")
    if not f then return false end
    local ok = pcall(function() f:write(tostring(content)) f:close() end)
    return ok == true
end

--- Minimal JSON encoder used only if JsonParser.lua cannot be loaded.
local function simple_json(v, depth)
    depth = depth or 0
    if depth > 16 then return "null" end
    local t = type(v)
    if t == "nil" then return "null" end
    if t == "boolean" then return v and "true" or "false" end
    if t == "number" then return tostring(v) end
    if t == "string" then
        return '"' .. v:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t") .. '"'
    end
    if t ~= "table" then return '"' .. tostring(v):gsub('"', '\\"') .. '"' end
    local is_array = #v > 0
    local parts = {}
    if is_array then
        for i = 1, #v do parts[#parts + 1] = simple_json(v[i], depth + 1) end
        return "[" .. table.concat(parts, ",") .. "]"
    end
    for k, val in pairs(v) do
        if type(k) == "string" or type(k) == "number" then
            parts[#parts + 1] = '"' .. tostring(k) .. '":' .. simple_json(val, depth + 1)
        end
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

local function json_encode(v)
    if Json and type(Json.stringify) == "function" then
        local ok, s = pcall(Json.stringify, v)
        if ok and s then return s end
    end
    return simple_json(v)
end

local function add_plan_index(plan_id)
    if type(plan_id) ~= "string" or not plan_id:match(PLAN_ID_PATTERN) then return end
    local path = Paths.data_dir() .. "plans_index.json"
    local idx = read_json(path) or {}
    local seen = {}
    if type(idx.plans) == "table" then
        for _, id in ipairs(idx.plans) do
            if type(id) == "string" and id:match(PLAN_ID_PATTERN) then seen[id] = true end
        end
    end
    seen[plan_id] = true
    local list = {}
    for id in pairs(seen) do list[#list + 1] = id end
    table.sort(list)
    write_raw(path, json_encode({ plans = list }))
end

--- Built-in track-independent fallback plan so follow/orbit angles work
--- immediately on any server even before a track plan is generated.
local function default_plan()
    return {
        source = { name = "Default (No Track Plan)", plan_id = "default" },
        shots = {
            { id = "follow_focus", kind = "follow", trigger = { type = "boot" }, target = "focus", preset = "chase_close", fov = 70.0 },
            { id = "heli_follow", kind = "follow", trigger = { type = "manual" }, target = "focus", preset = "heli_follow", fov = 55.0 },
            { id = "front_chase", kind = "follow", trigger = { type = "manual" }, target = "focus", preset = "front_chase", fov = 65.0 },
            { id = "side_tracking", kind = "follow", trigger = { type = "manual" }, target = "focus", preset = "side_tracking", fov = 68.0 },
            { id = "orbit_hero", kind = "orbit", trigger = { type = "manual" }, target = "focus", preset = "orbit_hero", fov = 60.0 },
        },
    }
end

--- Load .json first, then legacy .lua for both plan and route.
local function load_plan_and_route()
    local dir = Paths.data_dir()
    local pid = active_plan_id(dir)
    if pid then
        local plan = read_json(dir .. "plan_" .. pid .. ".json")
            or try_loadlua(dir .. "plan_" .. pid .. ".lua")
        if plan then
            local route = read_json(dir .. "route_" .. pid .. ".json")
                or try_loadlua(dir .. "route_" .. pid .. ".lua")
            return plan, route, pid
        end
    end
    return default_plan(), nil, "default"
end

M.init = function(core)
    local plan, route, pid = load_plan_and_route()
    local e = Engine.new(core, Presets, plan, route)
    _G.RACECAM_SHOTS = e
    M.engine = e
    core.shots = e
    core.last_mode = M
    local pcs = FindAllOf("PlayerController") or {}
    if pcs[1] then
        local ok, pawn = pcall(function() return pcs[1]:K2_GetPawn() end)
        if ok and pawn then e.target = pawn end
    end
    add_plan_index(pid)
    e:log("init plan=" .. tostring(pid) .. " shots=" .. tostring(#(plan.shots or {})))
end

--- Optional live-event automation, throttled to one scan every 0.5 s.
local function automation_tick()
    if not M.auto_start and not M.follow_leader then return end
    local now = os.clock()
    if now - automation.last_check < 0.5 then return end
    automation.last_check = now
    local ok, ev = pcall(function() return LiveEvents.current_event() end)
    if not ok or not ev then
        automation.last_cd, automation.last_state, automation.last_leader = nil, nil, nil
        return
    end

    if M.auto_start then
        local key = ev.guid or ev.name or "event"
        if ev.in_countdown then
            automation.started[key] = nil
        elseif not automation.started[key] then
            local cd_finished = automation.last_cd == true
            local entered_racing = automation.last_state ~= nil
                and ev.state ~= automation.last_state and ev.state > 1
            if cd_finished or entered_racing then
                if pcall(function() M.engine:signal("start") end) then
                    automation.started[key] = true
                    log("RaceCam auto-start on %s", tostring(ev.name))
                end
            end
        end
    end

    if M.follow_leader then
        local leader = ev.leader_name
        if leader and leader ~= automation.last_leader then
            automation.last_leader = leader
            if M.engine and type(M.engine.set_target_by_name) == "function" then
                pcall(function() M.engine:set_target_by_name(leader) end)
            end
        elseif not leader then
            automation.last_leader = nil
        end
    end

    automation.last_cd, automation.last_state = ev.in_countdown, ev.state
end

M.apply = function(core)
    automation_tick()
    if not M.engine then M.init(core) end
    local ok, err = pcall(function() M.engine:update() end)
    if not ok then
        M.engine:log("ERR " .. tostring(err))
        M.engine:apply_last()
    end
end

--- Reload the active plan from disk (e.g. after changing active_plan.txt)
--- without restarting Motor Town.
function M.ReloadPlan()
    local plan, route, pid = load_plan_and_route()
    local e = Engine.new(Core, Presets, plan, route)
    if M.engine then
        e.target_name, e.target_idx, e.target_index = M.engine.target_name, M.engine.target_idx, M.engine.target_index
        e.target = M.engine.target
        e.rehearsal = M.engine.rehearsal
    end
    _G.RACECAM_SHOTS = e
    M.engine = e
    Core.shots = e
    if LogOutput then
        LogOutput("INFO", "RaceCam reloaded plan '%s' (%d shots)", tostring(pid), #(plan.shots or {}))
    end
    return pid
end

--- Persist and hot-swap a plan supplied by the browser panel. The live engine
--- object is updated in place so an armed broadcast keeps its target and
--- rehearsal state; no restart and no re-arm are required.
---@param plan_id string
---@param plan_tbl table
---@param route_tbl table?
---@return string? plan_id
---@return string? error
function M.reload_plan(plan_id, plan_tbl, route_tbl)
    if type(plan_id) ~= "string" or not plan_id:match(PLAN_ID_PATTERN) then
        return nil, "invalid plan_id"
    end
    if type(plan_tbl) ~= "table" then return nil, "invalid plan" end

    local dir = Paths.data_dir()
    Paths.ensure_dir(dir)
    if not write_raw(dir .. "plan_" .. plan_id .. ".json", json_encode(plan_tbl)) then
        return nil, "plan write failed"
    end
    if route_tbl ~= nil then
        if type(route_tbl) ~= "table" then return nil, "invalid route" end
        if not write_raw(dir .. "route_" .. plan_id .. ".json", json_encode(route_tbl)) then
            return nil, "route write failed"
        end
    end
    if not write_raw(dir .. "active_plan.txt", plan_id) then
        return nil, "active_plan write failed"
    end
    add_plan_index(plan_id)

    plan_tbl.source = type(plan_tbl.source) == "table" and plan_tbl.source or {}
    plan_tbl.source.plan_id = plan_id

    local e = M.engine
    if not e then
        e = Engine.new(Core, Presets, plan_tbl, route_tbl)
        M.engine = e
        _G.RACECAM_SHOTS = e
        Core.shots = e
        Core.last_mode = M
    else
        local target_name = e.target_name
        local target_idx = e.target_idx or e.target_index
        local target = e.target
        local rehearsal = Core.rehearsal
        e.plan, e.route = plan_tbl, route_tbl
        e.active, e.transition = nil, nil
        e.wp_index, e.gate_hits = 0, {}
        e.queue_entries, e.queue_spec = {}, nil
        e.target_name = target_name
        e.target_idx, e.target_index = target_idx, target_idx
        e.target = target
        Core.rehearsal = rehearsal
        if e.log then e:log("HOT-RELOAD plan=" .. plan_id .. " shots=" .. tostring(#(plan_tbl.shots or {}))) end
    end
    log("RaceCam hot-reloaded plan '%s' (%d shots)", plan_id, #(plan_tbl.shots or {}))
    return plan_id
end

--- Saved + loaded plan IDs and the active plan (tracked in an index file, no
--- shell directory listing needed).
---@return table { active = string, plans = string[] }
function M.list_plans()
    local dir = Paths.data_dir()
    local active = active_plan_id(dir)
    local idx = read_json(dir .. "plans_index.json") or {}
    local seen, plans = {}, {}
    local function add(id)
        if type(id) ~= "string" or id == "" or seen[id] then return end
        seen[id] = true
        plans[#plans + 1] = id
    end
    if type(idx.plans) == "table" then
        for _, id in ipairs(idx.plans) do add(id) end
    end
    add(active)
    add("default")
    table.sort(plans)
    return { active = active or "default", plans = plans }
end

--- Compact snapshot used by the panel and by the overlay bridge.
---@return table
function M.status()
    local active = active_plan_id(Paths.data_dir())
    if not active and M.engine and M.engine.plan and type(M.engine.plan.source) == "table" then
        active = M.engine.plan.source.plan_id
    end
    local ok, ev = pcall(function() return LiveEvents.current_event() end)
    return {
        armed = Core.running == true,
        plan_id = active or "default",
        current_event = (ok and ev and ev.name ~= "" and ev.name) or nil,
        port = 8767,
    }
end

--- Browser deep link with the localhost token in the URL fragment (never sent
--- over HTTP). Returns nil when no token file exists, keeping auth fail-closed.
function M.panel_url(autoload_current)
    local tok = Paths.read_token()
    if not tok then return nil end
    return "http://127.0.0.1:8767/#token=" .. tok .. (autoload_current and "&autoload=current" or "")
end

--- Immediate camera release, callable from the admin overlay hotkey.
function M.panic_stop()
    return pcall(function() return Core.stop() end) == true
end

--- Stop Follow Race Leader after the producer manually selects a driver.
--- No-op when follow mode is already off.
function M.disengage_follow_leader()
    if not M.follow_leader then return end
    M.follow_leader = false
    automation.last_leader = nil
end

--- Opt-in live-event automation flags.
function M.set_auto_flags(opts)
    if type(opts) == "table" then
        if opts.auto_start ~= nil then M.auto_start = opts.auto_start and true or false end
        if opts.follow_leader ~= nil then M.follow_leader = opts.follow_leader and true or false end
    end
    if M.auto_start then
        automation.last_cd, automation.last_state, automation.started = nil, nil, {}
    end
    if M.follow_leader then automation.last_leader = nil end
    return { auto_start = M.auto_start, follow_leader = M.follow_leader }
end

--- Start RaceCam in standby mode (HTTP panel up, camera NOT taken over until Arm).
function M.Start()
    -- Zero-config auth: create the localhost token before the server binds.
    Paths.ensure_token()
    local errors = Presets.validate()
    if #errors > 0 then
        if LogOutput then LogOutput("ERROR", "RaceCam preset validation failed: %s", table.concat(errors, "; ")) end
        return false
    end
    local plan, route, pid = load_plan_and_route()
    local e = Engine.new(Core, Presets, plan, route)
    _G.RACECAM_SHOTS = e
    M.engine = e
    Core.shots = e
    Core.last_mode = M
    add_plan_index(pid)
    local hok, herr = pcall(function() return Http.start() end)
    log("RaceCam standby (plan=%s, shots=%d, http=%s %s, dir=%s)",
        tostring(pid), #(plan.shots or {}), tostring(hok), tostring(herr), Paths.data_dir())
    return hok
end

return M
