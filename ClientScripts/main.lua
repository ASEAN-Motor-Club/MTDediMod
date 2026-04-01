local dir = os.getenv("PWD") or io.popen("cd"):read()
package.cpath = package.cpath .. ";" .. dir .. "/ue4ss/Mods/shared/?/core.dll"
package.cpath = package.cpath .. ";" .. dir .. "/ue4ss/Mods/shared/?.dll"

require("Helpers")
local json = require("JsonParser")
local logging = require("Debugging/Logging")
local statics = require("Statics")

---@deprecated Use LogOutput instead to avoid concat errors
LogMsg = logging.logMsg
LogOutput = logging.logOutput

local config = require("ModConfig")
local viewportManager = require("ViewportManager")
local commands = require("Commands")
local shortcuts = require("Shortcuts")
local satnav = require("SatNav")

LogOutput("INFO", "Client mod loaded (v%s)", statics.ModVersion)
