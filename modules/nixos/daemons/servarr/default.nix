{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
{
  disabledModules = [
    "services/misc/servarr/prowlarr.nix"
    "services/misc/overseerr.nix"
  ];

  imports = [
    # TODO(2026-08-12): Remove nixpkgs-master imports once these modules land in nixos-unstable
    "${inputs.nixpkgs-master}/nixos/modules/services/misc/servarr/prowlarr.nix"
    ./radarr-alt.nix
    ./sonarr-alt.nix
    ./radarr-alp.nix
    ./sonarr-alp.nix
  ];

  services = {
    # Request
    seerr = {
      enable = true;
      package = pkgs.seerr;
    };

    # Indexer
    prowlarr = {
      enable = true;
      settings.update.automatically = false;
    };

    # Music
    lidarr = {
      enable = true;
      package = pkgs.tix.lidarr;
    };

    # Movies
    radarr = {
      enable = true;
      settings.update.automatically = false;
    };
    radarr-alt = {
      enable = true;
    };
    radarr-alp = {
      enable = true;
    };

    # TV
    sonarr = {
      enable = true;
      settings.update.automatically = false;
    };
    sonarr-alt = {
      enable = true;
    };
    sonarr-alp = {
      enable = true;
    };
  };

  users.users = {
    lidarr.extraGroups = [
      "plex"
      "transmission"
    ];
    radarr.extraGroups = [
      "plex"
      "transmission"
    ];
    radarr-alt.extraGroups = [
      "plex"
      "transmission"
    ];
    radarr-alp.extraGroups = [
      "plex"
      "transmission"
    ];
    sonarr.extraGroups = [
      "plex"
      "transmission"
    ];
    sonarr-alp.extraGroups = [
      "plex"
      "transmission"
    ];
  };

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks pods;
    in
    {
      containers = {
        #     "homarr" = {
        #       autoStart = true;
        #       serviceConfig = {
        #         RestartSec = "10";
        #         Restart = "always";
        #       };
        #       containerConfig = {
        #         image = "ghcr.io/ajnart/homarr:latest";
        #         publishPorts = [ "7575:7575" ];
        #         userns = "keep-id";
        #         networks = [ networks.podman-bridge.ref ];
        #         # networks = [ "podman" networks.podman-bridge.ref ];
        #         # pod = pods.servarr.ref;
        #         volumes = [
        #           # optional for docker integration
        #           #"/var/run/docker.sock:/var/run/docker.sock"
        #           "/var/lib/homarr/configs:/app/data/configs"
        #           "/var/lib/homarr/icons:/app/public/icons"
        #           "/var/lib/homarr/data:/data"
        #         ];
        #       };
        #     };
        #     "overseerr" = {
        #       autoStart = true;
        #       serviceConfig = {
        #         RestartSec = "10";
        #         Restart = "always";
        #       };
        #       containerConfig = {
        #         image = "sctx/overseerr:1.32.5";
        #         # publishPorts = [ "5055:5055" ];
        #         # userns = "keep-id";
        #         # networks = [ "host" ];
        #         networks = [ "host" ];
        #         # dns = [ "9.9.9.9" "149.112.112.112" ];
        #         # networks = [ "podman" networks.podman-bridge.ref ];
        #         # pod = pods.servarr.ref;
        #         volumes = [
        #           "/var/lib/overseerr/config:/app/config"
        #         ];
        #         environments = {
        #           LOG_LEVEL = "warn";
        #           TZ = "Europe/Zurich";
        #           # optional
        #           #PORT = "5055";
        #         };
        #       };
        #     };
        "flaresolverr" = {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "ghcr.io/flaresolverr/flaresolverr:latest";
            publishPorts = [ "8191:8191" ];
            networks = [ "podman" ];
            # networks = [ networks.podman-bridge.ref ];
            # networks = [ "podman" networks.podman-bridge.ref ];
            # pod = pods.servarr.ref;
            environments = {
              LOG_LEVEL = "info";
              LOG_HTML = "false";
              CAPTCHA_SOLVER = "none";
              TZ = "Europe/Zurich";
            };
          };
        };
        # https://github.com/Dictionarry-Hub/profilarr
        "profilarr" = {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "ghcr.io/dictionarry-hub/profilarr:latest";
            name = "profilarr";
            publishPorts = [ "6868:6868" ];
            networks = [ "podman" ];
            volumes = [
              "/var/lib/profilarr:/config"
            ];
            environments = {
              PUID = "1000";
              PGID = "1000";
              UMASK = "022";
              TZ = "Europe/Zurich";
              ORIGIN = "https://profilarr.i.${allSecrets.global.domain03}";
              PARSER_HOST = "profilarr-parser";
              PARSER_PORT = "5000";
            };
          };
        };
        # Sidecar for custom format / quality profile testing; reachable only
        # from the podman network (no published port).
        "profilarr-parser" = {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "ghcr.io/dictionarry-hub/profilarr-parser:latest";
            name = "profilarr-parser";
            networks = [ "podman" ];
          };
        };
      };
    };

  # Config dir for the profilarr container, matching its PUID/PGID
  # (numeric IDs to match the container's PUID/PGID contract).
  systemd.tmpfiles.rules = [
    "d /var/lib/profilarr 0755 1000 1000 -"
  ];
}
