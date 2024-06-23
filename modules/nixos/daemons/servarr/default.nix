{ config, lib, pkgs, ... }:
{
  imports = [
    ./radarr-alt.nix
    ./sonarr-alt.nix
  ];

  services = {
    # Indexer
    prowlarr.enable = true;

    # Music
    lidarr.enable = true;

    # Movies
    radarr.enable = true;
    radarr-alt.enable = true;

    # TV
    sonarr.enable = true;
    sonarr-alt.enable = true;
  };

  users.users = {
    lidarr.extraGroups = [ "plex" "transmission" ];
    radarr.extraGroups = [ "plex" "transmission" ];
    radarr-alt.extraGroups = [ "plex" "transmission" ];
    sonarr.extraGroups = [ "plex" "transmission" ];
    sonarr-alt.extraGroups = [ "plex" "transmission" ];
  };

  virtualisation.arion = {
    backend = "docker";
    projects = {
      "homarr".settings.services."homarr".service = {
        image = "ghcr.io/ajnart/homarr:latest";
        restart = "unless-stopped";
        volumes = [
          # optional for docker integration
          #"/var/run/docker.sock:/var/run/docker.sock"
          "/var/lib/homarr/configs:/app/data/configs"
          "/var/lib/homarr/icons:/app/public/icons"
          "/var/lib/homarr/data:/data"
        ];
        ports = [
          ''''${PORT:-7575}:7575''
        ];
      };
      "overseerr".settings.services."overseerr".service = {
        image = "sctx/overseerr:latest";
        restart = "unless-stopped";
        environment = {
          LOG_LEVEL = "debug";
          TZ = "Europe/Zurich";
          # optional
          #PORT = "5055";
        };
        volumes = [
          "/var/lib/overseerr/config:/app/config"
        ];
        ports = [
          ''''${PORT:-5055}:5055''
        ];
      };
      "flaresolverr".settings.services."flaresolverr".service = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        restart = "unless-stopped";
        environment = {
          LOG_LEVEL = ''''${LOG_LEVEL:-info}'';
          LOG_HTML = ''''${LOG_HTML:-false}'';
          CAPTCHA_SOLVER = ''''${CAPTCHA_SOLVER:-none}'';
          TZ = "Europe/Zurich";
        };
        ports = [
          ''''${PORT:-8191}:8191''
        ];
      };
    };
  };
}
