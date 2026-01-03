{
  description = "MotorTown Dedicated Server Mods";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    # Custom UE4SS fork
    ue4ss = {
      type = "git";
      url = "https://github.com/ASEAN-Motor-Club/RE-UE4SS.git";
      ref = "feat/reinstall-mods";
      rev = "0b37d7b35b2d62d0895e4399f1b7afeecc54c597";
      submodules = true;
      flake = false;
    };
    
    # UE4SS cross-compile toolchain
    ue4ss-cross = {
      url = "github:ASEAN-Motor-Club/UE4SSCPPTemplate";
      inputs.ue4ss.follows = "ue4ss";  # Use our fork instead of upstream
    };
  };

  outputs = inputs@{ flake-parts, ue4ss-cross, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { system, pkgs, ... }:
        let
          lib = ue4ss-cross.lib.${system};
          configureScript = lib.mkConfigureScript {
            modName = "MotorTownMods";
            proxyPath = "C:\\Windows\\System32\\version.dll";
          };
          configureApp = {
            type = "app";
            program = "${configureScript}/bin/MotorTownMods-configure";
          };

          buildScript = lib.mkBuildScript {
            modName = "MotorTownMods";
          };
          buildApp = {
            type = "app";
            program = "${buildScript}/bin/MotorTownMods-build";
          };

          packageScript = lib.mkPackageScript {
            modName = "MotorTownMods";
            luaScriptsDir = "./Scripts";
            enabledTxtPath = "./enabled.txt";
          };
          packageApp = {
            type = "app";
            program = "${packageScript}/bin/MotorTownMods-package";
          };
        in
        {
          # Development shell with all cross-compile tools
          devShells.default = (lib.mkDevShell {}).overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
              pkgs.gh
              pkgs.lua-language-server
            ];
            shellHook = (old.shellHook or "") + ''
              # Create symlink to UE4SS types for Lua IntelliSense
              if [ -n "$UE4SS_SOURCE_DIR" ] && [ -d "$UE4SS_SOURCE_DIR/assets/Mods/shared" ]; then
                mkdir -p types
                ln -sfn "$UE4SS_SOURCE_DIR/assets/Mods/shared" types/ue4ss
                echo "Created types/ue4ss symlink for Lua IntelliSense"
              fi
            '';
          });

          # Configure script
          apps.configure = configureApp;

          # Build script
          apps.build = buildApp;

          # Package script - creates deployable zip
          apps.package = packageApp;

          # Default to build
          apps.default = buildApp;
        };
    };
}
