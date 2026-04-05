# Changelog

All notable changes to MTDediMod are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/). Server and client mods are versioned independently.

## Server

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
