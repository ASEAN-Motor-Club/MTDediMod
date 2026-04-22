# Changelog

All notable changes to MTDediMod are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/). Server and client mods are versioned independently.

## Server

### [server/v0.38.0-rc14] — 2026-04-22

#### Fixed
- Webserver request read latency: `handleClient` now loops to drain all buffered request lines in a single frame instead of one line per `process()` call. Per-client sockets changed from blocking (`settimeout(1)`) to non-blocking (`settimeout(0)`), eliminating the ~1–1.7 s wait at 30 fps for typical 7–10 line HTTP requests.

### [server/v0.38.0-rc13] — 2026-04-22

#### Added
- `/player_vehicles/*/last` endpoint — lightweight last vehicle info with trailer chain
- `/player_vehicles/*/last/decals` endpoint — decals and customization for last vehicle
- `/player_vehicles/*/last/parts` endpoint — minimal parts by default, `?complete=1` for full values
- `/vehicles/spawn` native spawn path via `ServerSpawnVehicle` with `FMTVehicleSpawnParams`
- Table conversion helpers for vehicle spawn params, state, cold state, and owner settings

### [server/v0.38.0-rc11] — 2026-04-22

#### Fixed
- **Actually applied** UE4SS Lua GC corruption patches (rc10 was a no-op due to Nix store caching the old unpatched `ue4ss-patched` derivation). Both patches are now compiled into the binary:
  - Lua 5.4.7 `lgc.c` weak-table metatable fix
  - Skip delegate/function properties in `convert_struct_to_lua_table`

### [server/v0.38.0-rc10] — 2026-04-22

#### Fixed
- UE4SS Lua GC corruption crash during `/player_vehicles/*/list?complete=1` — applied upstream Lua 5.4.7 bug fix for weak-table + metatable interaction in `lgc.c` that caused null-deref in `luaC_checkfinalizer`
- UE4SS `convert_struct_to_lua_table` now skips delegate/function properties (`FDelegateProperty`, `FMulticastDelegateProperty`, etc.) — prevents `UFunction::construct` → `lua_setmetatable` path that triggers the GC bug under heavy nested struct conversion

### [server/v0.38.0-rc9] — 2026-04-22

#### Added
- Cross-compilation build pipeline now generates PDB debug symbols (`/Zi` + `/DEBUG:FULL`) for crash-dump analysis on Linux/macOS
- New flake apps: `analyze-crash` (LLDB minidump inspector) and `archive-symbols` (per-release PDB archiving)

#### Fixed
- `VehicleManager` crash hardening: `IsUObjectSafe` guards added across `VehicleToTable`, `VehiclePartToTable`, `PlayerVehicleToTable`, `GetVehicles`, `GetVehiclesByTag`, `DespawnVehicleById`, `HandleSetVehicleParameter`, `HandleDetachPlayerVehicle`, and `HandleGetPlayerVehicles` — prevents `EXCEPTION_ACCESS_VIOLATION` when iterating vehicles, seats, hooks, or parts that are mid-destruction

### [server/v0.38.0-rc8] — 2026-04-22

#### Added
- `IsUObjectSafe` C++ global function exposed to Lua — checks `RF_BeginDestroyed`, `RF_FinishDestroyed`, `PendingKill`, and `Unreachable` flags that `:IsValid()` misses

#### Fixed
- `DespawnPlayerVehicle` crash when despawning vehicles mid-destruction: every UObject in the tractor-trailer chain is now gated with `IsUObjectSafe` before property access or `ServerDespawnVehicle` calls

### [server/v0.38.0-rc7] — 2026-04-22

#### Added
- `asyncSafe` handler flag — GET/HEAD endpoints can now opt in to run directly on the async thread instead of being queued to the game thread via `ExecuteInGameThread`
- `HEAD` added to the HTTP method enum

#### Changed
- `registerHandler` signature simplified: removed the `authenticate` parameter (all handlers require auth by default; opt-out is done by setting `handler.authenticate = false` after registration)

