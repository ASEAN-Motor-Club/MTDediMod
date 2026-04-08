# Changelog

All notable changes to MTDediMod are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/). Server and client mods are versioned independently.

## Server

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
