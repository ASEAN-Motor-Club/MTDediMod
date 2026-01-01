# Master Plan: Lua Type Safety for MTDediMod

A comprehensive plan to fix 1312 type errors and establish full type safety coverage for the MTDediMod project.

## Executive Summary

The type checker found **1312 problems** across **1939 files** analyzed. The errors fall into distinct categories with different root causes and remediation strategies. This plan prioritizes fixes by impact and effort, separating issues in **user-controlled code** (Scripts/) from issues in **auto-generated type definitions** (types/).

---

## Tasks / TODO

### Phase 1: Foundation - Type Definition Improvements

> [!IMPORTANT]
> **TypeGenerator is UE4SS Built-in**: The type generator is handled by UE4SS's `GenerateLuaTypes` command. Modifying it would:
> - Require forking/patching UE4SS
> - Break on every game update
> - Be lost when regenerating types
>
> **Solution**: Suppress errors in generated types via `.luarc.json` configuration (already decided).

#### 1.1 Add Missing Type Definitions
- [x] **Create `types/base_types.lua`** (Effort: 30m) ✅ **COMPLETED**
  - Add stubs for commonly used types in Scripts/: `TWeakObjectPtr`, `TSubclassOf`, `FOutputDevice`, `PropertyClass`, etc.
  - Note: Most `undefined-doc-name` errors are in `types/game/*` which will be suppressed
  - Fixes: ~20 `undefined-doc-name` errors in Scripts/
  
- [x] **Add luasocket types** (Effort: 15m) ✅ **COMPLETED**
  - Choose Option A (LuaCATS community) or Option B (minimal stub)
  - If A: `git submodule add https://github.com/LuaCATS/luasocket.git types/luasocket`
  - Update `.luarc.json` workspace.library
  - Fixes: 6 `undefined-doc-name` errors for Socket

### Phase 2: Script Code Fixes (High Priority)

#### 2.1 ResponseStatus Type Mismatch
- [x] **Define ResponseStatus alias** (Effort: 5m) ✅ **COMPLETED**
  - Add `---@alias ResponseStatus integer` to `Scripts/Statics.lua`
  - Fixes: 76 `return-type-mismatch` errors

#### 2.2 Undefined Field Access
- [ ] **Add type casts for `context:get()`** (Effort: 2h)
  - Files: `EventManager.lua`, `PlayerManager.lua`, `CargoManager.lua`
  - Replace `---@type` with `---@cast` annotations
  - Fixes: ~30 `undefined-field` errors
  
- [ ] **Add missing UE4 method definitions** (Effort: 4h)
  - Option A: Improve TypeGenerator to include missing fields
  - Option B: Add `---@diagnostic disable-next-line` for each
  - Files: `VehicleManager.lua` (326 errors), `EventManager.lua`, `CargoManager.lua`
  - Fixes: ~190 `undefined-field` errors

#### 2.3 Nil Safety
- [ ] **Add nil guards for critical paths** (Effort: 3h)
  - Identify semantically important nil checks
  - Add guards: `if obj and obj.field then ...`
  - Files: All Scripts/ files
  - Fixes: ~40 `need-check-nil` errors (critical subset)
  
- [ ] **Add diagnostic suppressions for safe patterns** (Effort: 2h)
  - Add `---@diagnostic disable-next-line: need-check-nil`
  - For patterns verified safe at runtime
  - Fixes: ~76 `need-check-nil` errors (remaining)

#### 2.4 Parameter Type Mismatches
- [ ] **Add type cast annotations** (Effort: 1h)
  - Files: `CargoManager.lua`, `VehicleManager.lua`
  - Add `---@cast PC APlayerController` before function calls
  - Fixes: 26 `param-type-mismatch` errors

#### 2.5 Deprecated Function Warnings
- [ ] **Review deprecated function usage** (Effort: 30m) - *OPTIONAL*
  - Functions: `GetPlayerGuid()`, `GetPlayerControllerFromGuid()`
  - Recommended replacements: `GetPlayerUniqueId()`, `GetPlayerControllerFromUniqueId()`
  - Files: `CargoManager.lua`, others
  - Note: Keeping warnings visible (not removing or suppressing)
  - Decision: Address when convenient, warnings are acceptable