#### Fixed
- `getInFlight` counter leak for sessions closed before game thread completion: cleanup now tracks `inFlightCounted` per session and decrements the throttle counter for **both** `state == "close"` and timeout removals — fixes permanent `503 Server busy` after client disconnects under load
- `GetPlayerStates` now builds both a full list cache and a `byId` map cache, making `/players/{id}` O(1) instead of O(n) — eliminates full `PlayerArray` scan on every individual lookup
- `PlayerStateToTable` is now fully wrapped in `pcall` with validity guards on every TArray access; pawn rotation read is additionally `pcall`-wrapped so a single bad UObject doesn't take down the server
- Disabled vehicle parts setting in `HandleSpawnVehicle` — `ExecuteInGameThreadWithDelay` block was not working reliably and has been commented out

### [server/v0.38.0-rc6] — 2026-04-21

#### Fixed
- `getInFlight` counter leak in unified async dispatch: response loop and timeout cleanup now decrement the throttle counter for **all** HTTP methods, not just GET/HEAD — prevents `503 Server busy` after 10 mutating requests

### [server/v0.38.0-rc5] — 2026-04-21

#### Changed
- Unified async dispatch for all HTTP methods (GET/HEAD/POST/PUT/PATCH/DELETE) — all requests now use fire-and-forget `ExecuteInGameThread` with `pendingResponse` polled by the async thread
- Global request throttle (`maxInFlight`/`inFlight`) replaces the previous GET-only throttle, applying to all methods equally

#### Removed
- `ExecuteInGameThreadSync` blocking spin-wait path for mutating HTTP methods — no longer needed since all dispatch is now async

### [server/v0.38.0-rc4] — 2026-04-21

#### Fixed
- Webserver stalls under GET load: added `maxClients` (64) connection cap, `maxGetInFlight` (10) GET throttle, and 15 s session age timeout to prevent `FD_SETSIZE` exhaustion and game-thread queue flooding
- `GetPlayerStates()` now caches the full player list for 1 s, eliminating redundant UObject property access on every concurrent GET request

#### Changed
- `LoopAsync` poll interval restored to 1 ms for responsive request dispatch

### [server/v0.38.0-rc3] — 2026-04-21

#### Fixed
- C++ `EnqueueWebhookEvent` compile errors: `lua_value_to_json` and `lua_table_to_json_value` hoisted to file scope (nested function definitions are not valid C++)
- Stale `_gameThreadDepth` reference in GET dispatch caused nil arithmetic error, preventing `pendingResponse` from being set and causing GET requests to hang

#### Changed
- `ExecuteInGameThreadSync` now performs the real async→game-thread blocking dispatch with spin-wait timeout; used by the webserver dispatcher for mutating methods
- Removed all `ExecuteInGameThreadSync` wrappers from handler files (VehicleManager, PlayerManager, ServerManager, PropertyManager, CargoManager, ViewportManager) — handlers run directly on the game thread since the webserver centrally dispatches them

### [server/v0.38.0-rc2] — 2026-04-21

#### Fixed
- Deadlock when handlers internally call `ExecuteInGameThreadSync` after central game-thread dispatch — `_gameThreadDepth` is now incremented in the webserver's `ExecuteInGameThread` callback so nested calls execute inline

#### Changed
- Restored real `ExecuteInGameThreadSync` with `_gameThreadDepth` re-entrancy detection to prevent deadlocks in nested dispatch
- Webserver loop moved from `LoopInGameThreadWithDelay` back to `LoopAsync` — socket I/O no longer blocks the game thread
- GET/HEAD endpoints dispatch via fire-and-forget `ExecuteInGameThread`; mutating methods (POST/PUT/DELETE/PATCH) use blocking `ExecuteInGameThreadSync` with 5s timeout
- JSON stringify offloaded from game thread to async thread — all handlers now return Lua tables and the webserver stringifies centrally
- `EnqueueWebhookEvent` now accepts a Lua table directly instead of a JSON string, eliminating the Lua→C++ serialize/parse roundtrip that previously blocked the game thread

### [server/v0.37.5] — 2026-04-20

