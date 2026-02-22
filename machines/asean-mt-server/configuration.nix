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
  zramSwap.enable = true;
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
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrAFqHJ125VEDd7jFhOtmBOWg+HSFdRwLSCnUlRtY// github-runner-amc-deploy''
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

    virtualHosts."server.aseanmotorclub.com" = {
      enableACME = true;
      default = true;
      locations = {
        "/api/player_positions/" = {
          proxyPass = "http://localhost:9000/api/player_positions/";
          recommendedProxySettings = true;
          extraConfig = ''
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
          '';
        };
        "/api" = {
          proxyPass = "http://127.0.0.1:9000/api";
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

  services.dokuwiki = {
    webserver = "nginx";
    sites = let
      dokuwiki-plugin-infobox = pkgs.stdenv.mkDerivation {
        name = "infobox";
        src = pkgs.fetchzip {
          url = "https://github.com/Kanaru92/DokuWiki-InfoBox/archive/refs/heads/main.zip";
          sha256 = "sha256-0te3irbkhSA6VxLQq3qIY49y5AgEKm5LgvZGJrOMjAU=";
        };
        sourceRoot = ".";
        installPhase = "mkdir -p $out; cp -R source/* $out/;";
      };
      dokuwiki-plugin-imagebox = pkgs.stdenv.mkDerivation {
        name = "imagebox";
        src = fetchTarball {
          url = "https://github.com/flammy/imagebox/tarball/master";
          sha256 = "sha256:0ir4xavz47qhhk9xiy7rm723scygsgyhgd142js21ga0997wxsbj";
        };
        sourceRoot = ".";
        installPhase = "mkdir -p $out; cp -R source/* $out/;";
      };
    in {
      "wiki.aseanmotorclub.com" = {
        plugins = [
          dokuwiki-plugin-infobox
          dokuwiki-plugin-imagebox
        ];
        settings = {
          title = "ASEAN Motor Club";
          tagline = "AMC Wiki for Motor Town: Behind The Wheel";
          useacl = false;
          userewrite = true;
          updatecheck = false;
        };
      };
    };
  };

  # === OpenCode ===
  users.users.opencode = {
    isSystemUser = true;
    group = "opencode";
    home = "/var/lib/opencode";
    createHome = true;
  };
  users.groups.opencode = {};

  # Headless API server (Tailscale-internal + localhost)
  systemd.services.opencode-serve = {
    description = "OpenCode Serve (Headless API)";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "opencode";
      Group = "opencode";
      WorkingDirectory = "/var/lib/opencode/workspace";
      EnvironmentFile = config.age.secrets.opencode.path;
      Environment = "HOME=/var/lib/opencode";
      ExecStart = "${pkgs.opencode}/bin/opencode serve --hostname 127.0.0.1 --port 4096";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Browser UI
  systemd.services.opencode-web = {
    description = "OpenCode Web UI";
    after = ["network.target" "opencode-serve.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "opencode";
      Group = "opencode";
      WorkingDirectory = "/var/lib/opencode/workspace";
      EnvironmentFile = config.age.secrets.opencode.path;
      Environment = "HOME=/var/lib/opencode";
      ExecStart = "${pkgs.opencode}/bin/opencode web --hostname 127.0.0.1 --port 4097";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Ensure workspace directory exists
  systemd.tmpfiles.rules = [
    "d /var/lib/opencode/workspace 0755 opencode opencode -"
  ];


  # oauth2-proxy: GitHub authentication for OpenCode web UI
  services.oauth2-proxy = {
    enable = true;
    httpAddress = "http://127.0.0.1:4180";
    reverseProxy = true;
    upstream = "http://127.0.0.1:4097";
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
