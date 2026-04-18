{pkgs, ...}: let
  package = pkgs.buildNpmPackage {
    pname = "kimaki";
    version = "0.5.0";
    src = ./.;

    # Regenerate after bumping kimaki version:
    #   cd nix/kimaki && nix-shell -p nodejs --run "npm install --package-lock-only"
    #   nix run nixpkgs#prefetch-npm-deps -- package-lock.json > _npmDepsHash
    npmDepsHash = pkgs.lib.trim (builtins.readFile ./_npmDepsHash);

    # Don't run build — this is just a wrapper that installs kimaki from npm
    dontNpmBuild = true;

    # Install the kimaki binary from node_modules
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib
      cp -r node_modules $out/lib/node_modules
      ln -s $out/lib/node_modules/kimaki/bin.js $out/bin/kimaki
      chmod +x $out/bin/kimaki
      runHook postInstall
    '';
  };
in {
  inherit package;
}
