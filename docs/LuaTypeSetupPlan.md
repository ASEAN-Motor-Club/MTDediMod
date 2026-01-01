# Setup Lua Type Annotations and Type Checking for MTDediMod

Set up a complete Lua development environment with IntelliSense, type annotations, and type checking for the UE4SS mod project.

## Background

The project is a UE4SS Lua mod in `Scripts/`. UE4SS provides:
1. **`Types.lua`** - Pre-existing type definitions for all UE4SS API functions (located in the UE4SS source at `assets/Mods/shared/Types.lua`)
2. **`GenerateLuaTypes()`** - Function to generate game-specific type definitions (for Motor Town classes, properties, etc.)

**Key distinction**:
- `motortown-server-flake/shared/` → Windows DLL dependencies (luasocket, cjson, ssl) for deployment
- `MTDediMod/types/` → Lua type definitions for IDE support:
  - `types/ue4ss/` → Symlink to UE4SS source's `Types.lua` (created by devShell)
  - `types/game/` → Generated game-specific types (synced from server)

Types belong in **MTDediMod** so developers can work on the mod independently with full IntelliSense, without needing the server deployment infrastructure.

---

## Proposed Changes

### Part 1: Type Generation (One-time via TypeGenerator Mod)

Create a simple mod to generate Lua types on the test server. This is run once after game updates, not on every boot.

---

#### [NEW] TypeGenerator/

A minimal UE4SS mod that generates Lua type annotations:

##### [NEW] TypeGenerator/Scripts/main.lua

```lua
-- TypeGenerator mod - generates Lua types for IDE support
-- Run once after game boots, then disable this mod

local hasGenerated = false

RegisterInitGameStatePostHook(function(GameState)
    if hasGenerated then return end
    hasGenerated = true
    
    print("[TypeGenerator] Game state initialized, generating Lua types...")
    GenerateLuaTypes()
    print("[TypeGenerator] Types generated to Mods/shared/types/")
    print("[TypeGenerator] You can now disable this mod.")
end)

print("[TypeGenerator] Waiting for game state initialization...")
```

**Why `RegisterInitGameStatePostHook`**: This fires once after `AGameModeBase::InitGameState`, ensuring game types are loaded. `RegisterBeginPlayPostHook` fires for every actor which would cause multiple generation attempts.

##### [NEW] TypeGenerator/enabled.txt

Empty file to enable the mod by default.

---

#### [NEW] types/

Directory structure for type definitions:

```
types/
├── .gitkeep           # Ensure directory is tracked
├── ue4ss/             # Symlink created by devShell → $UE4SS_SOURCE_DIR/assets/Mods/shared/
│   └── Types.lua      # UE4SS API types (RegisterHook, FindFirstOf, etc.)
└── game/              # Generated game-specific types (Motor Town classes)
    └── *.lua          # Synced from server after running TypeGenerator
```

##### [NEW] types/.gitignore

```gitignore
# Symlink created by nix devShell - don't commit
ue4ss
```

##### [NEW] types/game/.gitkeep

Empty file to track the game types directory.

---

#### [MODIFY] deploy-dev-mod.sh

Add a new `--generate-types` flag that:
1. Deploys the TypeGenerator mod
2. Starts/restarts the container
3. Waits for types generation
4. Syncs `Mods/shared/types/` from server back to `MTDediMod/types/game/`
5. Disables the TypeGenerator mod

```diff
+  -g, --generate-types  Deploy TypeGenerator mod, sync types back to MTDediMod/types/game/
```

---

### Part 2: Nix DevShell with UE4SS Types Symlink

Modify the Nix development shell to:
1. Add `lua-language-server` for type checking
2. Create a symlink to UE4SS's `Types.lua` for IntelliSense

---

#### [MODIFY] MTDediMod/flake.nix

Update the devShell to add `lua-language-server` and create the UE4SS types symlink:

