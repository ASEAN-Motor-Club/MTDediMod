#pragma once
//
// mt_bridge — native C ABI between the Rust overlay (mt_overlay.dll) and the
// game-side bridge (the MTDediBridgeHost UE4SS C++ mod).
//
// Placement: mt_bridge.dll ships at the GAME EXECUTABLE ROOT (next to the
// dwmapi.dll proxy), not inside the mod tree. Rust resolves it with
// LoadLibraryW(L"mt_bridge.dll"); the game exe directory is in the DLL search
// path. The UE4SS host mod (Mods/MTBridgeHost/dlls/main.dll) links this
// header WITHOUT MT_BRIDGE_BUILD (dllimport) and talks to the SAME module
// instance, because LoadLibrary of an already-loaded DLL name returns the
// existing module — one shared queue, one shared snapshot.
//
// Threading contract:
//   - mt_bridge_submit / mt_bridge_set_state / mt_bridge_get_state /
//     mt_bridge_set_cursor are safe from any thread (Rust UI/render thread).
//     A single mutex guards the command queue and the state snapshot.
//   - mt_bridge_internal_pop is called ONLY by the host mod on the game
//     thread, from the engine tick callback. No exports call Lua.
//   - No exceptions escape any export; everything is try/catch guarded.
//
// Lua-facing API (registered by MTDediBridgeHost in on_lua_start):
//   RegisterBridgeHandler(fn)   -- fn(command_json_string), game-thread dispatcher
//   PushBridgeState(json_string)-- stores the latest state snapshot for Rust
//   PushBridgeEvent(name)       -- console event forwarded to mt_overlay_event
//

#ifdef MT_BRIDGE_BUILD
#define MT_BRIDGE_API extern "C" __declspec(dllexport)
#else
#define MT_BRIDGE_API extern "C" __declspec(dllimport)
#endif

// 1 when the bridge module is loaded and functional, 0 otherwise.
MT_BRIDGE_API int mt_bridge_ready(void);

// Queue a command for the game-thread Lua handler. `len` may be 0 to use
// strlen(json). Returns 0 on success, -1 on bad arguments, -2 on queue
// overflow (command dropped).
MT_BRIDGE_API int mt_bridge_submit(const char* json, int len);

// Replace the state snapshot the Lua side pushes (via PushBridgeState).
// The snapshot persists until the next push; Rust reads it every frame.
// Returns 0 on success, -1 on bad arguments.
MT_BRIDGE_API int mt_bridge_set_state(const char* json, int len);

// Copy the latest state snapshot into `out` (NUL-terminated). Returns the
// number of bytes copied (excluding the NUL), 0 when no snapshot exists,
// -(required size incl. NUL) when `cap` is too small, -1 on bad arguments.
MT_BRIDGE_API int mt_bridge_get_state(char* out, int cap);

// Queue {"op":"set_cursor_visible","value":<bool>} — the same command path
// the JSON commands use, so the Lua handler applies it on the game thread.
// (The game hides the cursor while driving; the overlay shows it while a
// panel is open.)
MT_BRIDGE_API void mt_bridge_set_cursor(int visible);

// ── host-mod-only API (not part of the Rust contract) ─────────────────────
// Pop one queued command JSON into `out`. Returns the byte count (>0), 0
// when the queue is empty, -1 on bad arguments, and -(required size) with
// the command DROPPED when `cap` is too small (commands are tiny; 8 KiB is
// plenty).
MT_BRIDGE_API int mt_bridge_internal_pop(char* out, int cap);

// Compiled only into admin builds (-DMT_BRIDGE_ADMIN): marks the DLL as an
// admin build for the static guard tooling. The player build has no such
// symbol and no admin strings — the bridge itself carries no admin
// functionality; commands are opaque JSON dispatched by Lua.
#ifdef MT_BRIDGE_ADMIN
MT_BRIDGE_API int mt_bridge_admin_build(void);
#endif
