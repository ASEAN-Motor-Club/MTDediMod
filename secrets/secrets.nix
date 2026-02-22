let
  owner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcMiNGgqQtOeACMso3CgZz2J3X8Ne8RxsZrQcsnoewU fmnxl-m2";
  asean-mt-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH7Qg2bxMvXPlkcO148QVU5QtdreMY8bfBfMUADOuOCO";
  peripheral = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINuVGOXjiO1bfDBHLjdbi3t9mkLrN8UnHJfLKniHj3+H";
in {
  "steam.age".publicKeys = [owner asean-mt-server];
  "tailscale.age".publicKeys = [owner asean-mt-server];
  "backend.age".publicKeys = [owner peripheral asean-mt-server];
  "cookies.age".publicKeys = [owner peripheral asean-mt-server];
  "ecoUserToken.age".publicKeys = [owner peripheral asean-mt-server];
  "github-runner-token.age".publicKeys = [owner asean-mt-server];
  "github-runner-token-peripheral.age".publicKeys = [owner peripheral];
  "github-runner-ssh.age".publicKeys = [owner asean-mt-server peripheral];
  "peripheral-bots.age".publicKeys = [owner peripheral];
  "discordlink-bot-token.age".publicKeys = [owner peripheral asean-mt-server];
  "opencode.age".publicKeys = [owner asean-mt-server];
  "oauth2-proxy.age".publicKeys = [owner asean-mt-server];
  "coding-agent-app-key.age".publicKeys = [owner asean-mt-server];
}