#### Changed
- Removed 500ms delay when setting vehicle parts on spawn — parts are now set synchronously

### [server/v0.37.4] — 2026-04-20

#### Added
- `EnqueueWebhookEvent` C++ function exposed to Lua — emits events directly to the C++ EventManager/SSE pipeline, bypassing the Lua webhook HTTP pipeline
- `ServerSendChat` hook now emits original (pre-mute) chat events via `EnqueueWebhookEvent` so the backend receives unmodified category and message
- `amc-backend` `ServerSendChat` webhook handler that processes chat messages (Discord forwarding, command execution, SSE bot events, chat log) with original category from the event payload
- Chat dedup between webhook and log pipelines: webhook-processed messages are skipped in the log handler via cache-based dedup

#### Changed
- Muted players' chat is now redirected based on mute type: soft mute → SmallArea (7), hard mute → Company (2)
- `MuteFor` parameter replaces `MuteUntil` in the mute endpoint payload (input is a duration, not a timestamp)
- `Hard` boolean parameter added to mute endpoint — defaults to false (soft mute)
- Removed `ChatManager.lua` `RegisterEventHook("ServerSendChat", ...)` — event emission is now handled by the Lua `ServerSendChat` hook directly via `EnqueueWebhookEvent`

### [server/v0.37.3] — 2026-04-20

#### Added
- Player mute system: hook `ServerSendChat` to redirect muted players' chat from Normal (0) to Company (7)
- `DELETE /players/*/mute` endpoint to unmute a player
- `GET /players/muted` endpoint to list currently muted players
- `IsPlayerMuted`, `MutePlayer`, `UnmutePlayer`, `GetMutedPlayers` helpers with expiry support

#### Changed
- `HandleMutePlayer` now returns JSON status and supports unmute via `MuteUntil: false/null`

### [server/v0.37.1] — 2026-04-20

#### Changed
- Restore `Net_Parts` reading in `PlayerVehicleToTable` — vehicle parts are now returned in `/player_vehicles/*/list?complete=true` responses again

### [server/v0.37.0] — 2026-04-19

#### Added
- Register `/vehicles/spawn` POST route (was missing, caused 404s from backend)
- Register `/world_vehicles/*/decal` POST route (was missing, caused 404s from backend)
- Re-enable vehicle parts setting on spawn via `ExecuteWithDelay(500ms)` with pcall error handling and validity checks, restoring display vehicle functionality

### [server/v0.36.3] — 2026-04-19

#### Added
- ServerRentHouse hook: extracts House data (HousegKey, HouseGuid, owner info, RentLeftTimeSeconds)
- ServerRentExtendHouse hook: extracts House data, Money (FMTShadowedInt64), and Seconds

#### Fixed
- CargoManager: adapt for new game version — `TimeSinceLastProduction` and `ProductionFlags` moved from `FMTProductionConfig` to new `FMTProductionStatus` struct
- CargoManager: add `Net_ProductionStatuses` serialization (Progress, ProductionSpeedMultiplier, ProductionFlags)
- CargoManager: guard `Net_Deliveries` access with validity check (field removed in new game version)

### [server/v0.36.2-rc1] — 2026-04-19

#### Added
- ServerSelectPolicePullOverPenaltyResponse hook now extracts SuspectCharacter data: Net_ResidentKey, CharacterGuid, AccountNickname, Net_CharacterFlags

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

### [client/v0.2.12] — 2026-04-22

#### Added
- Single-player vehicle save/spawn commands (`/save_vehicle [name]`, `/spawn_vehicle [name]`) with aliases `/sv` and `/spv` — stores vehicle config (asset, paint, decals, parts) as local JSON in `saved_vehicles/`
- `VehicleSaveSpawn` client module: pure client-side serialize/deserialize with direct `world:SpawnActor` and server RPC application (no networking)
- Quick-save keybind: `Ctrl+Shift+F5` saves the current vehicle to `saved_vehicles/quicksave.json`
- Shared `VehicleSerialization` module extracted from server `VehicleManager.lua` for bidirectional customization/decal/part serialization

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
