{
  description = "MotorTown Dedicated Server Mods";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ue4ss = {
      type = "git";
      url = "https://github.com/UE4SS-RE/RE-UE4SS.git";
      submodules = true;
      flake = false;
    };
  };

  outputs = inputs @ {
    flake-parts,
    ue4ss,
    fenix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        # === Cross-compilation toolchain (inlined from UE4SSCPPTemplate) ===
        # Configure Rust toolchain with MSVC target support
        rustToolchain = with fenix.packages.${system};
          combine [
            minimal.toolchain
            targets.x86_64-pc-windows-msvc.latest.rust-std
          ];

        # Dependencies required for cross-compilation
        crossCompileBuildInputs = with pkgs; [
          cmake
          ninja
          llvmPackages.clang-unwrapped
          llvmPackages.bintools
          llvmPackages.llvm
          rustToolchain
          git
          xwin
          openssl
          pkg-config
          libiconv
          python3
          lld
        ];

        # Patched UE4SS source with cross-compile support
        patchedUE4SS = pkgs.stdenv.mkDerivation {
          name = "ue4ss-patched";
          src = ue4ss;

          phases = ["unpackPhase" "patchPhase" "installPhase"];

          patches = [./patches-ue4ss/ue4ss-cross-compile.patch];

          installPhase = ''
            mkdir -p $out
            cp -r . $out

            # Overlay custom proxy generator files
            mkdir -p $out/UE4SS/proxy_generator/exports
            cp ${./proxy_generator/proxy_generator.py} $out/UE4SS/proxy_generator/proxy_generator.py
            cp -r ${./proxy_generator/exports}/* $out/UE4SS/proxy_generator/exports/
          '';
        };

        # Environment variables for cross-compilation
        crossCompileEnv = ''
          export CLANG_UNWRAPPED_BIN="${pkgs.llvmPackages.clang-unwrapped}/bin/clang"
          export CLANG_CL_UNWRAPPED_BIN="${pkgs.llvmPackages.clang-unwrapped}/bin/clang-cl"
          export UE4SS_SOURCE_DIR="${patchedUE4SS}"
        '';

        # === Mod-specific configuration ===
        modName = "MotorTownMods";
        buildType = "Game__Shipping__Win64";
        proxyPath = "C:\\Windows\\System32\\version.dll";

        # Legacy v0.30.0 release used to extract pre-built Lua binaries (luasocket, cjson, etc.)
        luaBinaries = pkgs.fetchzip {
          url = "https://github.com/ASEAN-Motor-Club/MTDediMod/releases/download/v0.30.0/MotorTownMods_v0.30.0.zip";
          hash = "sha256-YEQMtij/WoSEAVVVYgdA4kP5zkzhkHc2gTc3hKbyHCQ=";
          stripRoot = false;
        };

        # Client-side proxy path
        clientProxyPath = "C:\\Windows\\System32\\dwmapi.dll";
        clientBuildDir = "build-cross-client";

        configureScript = pkgs.writeShellApplication {
          name = "${modName}-configure";
          runtimeInputs = crossCompileBuildInputs;
          text = ''
                          # Setup environment
                          ${crossCompileEnv}
                          export BUILD_TYPE="${buildType}"
                          export UE4SS_PROXY_PATH="${proxyPath}"

                          # Create CMakeLists.txt wrapper
                          cat > CMakeLists.txt <<EOF
            cmake_minimum_required(VERSION 3.22)
            project(UE4SSWrapper)
            if(NOT UE4SS_SOURCE_DIR)
                set(UE4SS_SOURCE_DIR "$UE4SS_SOURCE_DIR")
            endif()
            add_subdirectory("''${UE4SS_SOURCE_DIR}" RE-UE4SS)
            add_subdirectory("src" ${modName})
            EOF

                          # Run setup script (downloads MSVC headers via xwin and runs cmake -B)
                          ${builtins.readFile ./setup_cross_compile.sh}
          '';
        };

        buildScript = pkgs.writeShellApplication {
          name = "${modName}-build";
          runtimeInputs = crossCompileBuildInputs;
          text = ''
            # Setup environment
            ${crossCompileEnv}

            if [ ! -d "build-cross" ]; then
              echo "Error: build-cross directory not found. Please run 'nix run .#configure' first."
              exit 1
            fi

            # Build
            CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
            cmake --build build-cross -j"''${NIX_BUILD_CORES:-$CORES}" "$@"

            echo "Build complete. Output in build-cross/${buildType}/"
          '';
        };

        packageScript = pkgs.writeShellApplication {
          name = "${modName}-package";
          runtimeInputs = with pkgs; [coreutils zip gnused];
          text = ''
                          set -e

                          MOD_NAME="${modName}"
                          BUILD_TYPE="${buildType}"
                          PACKAGE_DIR="package"
                          LUA_SCRIPTS_DIR="./Scripts"
                          SHARED_LUA_DIR="./shared"
                          INCLUDE_SETTINGS="true"
                          ENABLED_TXT_PATH="./enabled.txt"
                          UE4SS_SETTINGS_SRC="${patchedUE4SS}/assets/UE4SS-settings.ini"

                          echo "=========================================="
                          echo "Packaging $MOD_NAME for distribution"
                          echo "=========================================="

                          # Verify build exists
                          if [ ! -d "build-cross" ]; then
                            echo "Error: build-cross directory not found. Please run 'nix run .#build' first."
                            exit 1
                          fi

                          # Find proxy DLL
                          PROXY_DLL=""
                          for proxy in "version.dll" "dwmapi.dll"; do
                            if [ -f "build-cross/$BUILD_TYPE/bin/$proxy" ]; then
                              PROXY_DLL="$proxy"
                              break
                            fi
                          done

                          if [ -z "$PROXY_DLL" ]; then
                            echo "Error: No proxy DLL (version.dll or dwmapi.dll) found in build-cross/$BUILD_TYPE/bin/"
                            exit 1
                          fi

                          # Verify required files exist
                          if [ ! -f "build-cross/$BUILD_TYPE/bin/UE4SS.dll" ]; then
                            echo "Error: UE4SS.dll not found in build-cross/$BUILD_TYPE/bin/"
                            exit 1
                          fi

                          if [ ! -f "build-cross/$MOD_NAME/$MOD_NAME.dll" ]; then
                            echo "Error: $MOD_NAME.dll not found in build-cross/$MOD_NAME/"
                            exit 1
                          fi

                          echo "Found proxy DLL: $PROXY_DLL"
                          echo "Creating package structure..."

                          # Clean and create package directory
                          rm -rf "$PACKAGE_DIR"
                          mkdir -p "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/dlls"

                          # Copy proxy DLL to root (where game .exe is)
                          cp "build-cross/$BUILD_TYPE/bin/$PROXY_DLL" "$PACKAGE_DIR/"
                          echo "✓ Copied $PROXY_DLL"

                          # Copy UE4SS.dll to ue4ss/
                          cp "build-cross/$BUILD_TYPE/bin/UE4SS.dll" "$PACKAGE_DIR/ue4ss/"
                          echo "✓ Copied UE4SS.dll"

                          # Copy mod DLL (renamed to main.dll per UE4SS convention)
                          cp "build-cross/$MOD_NAME/$MOD_NAME.dll" "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/dlls/main.dll"
                          echo "✓ Copied $MOD_NAME.dll -> dlls/main.dll"

                          # Copy Lua scripts
                          if [ -n "$LUA_SCRIPTS_DIR" ] && [ -d "$LUA_SCRIPTS_DIR" ]; then
                            mkdir -p "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/Scripts"
                            cp -r "$LUA_SCRIPTS_DIR"/* "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/Scripts/"
                            SCRIPT_COUNT=$(find "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/Scripts" -name "*.lua" | wc -l)
                            echo "✓ Copied $SCRIPT_COUNT Lua scripts"
                          fi

                          # Copy enabled.txt
                          if [ -n "$ENABLED_TXT_PATH" ] && [ -f "$ENABLED_TXT_PATH" ]; then
                            cp "$ENABLED_TXT_PATH" "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/enabled.txt"
                          else
                            touch "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/enabled.txt"
                          fi
                          echo "✓ Created enabled.txt"

                          # Copy UE4SS settings
                          if [ "$INCLUDE_SETTINGS" = "true" ]; then
                            if [ -f "$UE4SS_SETTINGS_SRC" ]; then
                              cp --no-preserve=mode,ownership "$UE4SS_SETTINGS_SRC" "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                              # Apply production patches (disable console and debug GUI)
                              sed -i 's/^ConsoleEnabled\s*=.*/ConsoleEnabled = 0/' "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                              sed -i 's/^GuiConsoleEnabled\s*=.*/GuiConsoleEnabled = 0/' "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                              sed -i 's/^GuiConsoleVisible\s*=.*/GuiConsoleVisible = 0/' "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                              sed -i 's/^EnableHotReloadSystem\s*=.*/EnableHotReloadSystem = 0/' "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                              echo "✓ Copied and patched UE4SS-settings.ini from upstream"
                            else
                              echo "⚠ Warning: Upstream UE4SS-settings.ini not found at $UE4SS_SETTINGS_SRC"
                            fi
                          fi

                          # Copy shared folder (contains UEHelpers and other Lua utilities)
                          UE4SS_SHARED_SRC="${patchedUE4SS}/assets/Mods/shared"
                          if [ -d "$UE4SS_SHARED_SRC" ]; then
                            cp --no-preserve=mode,ownership -r "$UE4SS_SHARED_SRC" "$PACKAGE_DIR/ue4ss/Mods/"
                            echo "✓ Copied shared folder (UEHelpers, Types.lua, etc.)"
                          else
                            echo "⚠ Warning: shared folder not found at $UE4SS_SHARED_SRC"
                          fi

                          # Copy project-local shared Lua libraries (e.g. MTHelpers)
                          if [ -n "$SHARED_LUA_DIR" ] && [ -d "$SHARED_LUA_DIR" ]; then
                            # Copy contents into the shared folder (next to UEHelpers)
                            cp -r "$SHARED_LUA_DIR"/* "$PACKAGE_DIR/ue4ss/Mods/shared/"
                            echo "✓ Copied project shared Lua libraries from $SHARED_LUA_DIR"
                          fi

                          # Copy legacy Lua binaries (socket, mime, cjson, etc.) from HTTP download
                          if [ -d "${luaBinaries}/ue4ss/Mods/shared" ]; then
                            # Copying selectively replacing only missing binaries/scripts to avoid overwriting newer MTHelpers
                            # (actually just copying socket, mime, cjson, ltn12, json2lua, lua2json)
                            cp --no-preserve=mode,ownership -rn "${luaBinaries}/ue4ss/Mods/shared"/* "$PACKAGE_DIR/ue4ss/Mods/shared/" || true
                            echo "✓ Injected legacy Lua binary dependencies (socket, cjson, etc) from HTTP download"
                          fi

                          # Create mods.txt
                          echo "$MOD_NAME : 1" > "$PACKAGE_DIR/ue4ss/Mods/mods.txt"
                          echo "✓ Created mods.txt"

                          # Create mods.json
                          cat > "$PACKAGE_DIR/ue4ss/Mods/mods.json" << EOF
            [
                {
                    "mod_name": "$MOD_NAME",
                    "mod_enabled": true
                }
            ]
            EOF
                          echo "✓ Created mods.json"

                          echo ""
                          echo "Package structure:"
                          find "$PACKAGE_DIR" -type f | sort | sed 's/^/  /'

                          # Create zip
                          ZIP_NAME="$MOD_NAME-package.zip"
                          rm -f "$ZIP_NAME"
                          (cd "$PACKAGE_DIR" && zip -r "../$ZIP_NAME" .)

                          echo ""
                          echo "=========================================="
                          echo "✓ Package created: $ZIP_NAME"
                          echo "=========================================="
                          echo ""
                          echo "To deploy:"
                          echo "  1. Extract $ZIP_NAME to your game's executable directory"
                          echo "  2. The proxy DLL ($PROXY_DLL) should be next to the game .exe"
                          echo "  3. The ue4ss/ folder should be in the same directory"
                          echo ""
          '';
        };

        # Client-side mod packaging (Lua-only, cross-compiled UE4SS with dwmapi.dll proxy)
        clientModName = "MotorTownClientMod";

        # UE4SS_Signatures for Motor Town (shared between server and client)
        ue4ssSignaturesDir = ./client-signatures;

        configureClientScript = pkgs.writeShellApplication {
          name = "${clientModName}-configure";
          runtimeInputs = crossCompileBuildInputs;
          text = ''
                          # Setup environment
                          ${crossCompileEnv}
                          export BUILD_TYPE="${buildType}"
                          export BUILD_DIR="${clientBuildDir}"
                          export UE4SS_PROXY_PATH="${clientProxyPath}"

                          # Create CMakeLists.txt wrapper (same as server — mod DLL will be built but not packaged)
                          cat > CMakeLists.txt <<EOF
            cmake_minimum_required(VERSION 3.22)
            project(UE4SSWrapper)
            if(NOT UE4SS_SOURCE_DIR)
                set(UE4SS_SOURCE_DIR "$UE4SS_SOURCE_DIR")
            endif()
            add_subdirectory("''${UE4SS_SOURCE_DIR}" RE-UE4SS)
            add_subdirectory("src" ${modName})
            EOF

                          # Run setup script (downloads MSVC headers via xwin and runs cmake -B)
                          ${builtins.readFile ./setup_cross_compile.sh}
          '';
        };

        buildClientScript = pkgs.writeShellApplication {
          name = "${clientModName}-build";
          runtimeInputs = crossCompileBuildInputs;
          text = ''
            # Setup environment
            ${crossCompileEnv}

            if [ ! -d "${clientBuildDir}" ]; then
              echo "Error: ${clientBuildDir} directory not found. Please run 'nix run .#configure-client' first."
              exit 1
            fi

            # Build
            CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
            cmake --build "${clientBuildDir}" -j"''${NIX_BUILD_CORES:-$CORES}" "$@"

            echo "Build complete. Output in ${clientBuildDir}/${buildType}/"
          '';
        };

        packageClientScript = pkgs.writeShellApplication {
          name = "${clientModName}-package";
          runtimeInputs = with pkgs; [coreutils zip gnused];
          text = ''
                          set -e

                          MOD_NAME="${clientModName}"
                          BUILD_TYPE="${buildType}"
                          BUILD_DIR="${clientBuildDir}"
                          PACKAGE_DIR="package-client"
                          LUA_SCRIPTS_DIR="./ClientScripts"
                          SHARED_LUA_DIR="./shared"
                          UE4SS_SETTINGS_SRC="${patchedUE4SS}/assets/UE4SS-settings.ini"

                          echo "=========================================="
                          echo "Packaging $MOD_NAME (client mod) for distribution"
                          echo "=========================================="

                          # Verify client scripts exist
                          if [ ! -d "$LUA_SCRIPTS_DIR" ]; then
                            echo "Error: ClientScripts directory not found."
                            exit 1
                          fi

                          # Verify cross-compiled binaries exist
                          if [ ! -d "$BUILD_DIR" ]; then
                            echo "Error: $BUILD_DIR directory not found. Please run 'nix run .#configure-client' and 'nix run .#build-client' first."
                            exit 1
                          fi

                          # Find proxy DLL (should be dwmapi.dll)
                          PROXY_DLL=""
                          for proxy in "dwmapi.dll" "version.dll"; do
                            if [ -f "$BUILD_DIR/$BUILD_TYPE/bin/$proxy" ]; then
                              PROXY_DLL="$proxy"
                              break
                            fi
                          done

                          if [ -z "$PROXY_DLL" ]; then
                            echo "Error: No proxy DLL found in $BUILD_DIR/$BUILD_TYPE/bin/"
                            echo "Please run 'nix run .#build-client' first."
                            exit 1
                          fi

                          if [ ! -f "$BUILD_DIR/$BUILD_TYPE/bin/UE4SS.dll" ]; then
                            echo "Error: UE4SS.dll not found in $BUILD_DIR/$BUILD_TYPE/bin/"
                            exit 1
                          fi

                          echo "Creating package structure..."

                          # Clean and create package directory
                          rm -rf "$PACKAGE_DIR"
                          mkdir -p "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/Scripts"

                          # Copy cross-compiled proxy DLL
                          cp "$BUILD_DIR/$BUILD_TYPE/bin/$PROXY_DLL" "$PACKAGE_DIR/"
                          echo "✓ Copied $PROXY_DLL (cross-compiled proxy)"

                          # Copy cross-compiled UE4SS.dll
                          cp "$BUILD_DIR/$BUILD_TYPE/bin/UE4SS.dll" "$PACKAGE_DIR/ue4ss/"
                          echo "✓ Copied UE4SS.dll (cross-compiled)"

                          # Copy UE4SS settings (patched for client use)
                          # NOTE: shipped for new installs — use non-clobbering extraction on the player side
                          if [ -f "$UE4SS_SETTINGS_SRC" ]; then
                            cp --no-preserve=mode,ownership "$UE4SS_SETTINGS_SRC" "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                            sed -i 's/^ConsoleEnabled\s*=.*/ConsoleEnabled = 1/' "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                            sed -i 's/^GuiConsoleEnabled\s*=.*/GuiConsoleEnabled = 1/' "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                            sed -i 's/^GuiConsoleVisible\s*=.*/GuiConsoleVisible = 0/' "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                            sed -i 's/^EnableHotReloadSystem\s*=.*/EnableHotReloadSystem = 1/' "$PACKAGE_DIR/ue4ss/UE4SS-settings.ini"
                            echo "✓ Copied and patched UE4SS-settings.ini for client (hot reload enabled)"
                          else
                            echo "⚠ Warning: UE4SS-settings.ini not found at $UE4SS_SETTINGS_SRC"
                          fi

                          # Copy UE4SS_Signatures for Motor Town
                          if [ -d "${ue4ssSignaturesDir}" ]; then
                            cp -r "${ue4ssSignaturesDir}" "$PACKAGE_DIR/ue4ss/UE4SS_Signatures"
                            echo "✓ Copied UE4SS_Signatures"
                          else
                            echo "⚠ Warning: UE4SS_Signatures not found at ${ue4ssSignaturesDir}"
                          fi

                          # Copy client Lua scripts
                          cp -r "$LUA_SCRIPTS_DIR"/* "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/Scripts/"
                          # Remove enabled.txt from Scripts if it ended up there
                          rm -f "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/Scripts/enabled.txt"
                          SCRIPT_COUNT=$(find "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/Scripts" -name "*.lua" | wc -l)
                          echo "✓ Copied $SCRIPT_COUNT client Lua scripts"

                          # Copy enabled.txt
                          if [ -f "$LUA_SCRIPTS_DIR/enabled.txt" ]; then
                            cp "$LUA_SCRIPTS_DIR/enabled.txt" "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/enabled.txt"
                          else
                            touch "$PACKAGE_DIR/ue4ss/Mods/$MOD_NAME/enabled.txt"
                          fi
                          echo "✓ Created enabled.txt"

                          # Copy shared folder (UEHelpers from upstream UE4SS)
                          UE4SS_SHARED_SRC="${patchedUE4SS}/assets/Mods/shared"
                          if [ -d "$UE4SS_SHARED_SRC" ]; then
                            cp --no-preserve=mode,ownership -r "$UE4SS_SHARED_SRC" "$PACKAGE_DIR/ue4ss/Mods/"
                            echo "✓ Copied shared folder (UEHelpers, Types.lua, etc.)"
                          fi

                          # Copy project-local shared Lua libraries (MTHelpers)
                          if [ -d "$SHARED_LUA_DIR" ]; then
                            cp -r "$SHARED_LUA_DIR"/* "$PACKAGE_DIR/ue4ss/Mods/shared/"
                            echo "✓ Copied project shared Lua libraries"
                          fi

                          # Copy legacy Lua binaries (socket, mime, etc.)
                          if [ -d "${luaBinaries}/ue4ss/Mods/shared" ]; then
                            cp --no-preserve=mode,ownership -rn "${luaBinaries}/ue4ss/Mods/shared"/* "$PACKAGE_DIR/ue4ss/Mods/shared/" || true
                            echo "✓ Injected legacy Lua binary dependencies (socket, etc)"
                          fi

                          # Create mods.txt
                          # BPModLoaderMod + BPML_GenericFunctions required for Blueprint pak mods in LogicMods/
                          cat > "$PACKAGE_DIR/ue4ss/Mods/mods.txt" << MODSTXT
            $MOD_NAME : 1
            BPML_GenericFunctions : 1
            BPModLoaderMod : 1
            MODSTXT
                          echo "✓ Created mods.txt"

                          # Copy BPModLoaderMod and BPML_GenericFunctions from UE4SS v3 release
                          UE4SS_RELEASE_MODS="$HOME/Downloads/UE4SS_v3.0.1-946-g265115c0/ue4ss/Mods"
                          if [ -d "$UE4SS_RELEASE_MODS/BPModLoaderMod" ]; then
                            cp -r "$UE4SS_RELEASE_MODS/BPModLoaderMod" "$PACKAGE_DIR/ue4ss/Mods/"
                            touch "$PACKAGE_DIR/ue4ss/Mods/BPModLoaderMod/enabled.txt"
                            echo "✓ Copied BPModLoaderMod (Scripts + load_order.txt + enabled.txt)"
                          else
                            echo "⚠ Warning: BPModLoaderMod not found at $UE4SS_RELEASE_MODS/BPModLoaderMod"
                          fi
                          if [ -d "$UE4SS_RELEASE_MODS/BPML_GenericFunctions" ]; then
                            cp -r "$UE4SS_RELEASE_MODS/BPML_GenericFunctions" "$PACKAGE_DIR/ue4ss/Mods/"
                            touch "$PACKAGE_DIR/ue4ss/Mods/BPML_GenericFunctions/enabled.txt"
                            echo "✓ Copied BPML_GenericFunctions (Scripts + enabled.txt)"
                          else
                            echo "⚠ Warning: BPML_GenericFunctions not found at $UE4SS_RELEASE_MODS/BPML_GenericFunctions"
                          fi

                          # Create mods.json
                          cat > "$PACKAGE_DIR/ue4ss/Mods/mods.json" << EOF
            [
                {
                    "mod_name": "$MOD_NAME",
                    "mod_enabled": true
                },
                {
                    "mod_name": "BPML_GenericFunctions",
                    "mod_enabled": true
                },
                {
                    "mod_name": "BPModLoaderMod",
                    "mod_enabled": true
                }
            ]
            EOF
                          echo "✓ Created mods.json"

                          echo ""
                          echo "Package structure:"
                          find "$PACKAGE_DIR" -type f | sort | sed 's/^/  /'

                          # Create zip
                          ZIP_NAME="$MOD_NAME-package.zip"
                          rm -f "$ZIP_NAME"
                          (cd "$PACKAGE_DIR" && zip -r "../$ZIP_NAME" .)

                          echo ""
                          echo "=========================================="
                          echo "✓ Package created: $ZIP_NAME"
                          echo "=========================================="
                          echo ""
                          echo "To install:"
                          echo "  1. Extract $ZIP_NAME to your Motor Town game directory"
                          echo "     (e.g. .../MotorTown/Binaries/Win64/)"
                          echo "  2. The $PROXY_DLL should be next to MotorTown-Win64-Shipping.exe"
                          echo "  3. The ue4ss/ folder should be in the same directory"
                          echo ""
          '';
        };
      in {
        # Development shell with all cross-compile tools
        devShells.default = pkgs.mkShell {
          buildInputs =
            crossCompileBuildInputs
            ++ (with pkgs; [
              gh
              lua-language-server
              lua5_4
              lua54Packages.busted
              lua54Packages.luasocket
            ]);
          shellHook = ''
            echo "UE4SS Cross-Compile Environment loaded."
            ${crossCompileEnv}
            echo "UE4SS source at: $UE4SS_SOURCE_DIR"

            # Create symlink to UE4SS types for Lua IntelliSense
            if [ -n "$UE4SS_SOURCE_DIR" ] && [ -d "$UE4SS_SOURCE_DIR/assets/Mods/shared" ]; then
              mkdir -p types
              ln -sfn "$UE4SS_SOURCE_DIR/assets/Mods/shared" types/ue4ss
              echo "Created types/ue4ss symlink for Lua IntelliSense"
            fi
          '';
        };

        # Configure script
        apps.configure = {
          type = "app";
          program = "${configureScript}/bin/${modName}-configure";
        };

        # Build script
        apps.build = {
          type = "app";
          program = "${buildScript}/bin/${modName}-build";
        };

        # Package script - creates deployable zip
        apps.package = {
          type = "app";
          program = "${packageScript}/bin/${modName}-package";
        };

        # Client mod configure script (cross-compiles UE4SS with dwmapi.dll proxy)
        apps.configure-client = {
          type = "app";
          program = "${configureClientScript}/bin/${clientModName}-configure";
        };

        # Client mod build script
        apps.build-client = {
          type = "app";
          program = "${buildClientScript}/bin/${clientModName}-build";
        };

        # Client mod package script - creates client-side Lua-only zip
        apps.package-client = {
          type = "app";
          program = "${packageClientScript}/bin/${clientModName}-package";
        };

        # pak-manager: rebuild ModManager_P.pak from freshly cooked bp_assets/
        apps.pack-manager = {
          type = "app";
          program = "${pkgs.writeShellApplication {
            name = "pack-manager";
            runtimeInputs = [];
            text = ''
              REPAK="$HOME/repak/target/release/repak"

              ASSETS="$PWD/bp_assets"
              PAK_OUT="$HOME/mt-pak-extract/ModManager.pak"
              STAGE="$(mktemp -d)"

              echo "Staging assets from $ASSETS..."
              mkdir -p "$STAGE/MotorTown/Content/Mods/ModManager"
              for f in ModActor.uasset ModActor.uexp WBP_ModManager.uasset WBP_ModManager.uexp WBP_ModManagerEntry.uasset WBP_ModManagerEntry.uexp; do
                if [ -f "$ASSETS/$f" ]; then
                  cp "$ASSETS/$f" "$STAGE/MotorTown/Content/Mods/ModManager/"
                  echo "  ✓ $f"
                else
                  echo "  ⚠ Missing: $ASSETS/$f"
                fi
              done

              rm -f "$PAK_OUT"
              "$REPAK" pack --version V11 "$STAGE" "$PAK_OUT"
              rm -rf "$STAGE"
              echo "✓ Built: $PAK_OUT ($(du -sh "$PAK_OUT" | cut -f1))"
            '';
          }}/bin/pack-manager";
        };

        # Default to build
        apps.default = {
          type = "app";
          program = "${buildScript}/bin/${modName}-build";
        };
      };
    };
}