### Phase 3: Configuration & Suppression

- [x] **Update `.luarc.json` diagnostics** (Effort: 10m) ✅ **COMPLETED**
  - Add `severity` overrides for `undefined-doc-name`, `local-limit`, `inject-field`, `miss-name`
  - Add `ignoreDir` to completely exclude `types/game` from checking
  - Reduces noise from auto-generated types (77 errors suppressed)
  
- [ ] **Add per-file diagnostic overrides** (Effort: 30m) - *OPTIONAL/NOT NEEDED*
  - Add `---@diagnostic disable` headers to problematic auto-gen files
  - Files: `types/game/Engine.lua`, etc.
  - Note: Using `ignoreDir` instead, so this is no longer needed

### Phase 4: CI/CD Integration

- [x] **Update `tools/check-types.sh`** (Effort: 15m) ✅ **COMPLETED**
  - Set check level to `Error` (warnings and hints will pass)
  - Add proper exit code handling
  
- [ ] **Create GitHub Actions workflow** (Effort: 30m)
  - Create `.github/workflows/type-check.yml`
  - Test workflow on a branch
  
- [ ] **Document type annotation standards** (Effort: 1h)
  - Add section to README or docs/
  - Document common patterns, casts, nil checks

### Validation & Final Steps

- [ ] **Run full type check** (Effort: 10m)
  - Target: 0 errors at Warning+ level
  - Document remaining acceptable Hints
  
- [ ] **Update this plan with results** (Effort: 30m)
  - Document actual error counts after fixes
  - Note any deviations from plan
  - Capture lessons learned

---

## Error Breakdown by Category

| Error Type | Count | Source | Priority |
|-----------|-------|--------|----------|
| `undefined-doc-name` | 901 | types/ (auto-generated) | Medium |
| `undefined-field` | 220 | Scripts/ & types/ | High |
| `need-check-nil` | 116 | Scripts/ | High |
| `return-type-mismatch` | 76 | Scripts/ | High |
| `miss-name` | 53 | types/ (auto-generated) | Low |
| `deprecated` | 30 | Scripts/ | Medium |
| `local-limit` | 28 | types/ (auto-generated) | Low |
| `param-type-mismatch` | 26 | Scripts/ | High |
| `inject-field` | 18 | Scripts/ | Medium |
| `assign-type-mismatch` | 4 | Scripts/ | High |
| Other | ~12 | Mixed | Low |

---

## Phase 1: Foundation - Type Definition Improvements

> [!IMPORTANT]
> The majority of errors (901 `undefined-doc-name`, 53 `miss-name`, 28 `local-limit`) are in auto-generated types from UE4SS's `GenerateLuaTypes` command.
>
> **Why not fix TypeGenerator?**
> - It's built into UE4SS, not user-modifiable
> - Changes would be lost on every type regeneration
> - Would break on game updates
>
> **Solution**: Suppress these via `.luarc.json` configuration.

### 1.1 Create Missing Base Type Definitions

**New file**: `types/base_types.lua`

