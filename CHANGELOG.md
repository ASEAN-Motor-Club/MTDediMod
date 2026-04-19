# Changelog

All notable changes to MTDediMod are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/). Server and client mods are versioned independently.

## Server

### [server/v0.36.1-rc2] — 2026-04-19

#### Added
- House transfer endpoints: `POST /houses/{guid}/transfer/direct`, `direct_extend`
- House rent extend endpoint: `POST /houses/{guid}/rent/extend` (no player controller needed)
- `FindHouseByGuid` and `FindOnlinePCByCharacterGuid` helpers in PropertyManager
- `HouseGuid` field in `/houses` response

#### Changed
- Webserver wildcard pattern changed from `.*` (greedy) to `[^/]*` (single segment) — fixes multi-segment wildcard route matching

### [server/v0.36.1-rc1] — 2026-04-19

#### Fixed
- ServerSignContract: switched from pre-hook to post-hook so the new ContractInProgress is in the Companies array when traversed
- ServerSignContract: match CIP by contract data (Item, Amount, CompletionPayment) instead of picking the last element by position — eliminates wrong-GUID duplicates
- Removed Lua isPostHook hardcode for ServerSignContract (C++ post-hook handles GUID resolution)

### [server/v0.36.0-rc1] — 2026-04-12

#### Changed
- **Webserver loop migrated to game thread**: replaced `LoopAsync` with `LoopInGameThreadWithDelay`, eliminating all `socket.sleep`-based spin-wait synchronization
- `ExecuteInGameThreadSync` is now a transparent passthrough (direct inline call) since handlers already run on the game thread
- `AssetManager.SpawnActor` no longer uses a spin-wait polling loop; calls `LoadAsset`/`SpawnActor` directly on the game thread

#### Removed
- `Sleep()` helper and its `socket` require from `Helpers.lua`
- `procAmount` / `MOD_SERVER_PROCESS_AMOUNT` env var usage in webserver (no longer needed)
- Spin-wait loop in shared `MTHelpers/Execution.lua`

### [server/v0.35.0-rc4] — 2026-04-11

#### Fixed
- ExecuteInGameThreadSync: added optional `label` and `maxMs` parameters; returns `false` on timeout and logs a WARN (prevents indefinite async thread stalls)
- All Lua webserver handlers that read UObject properties now return HTTP 503 when the game thread does not respond within the time budget (instead of silently returning empty/nil data)
- HandleGetPlayerStates, HandleGetParties: wrapped in ExecuteInGameThreadSync (200ms / 100ms)
- HandleGetPlayerVehicleDecal, HandleDetachPlayerVehicle: wrapped in ExecuteInGameThreadSync (200ms)
- HandleGetVehicleCargos: wrapped in ExecuteInGameThreadSync (300ms); full vehicle chain and nested TArray traversal moved to game thread
- HandleGetServerState, HandleSetServerConfig, HandleGetPolicePatrolAreas: wrapped in ExecuteInGameThreadSync (100ms / 200ms / 150ms)
- VehicleManager: removed three unsafe Net_Parts ForEach iterations from the async thread (primary EXCEPTION_ACCESS_VIOLATION crash sites)

### [server/v0.35.0-rc3] — 2026-04-11

#### Fixed
- ServerLoadCargo: switched from pre-hook to post-hook to avoid racing with FAsyncLoadingThread during rapid successive cargo loads
- ServerLoadCargo: added UObject flag validation (RF_BeginDestroyed, RF_NeedLoad, AsyncLoading, PendingKill) before reading cargo properties

### [server/v0.35.0-rc2] — 2026-04-11

#### Removed
- Disabled ServerLoadCargo C++ hook to mitigate FAsyncLoadingThread crash (EXCEPTION_ACCESS_VIOLATION during rapid successive cargo loads)

### [server/v0.35.0-rc1] — 2026-04-08

#### Added
- C++ hooks for event system: ServerAddEvent, ServerChangeEventState, ServerPassedRaceSection, ServerRemoveEvent, ServerJoinEvent, ServerLeaveEvent
- Events now flow through SSE /events/stream pipeline (replacing Lua webhook POSTs)
- ServerChangeEventState post-hook traverses AMTEventSystem::Net_Events for full event data
- ServerAddEvent extracts full FMTEvent struct including players, race setup, and waypoints

### [server/v0.34.0-rc8] — 2026-04-08

#### Added
- Exposed `Net_bAFK` field in `/players` endpoint response

### [server/v0.34.0-rc7] — 2026-04-05

#### Added
- ServerEnterVehicle hook with seat info and current driver's CharacterGuid

### [server/v0.34.0-rc6] — 2026-04-05

Re-release for test container deployment (no server-side code changes since rc5).

### [server/v0.34.0-rc5] — 2026-04-05

#### Changed
- Teleport: bypass suspect gate with force flag using K2_SetActorLocation + ClientTeleportedCharacter

### [server/v0.34.0-rc4] — 2026-04-04

#### Added
- Experimental aimed impulse endpoint (server-side physics)

### [server/v0.34.0-rc3] — 2026-04-04

#### Added
- Teleport and respawn hooks
- Drive info included in vehicle check response

### [server/v0.34.0-rc2] — 2026-04-04

#### Added
- ServerDespawnCargo hook

### [server/v0.34.0-rc1] — 2026-04-04

#### Added
- Clear vehicle cargo endpoint

---

## Client

### [client/v0.2.11] — 2026-04-08

#### Fixed
- Correct cargo class path from `AMTCargo` to `MTCargo` (fixes cargo despawn for Blueprint subclasses like TrashBag)
- Use `ServerTrashItem` RPC for item despawn instead of client-only `K2_DestroyActor` (replicates on dedicated servers)

---

### [client/v0.2.10] — 2026-04-07

#### Added
- Despawn selection dialog (Ctrl+Shift+D): modal widget with Current / All / Others vehicle despawn options

---

### [client/v0.2.0] — 2026-04-06

#### Added
- IntegrityChecker: reads local vehicle tire physics (FMTTirePhysicsParams) on vehicle entry and reports to backend for anti-cheat monitoring (observe-only PoC)
- Aimed despawn shortcut: toggle nearest vehicle door when aiming at a vehicle instead of despawning

### [client/v0.1.0] — 2026-04-05

Initial client mod release.

#### Added
- Teleport dialog shortcut (Ctrl+Shift+T) — opens text input, delegates to teleport manager
- Ctrl+Shift+LMB alias for aimed impulse
- Ctrl+Shift+X aimed despawn shortcut
- Ctrl+Shift+I aimed impulse shortcut
- Police arrest keyboard shortcut (configurable)
- Gamepad arrest shortcut using IsInputKeyDown polling (100ms tick)

#### Changed
- Refactored gamepad shortcut from InputKey hook to IsInputKeyDown polling for reliable combo detection
