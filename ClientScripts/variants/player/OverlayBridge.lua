--- OverlayBridge — player-build bridge for the Rust egui overlay.
---
--- Teleport + emote commands only. No admin settings, no aim trace, and no
--- 50 ms pipe poll: the native bridge dispatches commands on the game thread.

local json = require("JsonParser")

local statePushed = false

local function SendChat(text)
    local PC = GetMyPlayerController()
    if not PC or not PC:IsValid() then
        LogOutput("WARN", "[OverlayBridge] PlayerController not valid")
        return
    end
    PC:ServerSendChat(text, 0)
end

local COMMANDS = {
    teleport = function(v) SendChat("/tp " .. v) end,
    emote = function(v) SendChat(v) end,
}

local function PushState()
    if type(PushBridgeState) ~= "function" then return end
    local state = {}
    if not statePushed then
        statePushed = true
        local ok, names = pcall(function() return require("TeleportManager").GetPointNames() end)
        if ok and type(names) == "table" and #names > 0 then
            state.teleport_points = names
        end
    end
    local ok, encoded = pcall(json.stringify, state)
    if ok then PushBridgeState(encoded) end
end

local function HandleCommand(jsonText)
    local ok, cmd = pcall(json.parse, jsonText)
    if not ok or type(cmd) ~= "table" then
        LogOutput("WARN", "[OverlayBridge] bad command: %s", tostring(jsonText))
        return
    end
    local fn = COMMANDS[cmd.op]
    if not fn then
        LogOutput("WARN", "[OverlayBridge] unknown command %s", tostring(cmd.op))
        return
    end
    local okApply, err = pcall(fn, cmd.value)
    if okApply then
        LogOutput("INFO", "[OverlayBridge] %s %s", tostring(cmd.op), tostring(cmd.value))
    else
        LogOutput("ERROR", "[OverlayBridge] %s failed: %s", tostring(cmd.op), tostring(err))
    end
end

local M = {}

---@param dir string game root from ModPath
---@return boolean
function M.Load(dir)
    local path = dir .. "/ue4ss/Mods/MotorTownClientMod/overlay/mt_overlay.dll"
    if not package.loadlib then
        LogOutput("WARN", "[OverlayBridge] package.loadlib unavailable")
        return false
    end
    local ok, err = package.loadlib(path, "*")
    if not ok then
        LogOutput("WARN", "[OverlayBridge] could not load %s: %s", path, tostring(err))
        return false
    end
    LogOutput("INFO", "[OverlayBridge] loaded %s", path)
    return true
end

---@param shortcutsApi table from Shortcuts.lua (unused in the player build)
function M.Init(shortcutsApi)
    if type(RegisterBridgeHandler) ~= "function" then
        LogOutput("ERROR", "[OverlayBridge] mt_bridge.dll not loaded - no native bridge")
        return false
    end
    RegisterBridgeHandler(HandleCommand)
    PushState()

    RegisterConsoleCommandHandler("tpmenu", function()
        if type(PushBridgeEvent) == "function" then PushBridgeEvent("tpmenu") end
        return true
    end)

    LogOutput("INFO", "[OverlayBridge] ready - native bridge, Tab teleport menu (player build)")
    return true
end

return M