```diff
         # Development shell with all cross-compile tools
         devShells.default = (lib.mkDevShell {}).overrideAttrs (old: {
-          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.gh ];
+          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
+            pkgs.gh
+            pkgs.lua-language-server
+          ];
+          shellHook = (old.shellHook or "") + ''
+            # Create symlink to UE4SS types for Lua IntelliSense
+            if [ -n "$UE4SS_SOURCE_DIR" ] && [ -d "$UE4SS_SOURCE_DIR/assets/Mods/shared" ]; then
+              mkdir -p types
+              ln -sfn "$UE4SS_SOURCE_DIR/assets/Mods/shared" types/ue4ss
+              echo "Created types/ue4ss symlink for Lua IntelliSense"
+            fi
+          '';
         });
```

**Key insight**: The `ue4ss-cross` flake already exports `$UE4SS_SOURCE_DIR` pointing to the patched UE4SS source. We just need to symlink `assets/Mods/shared/` which contains `Types.lua`.

---

### Part 3: VSCode Development Environment (MTDediMod)

Configure VSCode for Lua IntelliSense using the sumneko/LuaLS extension. All configuration files go in the **MTDediMod** repository.

---

#### [NEW] MTDediMod/.luarc.json

Lua Language Server configuration:

```json
{
    "$schema": "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
    "runtime": {
        "version": "Lua 5.4"
    },
    "workspace": {
        "maxPreload": 50000,
        "preloadFileSize": 5000,
        "library": [
            "types/ue4ss",
            "types/game"
        ],
        "checkThirdParty": false
    },
    "diagnostics": {
        "disable": [
            "lowercase-global"
        ]
    },
    "hint": {
        "enable": true,
        "paramName": "All",
        "setType": true
    }
}
```

**Key change**: No `diagnostics.globals` list needed! The `Types.lua` file uses `---@meta` and proper LuaCATS annotations to define all UE4SS API functions (`RegisterHook`, `FindFirstOf`, `ExecuteInGameThread`, etc.).

---

#### [MODIFY] MTDediMod/.vscode/settings.json

Add Lua-specific settings:

```diff
 {
     "cmake.configureOnOpen": false,
     "C_Cpp.intelliSenseEngine": "disabled",
     "clangd.arguments": [
         "--compile-commands-dir=${workspaceFolder}/build-cross",
         "--background-index",
         "--clang-tidy",
         "--header-insertion=iwyu",
         "--completion-style=detailed"
-    ]
+    ],
+    "Lua.workspace.library": [
+        "${workspaceFolder}/types/ue4ss",
+        "${workspaceFolder}/types/game"
+    ]
 }
```

---

#### [NEW] MTDediMod/.vscode/extensions.json

Recommend the Lua extension:

```json
{
    "recommendations": [
        "sumneko.lua"
    ]
}
```

---

### Part 4: Documentation

Document the type generation workflow for developers.

---

#### [NEW] MTDediMod/docs/LuaTypeAnnotations.md

Comprehensive documentation for Lua type annotations:

```markdown
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
./scripts/check-types.sh
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
```

---

#### [MODIFY] MTDediMod/README.md

Add a brief section with link to the detailed docs:

```markdown
## Lua Type Annotations

This project includes Lua type definitions for IDE IntelliSense support.

See [docs/LuaTypeAnnotations.md](docs/LuaTypeAnnotations.md) for setup and usage.

**Quick start:**
1. Enter dev shell: `nix develop` (creates `types/ue4ss` symlink)
2. Install [Lua extension](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) in VSCode
3. Open **MTDediMod** as your workspace root
```

---

### Part 5: Type Checking Script

Add command-line type checking using `lua-language-server --check`.

---

#### [NEW] MTDediMod/scripts/check-types.sh

Script to run type checking (uses lua-language-server from Nix devShell):

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "==> Running Lua type checker on $PROJECT_DIR..."

# Check if lua-language-server is available
if ! command -v lua-language-server &> /dev/null; then
    echo "Error: lua-language-server not found in PATH"
    echo "Run 'nix develop' to enter the dev shell with lua-language-server"
    exit 1
