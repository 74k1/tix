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
  imports = [
    inputs.tixpkgs.nixosModules'.services.multi-scrobbler
  ];


  age.secrets."multi-scrobbler_env" = {
    rekeyFile = "${inputs.self}/secrets/multi-scrobbler_env.age";
    # mode = "770";
    # owner = "multi-scrobbler";
    # group = "multi-scrobbler";
  };

  services.multi-scrobbler = rec {
    enable = true;
    stateDir = "/mnt/btrfs_pool/multi-scrobbler";

    port = 9078;

    baseUrl = "https://scrobble.${allSecrets.global.domain01}";

    # see below in [[]]
    environmentFile = config.age.secrets."multi-scrobbler_env".path;

    environment = {
      TZ = "Europe/Zurich";
      # PROMETHEUS_FULL = true;
    };

    configFiles = {
      # Clients
      lastfm = {
        name = "lastfm_client";
        configureAs = "client";
        data = {
          apiKey = "[[TIX_LASTFM_API_KEY]]";
          secret = "[[TIX_LASTFM_SECRET]]";
          redirectUri = "${baseUrl}/lastfm/callback";
        };
      };

      tealfm = {
        name = "tealfm_client";
        configureAs = "client";
        data = {
          identifier = "[[TIX_TEALFM_ID]]";
          appPassword = "[[TIX_TEALFM_APP_PASS]]";
        };
      };

      # Sources
      spotify = {
        name = "spotify";
        clients = [
          "lastfm_client"
          "tealfm_client"
        ];
        data = {
          clientId = "[[TIX_SPOTIFY_CLIENT_ID]]";
          clientSecret = "[[TIX_SPOTIFY_CLIENT_SECRET]]";
          redirectUri = "${baseUrl}/callback";
          interval = 60;
        };
      };

      plex = {
        name = "plex";
        clients = [
          "lastfm_client"
          "tealfm_client"
        ];
        data = {
          url = "http://192.168.1.100:32400";
          token = "[[TIX_PLEX_TOKEN]]";
          librariesAllow = [ "[JAM] Music" ];
        };
      };
    };
  };
}
