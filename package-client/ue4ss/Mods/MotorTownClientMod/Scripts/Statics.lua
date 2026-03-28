---@alias ResponseStatus integer

local outputLogLevel = tonumber(os.getenv("MOD_CLIENT_LOG_LEVEL")) or 2

return {
    ModName = "MotorTownClientMod",
    ModVersion = "0.1.0",
    ModLogLevel = outputLogLevel,
}