fi

# Verify types/ue4ss symlink exists
if [ ! -L "$PROJECT_DIR/types/ue4ss" ]; then
    echo "Warning: types/ue4ss symlink not found"
    echo "Run 'nix develop' to create it"
fi

# Run type checking
lua-language-server --check "$PROJECT_DIR" --checklevel Warning --configpath "$PROJECT_DIR/.luarc.json"

# Check if report was generated
LOG_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/lua-language-server/log"
REPORT="$LOG_PATH/check.json"

if [[ -f "$REPORT" ]]; then
    # Check if there are any diagnostics
    DIAGNOSTIC_COUNT=$(jq 'length' "$REPORT" 2>/dev/null || echo "0")
    if [[ "$DIAGNOSTIC_COUNT" -gt 0 ]]; then
        echo "⚠ Found $DIAGNOSTIC_COUNT diagnostic(s):"
        jq -r '.[] | "\(.uri):\(.range.start.line): \(.message)"' "$REPORT" | head -20
        exit 1
    else
        echo "✓ No type errors found"
    fi
else
    echo "✓ Type check completed (no report generated = no issues)"
fi
```

---

## Verification Plan

### Prerequisites

Enter the Nix development shell to get lua-language-server and create the types symlink:
```bash
cd MTDediMod
nix develop
```

Verify the symlink was created:
```bash
ls -la types/ue4ss
# Should show: types/ue4ss -> /nix/store/.../ue4ss-patched/assets/Mods/shared
```

### Automated Type Checking

1. **Run type checker**:
   ```bash
   ./scripts/check-types.sh
   ```

2. **Expected output** (success):
   ```
   ==> Running Lua type checker on /path/to/MTDediMod...
   ✓ No type errors found
   ```

### Type Generation Workflow

1. **Deploy TypeGenerator mod to test server**:
   ```bash
   cd motortown-server-flake
   ./scripts/deploy-dev-mod.sh root@asean-mt-server -r -g
   ```

2. **Verify types generated on server**:
   ```bash
   ssh root@asean-mt-server "ls -la /var/lib/mtdedimod-dev/ue4ss/Mods/shared/types/"
   ```

3. **Sync types to MTDediMod repo**:
   ```bash
   rsync -avz root@asean-mt-server:/var/lib/mtdedimod-dev/ue4ss/Mods/shared/types/ \
     ./MTDediMod/types/game/
   ```

4. **Commit types to repository**:
   ```bash
   cd MTDediMod
   git add types/game/
   git commit -m "feat: add generated Motor Town Lua type definitions"
   ```

### Manual VSCode Verification

1. **UE4SS API IntelliSense**: Open `Scripts/main.lua` in VSCode, verify:
   - Autocomplete for `FindFirstOf`, `RegisterHook`, `ExecuteInGameThread`, etc.
   - Hover shows function signatures with parameter types
   - No red squiggles on valid UE4SS API calls

2. **Game Types IntelliSense** (after generating types):
   ```lua
   ---@type ABP_PlayerController_C
   local pc = FindFirstOf("BP_PlayerController_C")
   pc.  -- should show Motor Town-specific methods/properties
   ```

---

## Summary

| Step | Action |
|------|--------|
| 1 | Create `TypeGenerator` mod with `RegisterInitGameStatePostHook` |
| 2 | Create `MTDediMod/types/` directory structure |
| 3 | Modify `flake.nix` to add `lua-language-server` and symlink UE4SS types |
| 4 | Create `.luarc.json` pointing to `types/ue4ss` and `types/game` |
| 5 | Update `.vscode/settings.json` and create `extensions.json` |
| 6 | Create `docs/LuaTypeAnnotations.md` and update README |
| 7 | Create `scripts/check-types.sh` for CLI type checking |
| 8 | Run `nix develop` to verify symlink creation |
| 9 | Verify IntelliSense in VSCode |
| 10 | Deploy to server, generate and sync game types when needed |
