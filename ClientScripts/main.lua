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
local build = require("BuildConfig")
require("ViewportManager")
require("Commands")
local shortcuts = require("Shortcuts")
require("DroneModelHide")
if build.admin then
    require("IntegrityChecker")
end
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
if overlayActive then
    overlayBridge.Init(shortcuts)
    LogOutput("INFO", "egui overlay active (Tab: teleport" .. (build.admin and ", Ctrl+Shift+F10: admin" or "") .. ")")
else
    require("TeleportWidget")
    require("EmoteWidget")
    LogOutput("INFO", "egui overlay unavailable - using UMG teleport/emote widgets")
end

LogOutput("INFO", "Client mod loaded (v%s)", statics.ModVersion)
