--- Path resolution for AMC RaceCam inside MotorTownClientMod.
--- Never hardcodes a drive letter or SteamLibrary path: resolves relative to
--- the active Motor Town install via ModPath.game_root(), with an optional
--- RACECAM_DIR environment variable override.

local ModPath = require("ModPath")
local Statics = require("Statics")

local P = {}

local function trailing_slash(s)
    s = s:gsub("\\", "/")
    if s:sub(-1) ~= "/" then s = s .. "/" end
    return s
end

--- Runtime data directory (plans, routes, active_plan.txt, racecam_token.txt,
--- optional racecam_bind.txt, and opt-in diagnostic logs).
---@return string
function P.data_dir()
    local env = os.getenv("RACECAM_DIR")
    if env and env ~= "" then
        return trailing_slash(env)
    end
    local root = ModPath.game_root()
    return trailing_slash(root .. "/ue4ss/Mods/" .. Statics.ModName .. "/racecam")
end

--- Log file path inside the runtime data directory.
---@param filename string
---@return string
function P.log_path(filename)
    return P.data_dir() .. filename
end

return P
