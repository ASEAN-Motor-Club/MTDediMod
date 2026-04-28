local dir = os.getenv("PWD") or io.popen("cd"):read()
package.cpath = package.cpath .. ";" .. dir .. "/ue4ss/Mods/shared/?/core.dll"
package.cpath = package.cpath .. ";" .. dir .. "/ue4ss/Mods/shared/?.dll"

require("Helpers")
local logging = require("Debugging/Logging")
local statics = require("Statics")

---@deprecated Use LogOutput instead to avoid concat errors
LogMsg = logging.logMsg
LogOutput = logging.logOutput

require("ModConfig")
require("ViewportManager")
require("Commands")
require("Shortcuts")
require("IntegrityChecker")
require("ModManager")
require("RPRestrictions")

ExecuteConsoleCommand("r.ViewDistanceScale 100")
LogOutput("INFO", "Client mod loaded (v%s)", statics.ModVersion)
