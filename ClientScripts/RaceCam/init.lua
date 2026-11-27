-- RaceCam boot module: starts the LOCAL control panel in standby.
-- It never arms or moves the camera. Operators press A in the panel to arm,
-- then S to start the cue clock. No keybinds, overlays or in-game UI.
local M = {}
local P = require("RaceCam/path")

local function loadlua(path)
  local f = io.open(path, "r")
  if not f then error("NOFILE " .. path) end
  local c = f:read("*a"); f:close()
  local fn, err = load(c, path)
  if not fn then error("SYNTAX " .. path .. " " .. tostring(err)) end
  return fn()
end

local function ensure_token(D)
  local f = io.open(D .. "racecam_token.txt", "r")
  if f then f:close(); return end
  math.randomseed(os.time() + tostring({}):len())
  local alphabet = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789"
  local t = {}
  for _ = 1, 32 do
    local i = math.random(1, #alphabet)
    t[#t + 1] = alphabet:sub(i, i)
  end
  local o = io.open(D .. "racecam_token.txt", "w")
  if o then o:write(table.concat(t)); o:close() end
end

function M.init()
  if _G.RACECAM_BOOT_DONE then return "already booted" end
  _G.RACECAM_BOOT_DONE = true
  local D = P.data_dir()
  ensure_token(D)
  local Core = loadlua(P.script_dir .. "core.lua")
  local mode = loadlua(P.script_dir .. "mode_shots.lua")
  Core.register(mode)
  local old = _G.RACECAM_HTTP
  if old and type(old.stop) == "function" then pcall(function() old.stop() end) end
  local ok, err = pcall(function() return mode.http.start() end)
  return "standby http=" .. tostring(ok) .. " " .. tostring(err)
end

return M
