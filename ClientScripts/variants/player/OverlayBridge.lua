--- OverlayBridge — drives the Rust egui overlay (overlay/mt_overlay.dll).
---
--- Player-build bridge: teleport + emote commands only. The admin build's
--- OverlayBridge.lua (admin settings, aim impulse, despawn/door/engine) is
--- not copied into the player package.
---
--- Every POLL_INTERVAL_MS on the game thread:
---   write one JSON line (current settings) to \\.\pipe\mt_overlay_up
---   read one JSON line ({visible, commands}) from \\.\pipe\mt_overlay_down
---   apply the commands through the Shortcuts API
--- The DLL answers every line at once, so the read does not stall the frame.

local json = require("JsonParser")

-- ── Config ────────────────────────────────────────────────────────────────
local POLL_INTERVAL_MS = 50
local RECONNECT_EVERY_N_POLLS = 20
local PIPE_UP = [[\\.\pipe\mt_overlay_up]]
local PIPE_DOWN = [[\\.\pipe\mt_overlay_down]]

-- ── State ─────────────────────────────────────────────────────────────────
local up = nil    ---@type file*?
local down = nil  ---@type file*?
local pollCounter = 0
local pendingEvents = {}
local overlayVisible = false
local pointsSent = false  -- teleport fallback list goes up once per connection

local function Disconnect(reason)
    if up then pcall(function() up:close() end) end
    if down then pcall(function() down:close() end) end
    up, down = nil, nil
    if reason then
        LogOutput("WARN", "[OverlayBridge] disconnected: %s", reason)
    end
end

local function Connect()
    -- Order matters: the DLL connects the up pipe first.
    up = io.open(PIPE_UP, "wb")
    if not up then return false end
    down = io.open(PIPE_DOWN, "rb")
    if not down then
        Disconnect()
        return false
    end
    LogOutput("INFO", "[OverlayBridge] connected to overlay")
    pointsSent = false
    return true
end

-- ── Commands from the overlay ─────────────────────────────────────────────
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
    teleport = function(v) SendChat("/tp " .. v) end,
    emote = function(v) SendChat(v) end,
}

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
    end
end

---The game hides the cursor while driving; show it while the panel is open.
local function SetCursorVisible(visible)
    local PC = GetMyPlayerController()
    if PC and PC:IsValid() then
        pcall(function() PC.bShowMouseCursor = visible end)
    end
end

-- ── Poll ──────────────────────────────────────────────────────────────────
local function BuildRequest()
    -- No admin state is sent by the player build: no impulse settings, no
    -- aimed-mass trace. The DLL's admin window is compiled out too.
    local state = {}
    local req = { state = state }
    -- The overlay fetches the server's teleport list itself; these names
    -- (TeleportManager defaults or config.json) are its fallback.
    if not pointsSent then
        pointsSent = true
        local okN, names = pcall(function() return require("TeleportManager").GetPointNames() end)
        if okN and type(names) == "table" and #names > 0 then
            req.teleport_points = names
        end
    end
    -- JsonParser encodes an empty table as {}, which is not a list; leave the
    -- key out instead (the DLL defaults it).
    if #pendingEvents > 0 then
        req.events = pendingEvents
        pendingEvents = {}
    end
    return req
end

local function Poll()
    pollCounter = pollCounter + 1
    if not up then
        if pollCounter % RECONNECT_EVERY_N_POLLS ~= 0 or not Connect() then return end
    end

    local okW, errW = pcall(function()
        up:write(json.stringify(BuildRequest()), "\n")
        up:flush()
    end)
    if not okW then return Disconnect("write: " .. tostring(errW)) end

    local line = down:read("l")
    if not line then return Disconnect("overlay closed the pipe") end

    local okP, resp = pcall(json.parse, line)
    if not okP or type(resp) ~= "table" then
        LogOutput("WARN", "[OverlayBridge] bad response: %s", line)
        return
    end

    local visible = resp.visible == true
    if visible ~= overlayVisible then
        overlayVisible = visible
        SetCursorVisible(visible)
    end
    if type(resp.commands) == "table" then
        for _, cmd in ipairs(resp.commands) do ApplyCommand(cmd) end
    end
end

-- ── Public API ────────────────────────────────────────────────────────────
local M = {}

---Load the overlay DLL. Returns false when it is missing or fails to load,
---so main.lua can fall back to the UMG teleport/emote widgets.
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

---@param shortcutsApi table from Shortcuts.lua (unused in the player build)
function M.Init(shortcutsApi)
    LoopInGameThreadWithDelay(POLL_INTERVAL_MS, function()
        local ok, err = pcall(Poll)
        if not ok then Disconnect("poll: " .. tostring(err)) end
        -- return true on every path: UE4SS's callback GC frees callbacks that
        -- do not opt in, and calling a freed one is a native crash.
        return true
    end)

    -- The player DLL only handles Tab and Esc; there is no admin window.
    RegisterConsoleCommandHandler("tpmenu", function()
        table.insert(pendingEvents, "toggle_teleport")
        return true
    end)

    LogOutput("INFO", "[OverlayBridge] ready - Tab teleport menu (player build)")
end

return M
