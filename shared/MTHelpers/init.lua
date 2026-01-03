---Generic helper library for MotorTown mod development
---@class MTHelpers
---
---This library provides reusable utility functions for developing MotorTown mods.
---It follows the pattern established by UEHelpers.lua and includes:
---
--- - **Types**: Convert Unreal Engine types to JSON-serializable tables
--- - **Guid**: GUID utilities (ToString, FromString, IsValid)
--- - **Player**: Player lookup functions (by GUID, UniqueNetId)
--- - **GameState**: Cached access to MotorTown subsystems
--- - **Tags**: GameplayTag conversion utilities
--- - **Strings**: String and table utilities
--- - **Execution**: Thread execution helpers
---
---@usage
---```lua
---local MTHelpers = require("MTHelpers")
---
----- Convert a vector to a table
---local vecTable = MTHelpers.Types.VectorToTable(myVector)
---
----- Get a player by their GUID
---local pc = MTHelpers.Player.GetPlayerControllerFromGuid("ABC123...")
---
----- Convert a GUID to string
---local guidStr = MTHelpers.Guid.ToString(myGuid)
---```

local MTHelpers = {}

-- Version tracking (following UEHelpers pattern)
local Version = 1

---Get the MTHelpers version
---@return number
function MTHelpers.GetVersion()
  return Version
end

-- Re-export submodules
MTHelpers.Types = require("MTHelpers.Types")
MTHelpers.Guid = require("MTHelpers.Guid")
MTHelpers.Player = require("MTHelpers.Player")
MTHelpers.GameState = require("MTHelpers.GameState")
MTHelpers.Tags = require("MTHelpers.Tags")
MTHelpers.Strings = require("MTHelpers.Strings")
MTHelpers.Execution = require("MTHelpers.Execution")

return MTHelpers
