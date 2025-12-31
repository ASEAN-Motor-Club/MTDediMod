{
  description = "MotorTown Dedicated Server Mods";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    # Custom UE4SS fork
    ue4ss = {
      type = "git";
      url = "https://github.com/ASEAN-Motor-Club/RE-UE4SS.git";
      rev = "740c61d030f14269d311cdcb4ae2b830df9f43de";
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

      perSystem = { system, ... }:
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
          devShells.default = lib.mkDevShell {};

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
