# MTHelpers - MotorTown Helper Library

A generic utility library for MotorTown UE4SS mod development. MTHelpers provides reusable functions for type conversions, player lookups, GUID handling, and more.

## Features

- **Type Conversions**: Convert Unreal Engine types (FVector, FRotator, FTransform, etc.) to JSON-serializable Lua tables
- **GUID Utilities**: Convert between FGuid and string representations
- **Player Lookups**: Find players by GUID or UniqueNetId
- **Game State Access**: Cached accessors for MotorTown subsystems (GameState, DeliverySystem, EventSystem)
- **GameplayTag Utilities**: Convert GameplayTags to strings and tables
- **String/Table Utilities**: String splitting, table merging, safe requires
- **Execution Helpers**: Synchronous game thread execution

## Installation

MTHelpers is included in the `shared/MTHelpers/` directory. Make sure your Lua package path includes the `shared` directory:

```lua
-- In main.lua or your mod entry point
local dir = os.getenv("PWD") or io.popen("cd"):read()
package.path = package.path .. ";" .. dir .. "/shared/?.lua"
package.path = package.path .. ";" .. dir .. "/shared/?/init.lua"
```

## Usage

### Basic Import

```lua
local MTHelpers = require("MTHelpers")

-- Get library version
local version = MTHelpers.GetVersion()
```

### Type Conversions

```lua
local MTHelpers = require("MTHelpers")

-- Convert FVector to table
local vecTable = MTHelpers.Types.VectorToTable(myVector)
-- Returns: {X = 100, Y = 200, Z = 300}

-- Convert FRotator to table
local rotTable = MTHelpers.Types.RotatorToTable(myRotator)
-- Returns: {Pitch = 0, Yaw = 90, Roll = 0}

-- Convert FTransform to table
local transformTable = MTHelpers.Types.TransformToTable(myTransform)
-- Returns: {Location = {...}, Rotation = {...}, Scale3D = {...}}
```

### GUID Utilities

```lua
local MTHelpers = require("MTHelpers")

-- Convert GUID to string
local guidStr = MTHelpers.Guid.ToString(myGuid)
-- Returns: "AABBCCDDEEFF00112233445566778899"

-- Convert string to GUID
local guid = MTHelpers.Guid.FromString("AABBCCDDEEFF00112233445566778899")

-- Generate random GUID
local randomGuid = MTHelpers.Guid.FromString(nil)

-- Validate GUID string format
local isValid = MTHelpers.Guid.IsValid("AABBCCDDEEFF00112233445566778899")
```

### Player Lookups

```lua
local MTHelpers = require("MTHelpers")

-- Find player by UniqueNetId (Steam ID)
local pc = MTHelpers.Player.GetPlayerControllerFromUniqueId("76561198012345678")

-- Find player by character GUID
local pc = MTHelpers.Player.GetPlayerControllerFromGuid("ABC123...")

-- Get player's character GUID
local guid = MTHelpers.Player.GetPlayerGuid(playerController)

-- Get player's UniqueNetId
local uniqueId = MTHelpers.Player.GetPlayerUniqueId(playerController)
```

### Game State Access

```lua
local MTHelpers = require("MTHelpers")

-- Get MotorTown GameState (cached)
local gameState = MTHelpers.GameState.GetMotorTownGameState()

-- Get DeliverySystem (cached)
local deliverySystem = MTHelpers.GameState.GetDeliverySystem()

-- Get EventSystem (cached)
local eventSystem = MTHelpers.GameState.GetEventSystem()

-- Get my player controller (client-only, cached)
local myPC = MTHelpers.GameState.GetMyPlayerController()
```

### GameplayTag Utilities

```lua
local MTHelpers = require("MTHelpers")

-- Convert tag to string
local tagStr = MTHelpers.Tags.TagToString(myTag)

-- Convert tag container to string array
local tags = MTHelpers.Tags.ContainerToStrings(myTagContainer)

-- Convert tag query to table
local queryTable = MTHelpers.Tags.QueryToTable(myTagQuery)
```

### String & Table Utilities

```lua
local MTHelpers = require("MTHelpers")

-- Split string
local parts = MTHelpers.Strings.Split("hello,world", ",")
-- Returns: {"hello", "world"}

-- Merge tables (deep merge)
local merged = MTHelpers.Strings.MergeTables(baseTable, appendTable)

-- Safe require (returns nil on failure instead of error)
local optionalModule = MTHelpers.Strings.RequireSafe("OptionalModule")

-- Read file as string
local content = MTHelpers.Strings.ReadFile("/path/to/file.txt")
```

### Execution Helpers

```lua
local MTHelpers = require("MTHelpers")

-- Execute in game thread synchronously (blocks up to 1 second)
MTHelpers.Execution.InGameThreadSync(function()
  -- Code that must run in game thread
  myActor:K2_DestroyActor()
end, "MyOperation")
```

## Module Structure

```
shared/MTHelpers/
├── init.lua           # Main entry point, re-exports all modules
├── Types.lua          # Type conversion utilities
├── Guid.lua           # GUID utilities
├── Player.lua         # Player lookup functions
├── GameState.lua      # Game state accessors
├── Tags.lua           # GameplayTag utilities
├── Strings.lua        # String and table utilities
└── Execution.lua      # Thread execution helpers
```

## Backward Compatibility

The existing `Scripts/Helpers.lua` file has been updated to delegate to MTHelpers while maintaining all global function exports. This ensures existing code continues to work without modification.

## Dependencies

- **UEHelpers**: Required by GameState.lua
- **socket**: Required by Execution.lua (Lua socket library)

## Version History

- **v1**: Initial release with core utilities extracted from Scripts/

## Contributing

When adding new utilities to MTHelpers:

1. Place them in the appropriate module (or create a new one if needed)
2. Follow existing naming conventions and documentation patterns
3. Include LuaLS type annotations (`---@param`, `---@return`)
4. Update this README with usage examples

## License

Same as the parent MTDediMod project.