Create stub definitions for commonly referenced types **in Scripts/** (not in auto-generated files):

```lua
---@meta

-- Missing UE4 template types (simplified)
---@alias TWeakObjectPtr<T> T?
---@alias TSubclassOf<T> UClass

-- Missing callback/delegate types (if needed in Scripts/)
---@alias FOutputDevice any
---@alias FObjectInstancingGraph any

-- Missing property types  
---@alias PropertyClass UClass
---@alias LocalObject UObject
---@alias UObjectDerivative UObject
```

**Note**: Most `undefined-doc-name` errors are in `types/game/*` and will be suppressed via `.luarc.json`. This file only addresses types used in `Scripts/`.

### 1.2 Add Socket Library Types

**Option A: Use LuaCATS Community Types (Recommended)**

The [LuaCATS/luasocket](https://github.com/LuaCATS/luasocket) repository provides community-maintained type definitions for luasocket. To use these:

1. Add to `.luarc.json`:
   ```json
   {
       "workspace": {
           "library": [
               "types/ue4ss",
               "types/game",
               "types/luasocket"
           ]
       }
   }
   ```

2. Clone or download the LuaCATS luasocket types to `types/luasocket/`:
   ```bash
   git clone https://github.com/LuaCATS/luasocket.git types/luasocket
   ```
   
   Or add as a git submodule for easier updates:
   ```bash
   git submodule add https://github.com/LuaCATS/luasocket.git types/luasocket
   ```

**Option B: Create Minimal Stub (Alternative)**

If you only use a subset of luasocket, create a minimal `types/socket.lua`:

```lua
---@meta

---@class Socket
---@field gettime fun(): number
---@field sleep fun(seconds: number)

---@class TCPSocketClient
---@field send fun(self: TCPSocketClient, data: string): number
---@field receive fun(self: TCPSocketClient, pattern?: string): string?, string?
---@field close fun(self: TCPSocketClient)

---@type Socket
socket = {}
```

---

## Phase 2: Script Code Fixes (High Priority)

### 2.1 ResponseStatus Type Mismatch (76 errors)

**Files affected**: Multiple managers (`EventManager.lua`, `AssetManager.lua`, `CargoManager.lua`, etc.)

**Problem**: Functions annotated to return `ResponseStatus?` but return raw integers (200, 400, 404, etc.)

**Fix Option A**: Define `ResponseStatus` as an alias for integer:
```lua
---@alias ResponseStatus integer
```

**Fix Option B**: Use an enum-like table:
```lua
---@class ResponseStatus
---@field OK 200
---@field Created 201
---@field NoContent 204
---@field BadRequest 400
---@field NotFound 404
ResponseStatus = {
  OK = 200,
  Created = 201,
  NoContent = 204,
  BadRequest = 400,
  NotFound = 404
}
```

**Recommendation**: Option A is simpler and requires minimal code changes.

### 2.2 Undefined Field Access (220 errors)

**Files affected**: `VehicleManager.lua`, `EventManager.lua`, `CargoManager.lua`

**Common patterns**:

1. **Accessing UE4 methods not in type stubs** (e.g., `context:get()`, `PC.Companies`):
   - These are valid at runtime but missing from generated types
   - Fix: Improve TypeGenerator to include these fields, OR use `---@diagnostic disable-next-line`

2. **Using `:get()` on RemoteUnrealParam**:
   ```lua
   -- Current
   local PC = context:get() ---@type APlayerController
   
   -- Better: cast properly
   local PC = context:get() ---@cast PC APlayerController
   ```

### 2.3 Nil Safety Issues (116 errors)

**Files affected**: All script files

**Pattern**: Accessing properties on potentially nil objects without guards.

```lua
-- Problematic
local name = vehicle.Net_VehicleKey:ToString()

-- Safe
local name = vehicle.Net_VehicleKey and vehicle.Net_VehicleKey:ToString() or ""

-- Or use Lua 5.4 optional chaining annotation
---@diagnostic disable-next-line: need-check-nil
local name = vehicle.Net_VehicleKey:ToString()
```

**Strategy**: 
1. Add nil guards where semantically important
2. Use `---@diagnostic disable-next-line: need-check-nil` for known-safe patterns
3. Configure `.luarc.json` to reduce severity if too noisy

### 2.4 Parameter Type Mismatches (26 errors)

**Files affected**: `CargoManager.lua`, `VehicleManager.lua`

**Problem**: Passing `UObject` where `APlayerController` expected.

**Fix**: Use proper type casts:
```lua
-- Current
local playerId = GetPlayerUniqueId(PC)  -- PC is UObject

-- Fixed  
local playerId = GetPlayerUniqueId(PC)
---@cast PC APlayerController
```

### 2.5 Deprecated Function Usage (30 errors)

**Files affected**: `CargoManager.lua`, others

**Problem**: Using functions marked `@deprecated` like `GetPlayerGuid`, `GetPlayerControllerFromGuid`

**Fix**: Replace with recommended alternatives:
```lua
-- Deprecated
local characterGuid = GetPlayerGuid(PC)

-- Replacement
local playerId = GetPlayerUniqueId(PC)
```

---

## Phase 3: Configuration & Suppression

### 3.1 Update `.luarc.json`

Add diagnostic configuration to reduce noise from unfixable issues:

```json
{
    "diagnostics": {
        "disable": [
            "lowercase-global"
        ],
        "severity": {
            "undefined-doc-name": "Hint",
            "local-limit": "Hint",
            "inject-field": "Hint"
        },
        "groupFileStatus": {
            "types/game": "None"
        }
    }
}
```

### 3.2 Create Per-File Diagnostic Overrides

For files with many unfixable issues (auto-generated types), add:
```lua
---@diagnostic disable: undefined-doc-name, local-limit
```

---

## Phase 4: CI/CD Integration

### 4.1 Update `tools/check-types.sh`

Add exit code handling for different severity levels:

```bash
# Consider critical only: Error level
lua-language-server --check "$PROJECT_DIR" \
    --checklevel Error \
    --configpath "$PROJECT_DIR/.luarc.json"
```

### 4.2 Add GitHub Actions Workflow

Create `.github/workflows/type-check.yml`:
```yaml
name: Lua Type Check
on: [push, pull_request]
jobs:
  type-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@main
      - run: nix develop --command ./tools/check-types.sh
```

---

## Implementation Order

### Week 1: Quick Wins ✅ **COMPLETED**
- [x] Define `ResponseStatus` alias in `Scripts/Statics.lua`
- [x] Add [LuaCATS/luasocket](https://github.com/LuaCATS/luasocket) types (clone or submodule to `types/luasocket`)
- [x] Create `types/base_types.lua` for missing base types
- [x] Update `.luarc.json` to suppress `types/game/*` diagnostics

### Week 2: TypeGenerator Fixes
- [ ] Fix empty parameter syntax in function generation
- [ ] Add delegate/callback type stubs
- [ ] Handle `TWeakObjectPtr<T>` → `T?` conversion
- [ ] Re-generate types after fixes

### Week 3: Script Fixes
- [ ] Fix all `return-type-mismatch` in manager files
- [ ] Add nil guards or diagnostic suppressions for `need-check-nil`
- [ ] Replace deprecated function calls
- [ ] Add proper type casts for `param-type-mismatch`

### Week 4: Validation & CI
- [ ] Run full type check with zero errors on Warning+ level
- [ ] Set up GitHub Actions type check workflow
- [ ] Document type annotation standards in README

---

## Files by Error Count (Top 10)

| File | Errors | Primary Issues |
|------|--------|----------------|
| `Scripts/VehicleManager.lua` | 326 | undefined-field, need-check-nil |
| `types/game/Engine.lua` | 230 | undefined-doc-name, local-limit |
| `types/game/UMG.lua` | 112 | undefined-doc-name |
| `types/game/GameplayAbilities.lua` | 93 | undefined-doc-name, local-limit |
| `types/game/OnlineSubsystemUtils.lua` | 41 | undefined-doc-name |
| `Scripts/CargoManager.lua` | 36 | deprecated, param-type-mismatch |
| `types/game/SimpleController.lua` | 31 | undefined-doc-name |
| `Scripts/EventManager.lua` | 23 | return-type-mismatch, undefined-field |
| `types/game/AudioMixer.lua` | 22 | undefined-doc-name |
| `Scripts/PlayerManager.lua` | 20 | undefined-doc-name |

---

## Decisions Made

> [!NOTE]
> **Configuration Approach**: The following decisions have been made to guide implementation:

1. **types/game/* diagnostics**: Suppress via `.luarc.json` configuration
   - Rationale: Auto-generated types are maintained externally; suppression is more practical than fixing at source
   - Implementation: Use `groupFileStatus` in `.luarc.json`

2. **Deprecated function warnings**: Keep warnings visible (do not suppress)
   - Rationale: Warnings provide useful guidance for future refactoring
   - Action: Address when convenient, but warnings are acceptable in production

3. **CI check level**: `Error` only
   - Rationale: Warnings and hints are informational; only errors block CI
   - Implementation: `lua-language-server --checklevel Error`

> [!CAUTION]
> **TypeGenerator Changes**: If TypeGenerator modifications are pursued (optional tasks), they require re-deploying to the test server, regenerating types, and syncing back.
