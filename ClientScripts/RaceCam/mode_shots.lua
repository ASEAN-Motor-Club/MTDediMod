-- shot-engine mode wrapper for racecam_core.lua
-- Resolve the RaceCam data directory without hardcoding a drive letter:
-- the RACECAM_DIR environment variable wins; otherwise candidate relative
-- paths are probed by attempting to create a marker file (io.open append).
local function racecam_dir() return require("RaceCam/path").data_dir() end

local function loadlua(path)
  local f = io.open(path, "r")
  if not f then error("NOFILE " .. path) end
  local c = f:read("*a"); f:close()
  local fn, err = load(c, path)
  if not fn then error("SYNTAX " .. path .. " " .. tostring(err)) end
  return fn()
end
local function try_loadlua(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local c = f:read("*a"); f:close()
  local fn, err = load(c, path)
  if not fn then error("SYNTAX " .. path .. " " .. tostring(err)) end
  return fn()
end
local D = racecam_dir()
local function active_id()
  local f = io.open(D .. "active_plan.txt", "r")
  if not f then return "aewol" end
  local id = (f:read("*a") or ""):match("^%s*([A-Za-z0-9_%-]+)")
  f:close()
  return id or "aewol"
end
local PID = active_id()
local P = loadlua(D .. "presets.lua")
local PLAN = loadlua(D .. "plan_" .. PID .. ".lua")
local ROUTE = try_loadlua(D .. "route_" .. PID .. ".lua")
local Engine = loadlua(D .. "shot_engine.lua")
local Http = loadlua(D .. "http.lua")
local errors = P.validate()
if #errors > 0 then error("PRESETS " .. table.concat(errors, "; ")) end

local M = { name = "shot_engine", log_every = 5, http = Http }
M.init = function(Core)
  local e = Engine.new(Core, P, PLAN, ROUTE)
  _G.RACECAM_SHOTS = e
  M.engine = e
  Core.shots = e
  local pcs = FindAllOf("PlayerController") or {}
  if pcs[1] then
    local pawn = pcs[1]:K2_GetPawn()
    if pawn then e.target = pawn end
  end
  e:log("start " .. tostring(os.date()) .. " shots=" .. tostring(#(PLAN.shots or {})))
end
M.apply = function(Core)
  local ok, err = pcall(function() M.engine:update() end)
  if not ok then
    M.engine:log("ERR " .. tostring(err))
    M.engine:apply_last()
  end
end
return M
