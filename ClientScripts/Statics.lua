---@alias ResponseStatus integer

local outputLogLevel = tonumber(os.getenv("MOD_CLIENT_LOG_LEVEL")) or 2

local build = require("BuildConfig")

return {
    ModName = "MotorTownClientMod",
    ModVersion = build.version,
    ModLogLevel = outputLogLevel,
}
