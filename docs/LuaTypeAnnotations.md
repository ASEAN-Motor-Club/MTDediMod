# Lua Type Annotations

This project includes Lua type definitions for IDE IntelliSense and type checking support.

## Types Structure

```
types/
├── ue4ss/          # Symlink to UE4SS source (created by nix develop)
│   └── Types.lua   # UE4SS API: RegisterHook, FindFirstOf, etc.
└── game/           # Generated game-specific types (Motor Town classes)
    └── *.lua
```

## VSCode Setup

1. Enter the Nix dev shell (creates `types/ue4ss` symlink):
   ```bash
   nix develop
   ```

2. Install the [Lua extension](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) (sumneko.lua)

3. Open **MTDediMod** as your workspace root (not the parent folder)

4. IntelliSense should work automatically via `.luarc.json`

## Regenerating Game Types

Types in `types/game/` may need to be regenerated when the game is updated (new classes, properties, or functions).

### Option A: Using the TypeGenerator mod (headless server)

```bash
cd motortown-server-flake
./scripts/deploy-dev-mod.sh root@server -r -g
# Types will be synced to MTDediMod/types/game/
```

### Option B: Using UE4SS GUI Console (local client)

1. Install vanilla UE4SS with `dwmapi.dll` proxy on your game client
2. Launch the game and open the UE4SS GUI Console
3. Go to the **Dumpers** tab
4. Click **"Generate Lua Types"** button
5. Copy the generated files from `Mods/shared/types/` to `MTDediMod/types/game/`

## Type Checking

Run type checking from the command line (requires `nix develop`):

```bash
./Scripts/check-types.sh
```

## Annotations Reference

Use [LuaCATS annotations](https://luals.github.io/wiki/annotations/) to add types to your code:

```lua
---@type AActor
local actor = FindFirstOf("BP_MyActor_C")

---@param player APlayerController
---@return boolean
local function kickPlayer(player)
    -- IntelliSense knows player type
    return player:IsValid()
end
```

## Important Warning

> **Do not `require()` or include any type files in your Lua scripts!**
> 
> The files in `types/` are for IDE IntelliSense only. If included at runtime, they will override the globals set by UE4SS and break your mod.
> 
> This is automatically prevented by keeping types in a separate `types/` folder that isn't in the Lua module search path.

