--- OverlayBridge — drives the Rust egui overlay through the native bridge DLL.
---
--- The 50 ms named-pipe poll is gone. `mt_bridge.dll` registers one Lua
--- handler; the Rust overlay calls a C export which queues a command, and the
--- bridge invokes this handler on the game thread. State is pushed to Rust
--- only when it changes, and console events go straight to the Rust overlay.

local json = require("JsonParser")

local SHORTCUTS ---@type table filled in by Init()
local statePushed = false

-- ── Commands from the overlay ─────────────────────────────────────────────
local TRIGGERS = {
    impulse = function() SHORTCUTS.ImpulseAimed() end,
    despawn = function() SHORTCUTS.DespawnAimed() end,
    door = function() SHORTCUTS.DoorToggle() end,
    engine = function() SHORTCUTS.EngineAimed() end,
}

---Send a chat line as the local player (/tp and emotes are chat commands).
local function SendChat(text)
    local PC = GetMyPlayerController()
    if not PC or not PC:IsValid() then
        LogOutput("WARN", "[OverlayBridge] PlayerController not valid")
        return
    end
    PC:ServerSendChat(text, 0)
end

local COMMANDS = {
    set_impulse_mode = function(v) SHORTCUTS.SetImpulseMode(v) end,
    set_impulse_strength = function(v) SHORTCUTS.SetImpulseStrength(v) end,
    set_speed_kmh = function(v) SHORTCUTS.SetSpeedKmh(v) end,
    set_direction = function(v) SHORTCUTS.SetImpulseDirectionMode(v) end,
    set_origin = function(v) SHORTCUTS.SetImpulseOriginMode(v) end,
    set_right_click = function(v) SHORTCUTS.SetRightClickAction(v) end,
    trigger = function(v)
        local fn = TRIGGERS[v]
        if fn then fn() end
    end,
    teleport = function(v) SendChat("/tp " .. v) end,
    emote = function(v) SendChat(v) end,
}

local function PushState()
    if type(PushBridgeState) ~= "function" then return end
    local state = {
        impulse_mode = SHORTCUTS.GetImpulseMode(),
        impulse_strength = SHORTCUTS.GetImpulseStrength(),
        speed_kmh = SHORTCUTS.GetSpeedKmh(),
        direction = SHORTCUTS.GetImpulseDirectionMode(),
        origin = SHORTCUTS.GetImpulseOriginMode(),
        right_click = SHORTCUTS.GetRightClickAction(),
    }
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

local function ApplyCommand(cmd)
    local fn = COMMANDS[cmd.op]
    if not fn then
        LogOutput("WARN", "[OverlayBridge] unknown command %s", tostring(cmd.op))
        return
    end
    local ok, err = pcall(fn, cmd.value)
    if not ok then
        LogOutput("ERROR", "[OverlayBridge] %s failed: %s", tostring(cmd.op), tostring(err))
    else
        LogOutput("INFO", "[OverlayBridge] %s %s", tostring(cmd.op), tostring(cmd.value))
        -- Event-driven state refresh: no timer, no poll.
        PushState()
    end
end

local function HandleCommand(jsonText)
    local ok, cmd = pcall(json.parse, jsonText)
    if not ok or type(cmd) ~= "table" then
        LogOutput("WARN", "[OverlayBridge] bad command: %s", tostring(jsonText))
        return
    end
    ApplyCommand(cmd)
end

-- ── Public API ────────────────────────────────────────────────────────────
local M = {}

---Load the overlay DLL. Returns false when it is missing or fails to load,
---so main.lua can fall back to the UMG AdminPanel.
---@param dir string game root from ModPath
---@return boolean
function M.Load(dir)
    local path = dir .. "/ue4ss/Mods/MotorTownClientMod/overlay/mt_overlay.dll"
    if not package.loadlib then
        LogOutput("WARN", "[OverlayBridge] package.loadlib unavailable")
        return false
    end
    -- "*" only maps the library (no luaopen_ symbol needed); DllMain does the rest.
    local ok, err = package.loadlib(path, "*")
    if not ok then
        LogOutput("WARN", "[OverlayBridge] could not load %s: %s", path, tostring(err))
        return false
    end
    LogOutput("INFO", "[OverlayBridge] loaded %s", path)
    return true
end

---@param shortcutsApi table from Shortcuts.lua
function M.Init(shortcutsApi)
    SHORTCUTS = shortcutsApi
    if type(RegisterBridgeHandler) ~= "function" then
        LogOutput("ERROR", "[OverlayBridge] mt_bridge.dll not loaded - no native bridge")
        return false
    end
    RegisterBridgeHandler(HandleCommand)
    PushState()

    -- The overlay handles Ctrl+Shift+F10, Tab and Esc itself. These console
    -- commands forward through the native bridge as direct events.
    RegisterConsoleCommandHandler("adminpanel", function()
        if type(PushBridgeEvent) == "function" then PushBridgeEvent("adminpanel") end
        return true
    end)
    RegisterConsoleCommandHandler("tpmenu", function()
        if type(PushBridgeEvent) == "function" then PushBridgeEvent("tpmenu") end
        return true
    end)

    LogOutput("INFO", "[OverlayBridge] ready - native bridge, no pipe poll")
    return true
end

return M
