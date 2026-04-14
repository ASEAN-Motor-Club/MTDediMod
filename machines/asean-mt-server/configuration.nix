{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = let
    disko = builtins.fetchTarball {
      url = "https://github.com/nix-community/disko/archive/85555d27ded84604ad6657ecca255a03fd878607.tar.gz";
      sha256 = "sha256:173zd7p46kmbk75v5nc2mvnmq1x2i5rxs1wymg0hvmqan0w2q7pm";
    };
  in [
    ./hardware-configuration.nix
    "${disko}/module.nix"
    ./disko-config.nix
  ];
  disko.devices.disk.main.device = "/dev/nvme0n1";

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  boot.kernel.sysctl."vm.swappiness" = 0;
  boot.kernel.sysctl."kernel.sched_autogroup_enabled" = 0;  # Disable desktop fairness — hurts dedicated server workloads
  boot.kernel.sysctl."net.core.rmem_max" = 4194304;       # 4MB — game server UDP receive buffers (was 208KB)
  boot.kernel.sysctl."net.core.wmem_max" = 4194304;       # 4MB — game server UDP send buffers
  boot.kernel.sysctl."net.core.rmem_default" = 1048576;   # 1MB default for new sockets
  boot.kernel.sysctl."net.core.wmem_default" = 1048576;
  networking.hostName = "asean-mt-server";
  networking.domain = "";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443 8000 8008 7777 27015];
    allowedUDPPorts = [7777 27015];
  };
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcMiNGgqQtOeACMso3CgZz2J3X8Ne8RxsZrQcsnoewU fmnxl-m2''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO75UM3IHNzJKUxgABH6OHa/hxfQIoxTs+nGUtSU1TID''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgWg22wCzJ4qJKDnAXz/q+LsUTyuSGO7R91C+h8B1qE github-actions-deploy''
  ];
  system.stateVersion = "23.11";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;
  services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "steam";
  services.xserver.xkb = {
    layout = "us";
  };
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  programs.atop.enable = true;
  time.timeZone = "Asia/Bangkok";

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steamcmd"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "motortown-server"
      "steamworks-sdk-redist"
    ];
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    package = pkgs.steam.override {
      extraPkgs = pkgs: [
        pkgs.openssl
        pkgs.libgdiplus
      ];
    };
  };
  programs.steam.protontricks.enable = true;

  environment.systemPackages = with pkgs; [
    kakoune
    steamcmd
    depotdownloader
    htop
    steam-tui
  ];
  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale.path;
  };



  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    # Catch-all: reject requests with unrecognized Host headers (e.g. direct IP access)
    virtualHosts."_" = {
      default = true;
      rejectSSL = true;
      locations."/".return = "444";
    };

    virtualHosts."eco.aseanmotorclub.com" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:3001";
        };
      };
    };
    virtualHosts."server.aseanmotorclub.com" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/api/player_positions/" = {
          proxyPass = "http://localhost:9000/api/player_positions/";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
          '';
        };
        "/api/player_count/" = {
          proxyPass = "http://localhost:9000/api/player_count/";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS' always;
          '';
        };
        "/api/player_positions_b" = {
          proxyPass = "http://localhost:9000/api/player_positions_b";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            add_header 'Access-Control-Allow-Origin' '*' always;
          '';
        };
        "/api" = {
          proxyPass = "http://127.0.0.1:9000/api";
          recommendedProxySettings = true;
          extraConfig = ''
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
          '';
        };
        "/login/token" = {
          proxyPass = "http://127.0.0.1:9000/login/token";
          extraConfig = ''
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
          '';
        };
        "/docs" = {
          proxyPass = "http://127.0.0.1:8002/docs";
          extraConfig = ''
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
          '';
        };
        "/openapi.json" = {
          proxyPass = "http://127.0.0.1:8002/openapi.json";
          extraConfig = ''
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
          '';
        };
        "/eco" = {
          proxyPass = "http://127.0.0.1:3001";
        };
        "/errors/" = {
          alias = "/var/lib/amc/error-reports/";
          extraConfig = ''
            autoindex off;
            types { text/html html; }
          '';
        };
        "/" = {
          root = "/srv/www";
          extraConfig = ''
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
          '';
        };
      };
    };
  };

  security.acme.defaults.email = "contact@fmnxl.xyz";
  security.acme.acceptTerms = true;



  # === OpenCode ===
  users.users.opencode = {
    isSystemUser = true;
    group = "opencode";
    home = "/var/lib/opencode";
    createHome = true;
  };
  users.groups.opencode = {};

  # Headless API server + web UI (v1.2.x serve includes web UI)
  systemd.services.opencode-serve = {
    description = "OpenCode Serve (Headless API)";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    path = with pkgs; [git openssh gh ripgrep fzf coreutils jq openssl curl];

    environment = {
      HOME = "/var/lib/opencode";
      GITHUB_APP_ID = "2922326";
      GITHUB_INSTALLATION_ID = "111712229";
    };

    serviceConfig = {
      Type = "simple";
      User = "opencode";
      Group = "opencode";
      WorkingDirectory = "/var/lib/opencode/workspace";
      EnvironmentFile = config.age.secrets.opencode.path;
      Restart = "on-failure";
      RestartSec = 5;
    };

    script = ''
      set -euo pipefail

      # --- Generate GitHub App installation token ---
      APP_KEY="${config.age.secrets.coding-agent-app-key.path}"
      NOW=$(date +%s)
      IAT=$((NOW - 60))
      EXP=$((NOW + 600))

      # Base64url encode helper
      b64url() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }

      HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | b64url)
      PAYLOAD=$(echo -n "{\"iat\":$IAT,\"exp\":$EXP,\"iss\":\"$GITHUB_APP_ID\"}" | b64url)
      SIGNATURE=$(echo -n "$HEADER.$PAYLOAD" | openssl dgst -sha256 -sign "$APP_KEY" | b64url)
      JWT="$HEADER.$PAYLOAD.$SIGNATURE"

      # Exchange JWT for installation access token
      RESPONSE=$(curl -s -X POST \
        -H "Authorization: Bearer $JWT" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens")

      export GH_TOKEN=$(echo "$RESPONSE" | jq -r '.token')
      if [ "$GH_TOKEN" = "null" ] || [ -z "$GH_TOKEN" ]; then
        echo "ERROR: Failed to get installation token: $RESPONSE"
        exit 1
      fi
      echo "GitHub App token acquired"

      # Configure git to use HTTPS with token
      git config --global user.name "AMC Coding Agent[bot]"
      git config --global user.email "2922326+amc-coding-agent[bot]@users.noreply.github.com"
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "https://github.com/"
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "git@github.com:"

      exec ${pkgs.opencode}/bin/opencode serve --hostname 127.0.0.1 --port 4096
    '';
  };

  # Ensure workspace directory exists
  systemd.tmpfiles.rules = [
    "d /var/lib/opencode/workspace 0755 opencode opencode -"
    "d /var/lib/mod-releases 0755 root root -"
    # Transparent Huge Pages: reduces TLB misses for game server's 7.6 GB working set.
    # Wine/Proton won't call madvise(), so 'always' is needed.
    # defer+madvise defrag avoids stalling the allocating process.
    "w /sys/kernel/mm/transparent_hugepage/enabled - - - - always"
    "w /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
  ];


  # oauth2-proxy: GitHub authentication for OpenCode web UI
  services.oauth2-proxy = {
    enable = true;
    httpAddress = "http://127.0.0.1:4180";
    reverseProxy = true;
    upstream = "http://127.0.0.1:4096";
    provider = "github";
    github.org = "ASEAN-Motor-Club";
    cookie.domain = "code.aseanmotorclub.com";
    cookie.secure = true;
    email.domains = ["*"];
    setXauthrequest = true;
    extraConfig = {
      skip-provider-button = "true";
    };
    keyFile = config.age.secrets.oauth2-proxy.path;
  };

  # Nginx vhost for OpenCode web UI (behind oauth2-proxy)
  services.nginx.virtualHosts."code.aseanmotorclub.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4180";
      extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
      '';
    };
  };
}
