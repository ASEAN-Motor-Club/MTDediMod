# Motor Town Mods

Powered by UE4SS lua scripts! This mod focuses primarily towards dedicated server. Some commands work on client-side, though results may vary depending on the game's replication system.

## Usage

### Installation

Download the latest releases [here](https://github.com/drpsyko101/MotorTownMods/releases). Extract its contents to `path/to/ue4ss/Mods/` directory. The Lua static modules are also available in the relase as `shared.zip`. Download and extract the contents into the `path/to/ue4ss/Mods/shared` directory.

### Building from source

1. Clone this repository into your `ue4ss/Mods` directory.

   ```shell
   git -C <path/to/ue4ss/Mods> clone https://github.com/drpsyko101/MotorTownMods.git
   ```

#### (Optional) Lua module

For a full functionality of the mod, download and extract [luasocket](https://github.com/alain-riedinger/luasocket/releases/tag/3.1-5.4.7) to `path/to/ue4ss/Mods/shared` directory to use the HTTP server. For webhook functionality or any instability while using the REST API, build [Luasec](https://github.com/lunarmodules/luasec) either from source or using [Luarocks](https://luarocks.org/) for Win64. Install [lua-bcrypt](https://github.com/mikejsavage/lua-bcrypt) to enable server API authentication with `bcrypt` hashing algorithm.

#### (Optional) C++ module

The C++ module is included in the release. Any changes to the C++ files need a recompile.

##### Cross-Compilation with Nix (Recommended)

This project supports cross-compiling to Windows from macOS/Linux using Nix. No Windows machine or Visual Studio required!

**Prerequisites:**
- [Nix package manager](https://nixos.org/download.html) with flakes enabled

**Build Steps:**

```bash
# Enter the development shell
nix develop

# Run the build (downloads MSVC headers automatically via xwin)
nix run
```

Your compiled DLL will be at `build-cross/MotorTownMods/MotorTownMods.dll`.

Copy or symlink it to `ue4ss/Mods/MotorTownMods/dlls/main.dll`.

##### Alternative: Windows with CMake

If you prefer building natively on Windows:

1. Clone this repository
2. Open the project in Visual Studio or use standard CMake commands
3. Ensure Boost 1.87.0 is available (CMake will fetch it if not found)
4. Build in Release mode
5. Copy the DLL to `ue4ss/Mods/MotorTownMods/dlls/main.dll`

### Lua Type Annotations

This project includes Lua type definitions for IDE IntelliSense support.

See [docs/LuaTypeAnnotations.md](docs/LuaTypeAnnotations.md) for setup and usage.

**Quick start:**
1. Enter dev shell: `nix develop` (creates `types/ue4ss` symlink)
2. Install [Lua extension](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) in VSCode
3. Open **MTDediMod** as your workspace root


### Client Signatures

`client-signatures/` holds the `UE4SS_Signatures` for the Motor Town **client** binary. They are packaged into the client mod as `ue4ss/UE4SS_Signatures/`, next to `UE4SS.dll`.

UE4SS cannot reach the engine globals and functions it needs (`GUObjectArray`, `GMalloc`, `FName::ToString`, `StaticConstructObject_Internal`, …) through the export table, so it locates them by scanning the executable for byte patterns (AOBs). The built-in patterns target stock Unreal compiler output; a Motor Town update that changes code layout can invalidate one. UE4SS then starts with the affected subsystem dead while the rest of the scan still succeeds — for `GUObjectArray` that means no mod can touch UObjects at all:

```text
[PS] Found GMalloc: 0x7ff65ab7d820
[PS] Found FName::ToString: 0x7ff65266f3e0
AOB scans could not be completed because of the following reasons:
Was unable to find AOB for 'GUObjectArray' via Lua script
```

Once a working signature is present, the same log prints `GUObjectArray address: 0x… <- Lua Script`, followed by object-system activity (`[HashTables] UClass instances: N`, `Self test passed`) and the mods loading normally.

#### Recovering a signature after a game update

No debugger and no blank reference build are required — diff the previous release of the game against the new one:

1. Keep the previous `MotorTown-Win64-Shipping.exe`. It is the reference, and it is worth more than any amount of documentation later.
2. Run the existing signature against that **old** exe. Require exactly one match, and check that the resolved target lands in a writable section (`.data`) — a global is never in `.text`. A single match whose target lands elsewhere is a decoy with the same opcode shape.
3. Take the containing function's exact range from `.pdata` (never guess function boundaries) and disassemble it. Note every RIP-relative reference to the global in that function — they are free corroboration.
4. Locate the same function in the new exe by searching for short **verbatim** byte chunks from the old disassembly that contain no rel32 displacement and no immediate the compiler is likely to rematerialise (a flag-manipulation block, a `lock cmpxchg` loop, a stack-store prelude). A constant shift across several chunks proves the function is byte-identical and gives its new position.
5. Re-decode the `lea rcx,[rip+disp]` (`target = instruction_end + disp32`) and confirm the other references in the same function resolve to the same base at their expected member offsets. Several references agreeing on one base is the correctness proof; pattern uniqueness alone is not.
6. Write the signature, back up the previous one, and relaunch the game — signatures are read at process start only.

Signature rules, learned from the update that motivated this section:

- **Stop the pattern at the displacement.** A pattern that ran one instruction past the `lea` (`… 89 5C 24 20 44 8D 4B ??`) was invalidated when the compiler stopped folding `lea r9d,[rbx-1]` into `mov r9d,-1` and reordered the following `mov rdx,rdi`. The same prefix, truncated at the wildcarded displacement, matched both builds.
- Prefer 12–20 bytes, wildcard only the RIP displacement, and verify the pattern is unique in the build you are shipping for.
- A signature that also resolves correctly in the previous build is stronger evidence than one that merely has no duplicate.
- `OnMatchFound` must return the address of the global, not of the instruction: for a `lea rXX,[rip+disp]` at `match + off`, that is `DerefToInt32(match + off + 3) + match + off + 7`.

Current signatures:

- `GUObjectArray.lua` — anchors on `89 47 08 33 DB 48 8D 0D ?? ?? ?? ??` (`lea` at `+5`), resolving to `GUObjectArray`. Verified against the 2026-11-18 client build.
- `FText_Constructor.lua` — FText constructor anchor.

### Configuration

Most of the server settings can be configured using environment variables:

| Variable name               | Default value | Description                                                                                                                |
| --------------------------- | ------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `MOD_MANAGEMENT_PORT`       | `5000`        | Management port. Used for managing mods in the dedicated server                                                            |
| `MOD_SERVER_PORT`           | `5001`        | Lua HTTP port. This only applies if `luasocket` module is installed                                                        |
| `MOD_SERVER_PROCESS_AMOUNT` | 5             | The amount of cumulative connection to process. Higher number correspond to quicker response, in return slower event hook. |
| `MOD_SERVER_LOG_LEVEL`      | 2             | The server log level. `0=ERROR`, `1=WARNING`, `2=INFO`, `3=VERBOSE`, `4=DEBUG`                                             |
| `MOD_WEBHOOK_URL`           | _none_        | Webhook URL to send the events to. Requires `luasec` to function                                                           |
| `MOD_WEBHOOK_METHOD`        | `POST`        | Webhook request method                                                                                                     |
| `MOD_WEBHOOK_EXTRA_HEADERS` | _none_        | Webhook extra headers in a JSON object                                                                                     |
| `MOD_WEBHOOK_ENABLE_EVENTS` | `all`         | Enable event hook individually. See [webhook documentation](./docs/Webhooks.md) for a complete list.                       |
| `MOD_SERVER_API_URL`        | _none_        | Server API to call from client side                                                                                        |
| `MOD_SERVER_PASSWORD`       | _none_        | Authenticate server request with `Authorization: Basic ` header                                                            |
| `MOD_SERVER_SEND_PARTIAL`   | _none_        | Limit server response chunks to 40 bytes (Set to `true` for older `luasocket` compatibility)                               |
| `MOD_AUTO_FPS_ENABLE`       | _none_        | Enable automatic server traffic adjustment based on the server's FPS                                                       |

### Reloading mod

Due to the webserver being ran on a separate thread, a stop command must be issued before reloading the mods.

1. Send **POST** `/stop` to the `MOD_SERVER_PORT` server. A message `Webserver stopped` will show up in the `UE4SS.log` indicating the webserver has stopped.
2. Send **POST** `/mods/reload` to the `MOD_SERVER_PORT` server. This will reload all the Lua mods including this mod.

## Documentation

More detailed instructions can be found in the [docs](./docs).

## Release Pipeline

This repository uses an automated CI/CD pipeline via GitHub Actions to manage releases and compiled binaries.

### Versioning & Branches

We use a branch-based versioning system. All official releases are maintained on branches named `release/v<number>` (e.g., `release/v19`).

 - **`master` branch**: Used for active development of Lua scripts and C++ source code.
 - **`release/*` branches**: Used for stable deployments. These branches contain both the Lua scripts and the pre-compiled `dlls/main.dll`.

### Automated Build Process

When a push occurs on any branch matching `release/*`:
1.  **GitHub Actions** triggers the `Build and Release` workflow.
2.  It sets up a Windows environment with the necessary MSVC toolset and `xmake`.
3.  The project is compiled into a `Shipping` DLL.
4.  The compiled DLL is then **automatically committed and pushed** back to the same release branch.
5.  A GitHub Release is created/updated with the packaged zip artifacts.

### Git LFS

Binary files, specifically `dlls/main.dll`, are tracked using **Git LFS**. Ensure you have Git LFS installed locally if you intend to work with these files:
```bash
git lfs install
```

## Contributing

More contributions are welcomed! Read how to contribute [here](./docs/CONTRIBUTING.md).
