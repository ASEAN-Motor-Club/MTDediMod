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
    
    # UE4SS cross-compile toolchain with our fork
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
        in
        {
          # Development shell with all cross-compile tools
          devShells.default = lib.mkDevShell {};

          # Build script (run with `nix run`)
          apps.default = {
            type = "app";
            program = "${lib.mkBuildScript {
              modDir = ./src;
              modName = "MotorTownMods";
            }}/bin/MotorTownMods-build";
          };
        };
    };
}

