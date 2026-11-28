local dir = require("ModPath").game_root()
package.cpath = package.cpath .. ";" .. dir .. "/ue4ss/Mods/shared/?/core.dll"
package.cpath = package.cpath .. ";" .. dir .. "/ue4ss/Mods/shared/?.dll"

require("Helpers")
local logging = require("Debugging/Logging")
local statics = require("Statics")

---@deprecated Use LogOutput instead to avoid concat errors
LogMsg = logging.logMsg
LogOutput = logging.logOutput

local config = require("ModConfig")
require("ViewportManager")
require("Commands")
local shortcuts = require("Shortcuts")
require("DroneModelHide")
require("IntegrityChecker")
require("ModManager")
require("RPRestrictions")

-- The egui overlay (overlay/mt_overlay.dll) draws the teleport/emote menu and
-- an admin panel from a DXGI Present hook and consumes its own keys. The UMG
-- widgets register TAB/ESC at load, so load them ONLY when the overlay is not
-- active - otherwise both fight over TAB and the cursor.
local overlayBridge = require("OverlayBridge")
local overlayActive = false
if config.GetModConfig("useEguiOverlay") ~= false then
    overlayActive = overlayBridge.Load(dir)
end
local build = require("BuildConfig")
if overlayActive then
    overlayBridge.Init(shortcuts)
    LogOutput("INFO", "egui overlay active (Tab: teleport" .. (build.admin and ", Ctrl+Shift+F10: admin" or "") .. ")")
else
    require("TeleportWidget")
    require("EmoteWidget")
    LogOutput("INFO", "egui overlay unavailable - using UMG teleport/emote widgets")
end

-- Admin-only broadcast camera controller (standby HTTP panel on 127.0.0.1:8767;
-- never takes over the camera until the operator clicks Arm).
if build.admin and config.GetModConfig("enableRaceCam") ~= false then
    local ok, rc = pcall(require, "RaceCam/init")
    if ok and rc and rc.Start then
        rc.Start()
    else
        LogOutput("WARN", "RaceCam unavailable: %s", tostring(rc))
    end
end

LogOutput("INFO", "Client mod loaded (v%s)", statics.ModVersion)
