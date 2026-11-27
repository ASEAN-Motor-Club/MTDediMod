--- AMC RaceCam admin-only module entry point for MotorTownClientMod.
---
--- Starts the local HTTP operator panel (127.0.0.1:8767, fail-closed on
--- racecam_token.txt) in STANDBY mode without taking over the camera.
--- Camera takeover only occurs when the operator clicks Arm (A) in the panel,
--- and Panic Stop (X) or the 120s heartbeat fail-safe restores the player view.

local Paths = require("RaceCam/paths")
local Core = require("RaceCam/core")
local Presets = require("RaceCam/presets")
local Engine = require("RaceCam/shot_engine")
local Http = require("RaceCam/http")

local M = { name = "shot_engine", log_every = 5 }

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

local function load_plan_and_route()
    local dir = Paths.data_dir()
    local pid = active_plan_id(dir)
    if pid then
        local plan = try_loadlua(dir .. "plan_" .. pid .. ".lua")
        if plan then
            local route = try_loadlua(dir .. "route_" .. pid .. ".lua")
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
    local pcs = FindAllOf("PlayerController") or {}
    if pcs[1] then
        local ok, pawn = pcall(function() return pcs[1]:K2_GetPawn() end)
        if ok and pawn then e.target = pawn end
    end
    e:log("init plan=" .. tostring(pid) .. " shots=" .. tostring(#(plan.shots or {})))
end

M.apply = function(core)
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
    _G.RACECAM_SHOTS = e
    M.engine = e
    Core.shots = e
    if LogOutput then
        LogOutput("INFO", "RaceCam reloaded plan '%s' (%d shots)", tostring(pid), #(plan.shots or {}))
    end
    return pid
end

--- Start RaceCam in standby mode (HTTP panel up, camera NOT taken over until Arm).
function M.Start()
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
    local hok, herr = pcall(function() return Http.start() end)
    if LogOutput then
        LogOutput("INFO", "RaceCam standby (plan=%s, shots=%d, http=%s %s, dir=%s)",
            tostring(pid), #(plan.shots or {}), tostring(hok), tostring(herr), Paths.data_dir())
    end
    return hok
end

return M
