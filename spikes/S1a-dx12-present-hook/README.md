# S1a — DX12 in-process Present hook (spike)

**Status:** built, awaiting tester round.
**Branch:** `spike/imgui-s1a` (parked; not for merge).
**Timebox:** 1.5 days of the 4-day Phase 1 budget.

## Question (Given / When / Then)

Given Motor Town running on D3D12 (default RHI),
when a module in the game process hooks `IDXGISwapChain::Present` and draws with
ImGui using the game's own device, queue and back buffers,
then a 900×500 window renders every frame for 30 minutes with no crash, no
visible stutter beyond noise, and survives alt-tab and a resolution change.

**Why this is first:** if we cannot own `Present` safely in this build, the whole
in-game-ImGui plan is the wrong shape and S1b/S2/S3/S4 are wasted work.

## Approach

- Install from `on_unreal_init()` on a worker thread (does not block game init).
- Two vtable patches, no library dependency:
  - `IDXGISwapChain::Present` (index 8) and `ResizeBuffers` (index 13), read from
    a throwaway D3D11 swap chain on a hidden window — the DXGI vtables are
    per-process, so the game's swap chain picks up the same detour.
  - `ID3D12CommandQueue::ExecuteCommandLists` (index 10), read from a throwaway
    D3D12 device + direct queue, to capture the game's direct queue (needed by
    the ImGui DX12 backend).
- First `Present` after that: detect the RHI via `IDXGISwapChain::GetDevice`,
  init ImGui + the matching backend, subclass the game window's `WndProc`.
- Draw: ImGui DX12 backend into the current back buffer, with the
  PRESENT→RENDER_TARGET barrier pair around our draw and a fence so an allocator
  slot is never reused while the GPU still owns it.
- `ResizeBuffers` detour tears the device objects down; the next `Present`
  re-initialises them. ImGui's context and the win32 backend survive.
- Everything is wrapped in a `__try/__except` — a fault disables the overlay and
  logs once instead of crashing the game.

**Scope discipline:** no panels, no HTTP, no Lua, no Unreal calls. The window has
a frame counter, an fps readout and one text box.

## Files

- `src/ui/spike/SpikeUi.h`, `src/ui/spike/SpikeUi.cpp` — everything.
- `src/CMakeLists.txt` — `SPIKE_UI` option, fetches ImGui v1.91.8 as a static
  lib **inside this module** (separate DLL from UE4SS.dll, so its vendored ImGui
  copy cannot collide — different modules, different statics).
- `src/dllmain.cpp` — `SpikeUi::Start()` under `#ifdef SPIKE_UI`.
- `flake.nix` — `EXTRA_CMAKE_ARGS="-DSPIKE_UI=ON"` in the **client** configure
  only; `setup_cross_compile.sh` forwards it.
- Nothing is added to `ClientScripts/`, so the normal client package is unchanged.

## Build

```bash
nix run --no-update-lock-file .#configure-client
nix run --no-update-lock-file .#build-client
# artefact: build-cross-client/Game__Shipping__Win64/MotorTownMods.dll
```

## Install for the test

The spike branch also ships the C++ mod DLL inside the client package (stock
packages are Lua-only), so the artefact is directly installable:

1. Take `MotorTownClientMod-package.zip` from the workflow run artefact
   (Actions → run → `client-mod-package`).
2. Replace your existing client-mod files with it — the DLL lands at
   `...\MotorTown\Binaries\Win64\ue4ss\Mods\MotorTownClientMod\dlls\main.dll`,
   next to the usual `Scripts\` folder and `enabled.txt`.
3. Launch normally — **DX12**, frame generation / DLSS off.
4. Keep the previous package zip around: reverting is reinstalling the old one.

## Tester script (Meehoi, then freeman)

1. Launch the game to the main menu — window should appear immediately on the
   first rendered frame (it starts open, by design: a first-frame crash is the
   signal we want).
2. Open `...\Win64\ue4ss\UE4SS.log` and search `[spike]`. Copy those lines.
   Expected: `install complete`, `Present/ResizeBuffers hook: ok`,
   `captured DX12 direct queue`, `win32 backend ready`,
   `DX12 backend ready (buffers=…, format=…)`, `wndproc hooked`.
3. Press `Insert` twice — the window should disappear and come back, with
   `overlay OPEN` / `overlay CLOSED` in the log.
4. Note the `fps~` line with the window closed for ~30 s, then with it open for
   ~30 s. Report both numbers and the in-game FPS counter.
5. Alt-tab out and back **three times**. Any flicker, freeze or cursor weirdness?
6. Change graphics: switch windowed ↔ borderless, and change resolution. The
   window must survive (`ResizeBuffers WxH` should be logged) — check it still
   draws afterwards.
7. Drive around for 30 minutes with the overlay open. Note anything that feels
   different (frame pacing, input lag, stutter when the HUD changes).
8. Type a few characters into the text box. Report exactly what happened in the
   game (did the car move? did a game keybind fire?). This is throwaway data for
   S3 — do not try to fix it now.
9. Quit normally. Send `UE4SS.log`, plus any new
   `MotorTown\Saved\Crashes\*\UEMinidump.dmp`.

## Falsifies the idea if

- the game crashes, hangs, or black-screens at any point (send the dump);
- the window only appears after a second launch, or never;
- `Present/ResizeBuffers hook` logs `FAILED`, or the RHI is not identified;
- frame time visibly degrades with the overlay open;
- alt-tab or a resolution change leaves the overlay broken and it never recovers;
- anything renders over the game's UI incorrectly (blend/format wrong on HDR).

## Known limitations (expected, not findings)

- No input capture: typing into the box also reaches the game, and the camera
  still turns. That is S3's question, not this one.
- No HDR/format negotiation beyond using the swap chain's own format.
- DX11 path is written but untested; that is S1b.
- No D3D12 debug-layer validation was run (layer is absent on the test machine).

## Research already done for the follow-on spikes

- **S3 (input capture)** — the functions exist and are already typed for Lua:
  `AController:SetIgnoreMoveInput` / `ResetIgnoreMoveInput`
  (`types/Engine.lua:872-877`), `APlayerController.bShowMouseCursor`
  (`types/Engine.lua:2012`), and `UWidgetBlueprintLibrary:SetInputMode_UIOnlyEx`
  / `SetInputMode_GameOnly` (`types/UMG.lua:2916-2925`) if a focus target turns
  out to be needed.
- **S4 (Lua bridge)** — the mod already keeps the main Lua state:
  `LuaHttpServer::Get()->SetLuaState(main_lua.get_lua_state())`
  (`src/dllmain.cpp:1485`). C++ can push a global on that state instead of
  walking the VM itself.

## Tester machine caveat (read before judging a failure)

The desktop client already stacks three Present/swap-chain consumers in the same
`Win64` folder: **OptiScaler** (`dxgi.dll`, `OptiScaler.ini`,
`D3D12_Optiscaler/`), **ReShade**, and an **IGCS** camera tool (its own
`imgui.ini` + `IGCS_ImGuiSettings.ini`). So this box is a *harder* target than a
clean install: our `Present` hook lands on top of theirs and must chain
correctly. A pass here is stronger evidence than a pass on a vanilla client; a
crash here is not automatically our fault — check `ReShade.log` and
`OptiScaler.ini` overlay settings before blaming the spike.

## Verdict

_To be filled in after the tester round — VALIDATED / PARTIAL / INVALIDATED with
evidence (log lines, both fps numbers, minutes of clean runtime)._
