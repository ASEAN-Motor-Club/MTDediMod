-- Shared path resolution for RaceCam. No drive letters, no io.popen.
local ModPath = require("ModPath")
local M = {}
local root = ModPath.game_root()
M.script_dir = root .. "/ue4ss/Mods/MotorTownClientMod/Scripts/RaceCam/"
M.data_dir = M.script_dir .. "data/"
return M
