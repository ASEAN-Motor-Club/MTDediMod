# mt_overlay

egui windows for MotorTownClientMod, drawn on top of the game from a DXGI
`Present` hook. Replaces the UMG widgets (built through reflection, clicked
via `IsPressed` polls and an `OnClicked` delegate bound to an unrelated
UFunction):

| Window | Opens with | Replaces |
|---|---|---|
| Admin Tools | Ctrl+Shift+F10, console `adminpanel` | `AdminPanel.lua` |
| Teleport + Emotes | Tab, console `tpmenu` | `TeleportWidget.lua`, `EmoteWidget.lua` |

Esc closes both. Every window can be dragged by its title bar; positions are
saved to `mt_overlay_layout.json` next to the DLL (delete it to reset).

The teleport list is fetched by the DLL from the server API (so Lua no longer
needs the native `fetch` module); if that fails it shows TeleportManager's
points, which Lua sends once per connection. Teleports and emotes are sent as
chat commands (`/tp <name>`, `/Wave`), as the UMG widgets did. Tab still
reaches the game, as before; Esc does not while a window is open.

## How it fits together

```
 Lua (game thread)                        mt_overlay.dll
 ─────────────────                        ──────────────
 main.lua
  └ OverlayBridge.Load ── package.loadlib(dll, "*") ──► DllMain → init thread
                                                         ├ bridge: named pipes
                                                         └ hook: Present / ResizeBuffers
 OverlayBridge poll (50 ms)
  ├ write {"state":..} ─► \\.\pipe\mt_overlay_up   ─►  bridge::SHARED.state
  └ read  {"visible", ◄─ \\.\pipe\mt_overlay_down ◄─  queued Commands
           "commands"}
  └ apply via Shortcuts.Set* / *Aimed                  Present hook (RHI thread)
                                                         ├ egui frame (ui.rs)
 WndProc subclass (window thread) ── input events ──►    └ D3D11 paint (painter.rs)
  └ swallows Ctrl+Shift+F10, Esc, and clicks/raw mouse/keys on our windows
```

- **Lua keeps all UObject access.** The DLL never calls into UE; it only
  sends commands such as `{"op":"set_right_click","value":"trunk"}`.
- **No Lua C API.** UE4SS links Lua statically, so the DLL is loaded with
  `package.loadlib(path, "*")`, which maps it without looking up a symbol.
- **Input is consumed.** The WndProc returns without calling the game's, so
  the hotkey and panel clicks no longer leak into the game.
- **Fallback.** If the DLL is missing or fails to load, or
  `useEguiOverlay = false` in `config.json`, main.lua uses the old UMG panel.

## Limits (v0.1)

- **D3D11 only.** Launch Motor Town with `-dx11` (Steam → Properties →
  Launch options). Under D3D12 the overlay logs once and stays out of the way.
  D3D12 needs the command queue (`ExecuteCommandLists` hook) and per-frame
  back-buffer resources; that is the next step.
- **Online play.** This hooks the renderer of a multiplayer client; check the
  server's rules before using it on a public server.
- **Other Present hooks** (Steam/Discord overlay, RTSS, frame generation) can
  conflict; if the panel flickers or does not show, disable them first.
- sRGB back buffers (`*_UNORM_SRGB`) will draw the panel slightly too bright.

## Build

Needs Rust (stable) for `x86_64-pc-windows-msvc`.

```
cargo build --release
```

Then copy `target\release\mt_overlay.dll` to
`...\Motor Town\MotorTown\Binaries\Win64\ue4ss\Mods\MotorTownClientMod\overlay\`.
`build.ps1` does both when given the game's Win64 path.

## Testing without the game

```
cargo build --release --lib --examples
target\release\examples\harness.exe
```

`examples/harness.rs` stands in for the game (a D3D11 window) and for Lua
(a client on the bridge pipes). It opens both windows, clicks "trunk", drags
the admin window, clicks a teleport and an emote, clicks empty screen and
presses Tab. Only the empty-screen click may reach the "game".
`--keep-layout` keeps the saved positions to check they are restored. It
opens away from your cursor (real mouse moves would disturb the script) and
saves the last frame to `target/harness.bmp`. Pass `--lib`: a cdylib is
not rebuilt by `--examples` alone.

## Debugging

- `mt_overlay.log` next to the DLL: load, hook install, swapchain format,
  bridge connect/disconnect, any frame error.
- UE4SS log: `[OverlayBridge]` lines (load, connect, every applied command).
