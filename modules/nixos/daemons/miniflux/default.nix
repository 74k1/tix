{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."miniflux_admin" = {
    rekeyFile = "${inputs.self}/secrets/miniflux_admin.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

  services.miniflux = {
    enable = true;
    config = {
      # https://miniflux.app/docs/configuration.html
      RUN_MIGRATIONS = 1;
      BASE_URL = "https://news.example.com/";
      PORT = 8008;
      CLEANUP_FREQUENCY_HOURS = 48;
      FORCE_REFRESH_INTERVAL = 60;
      CREATE_ADMIN = 1;
    };
    adminCredentialsFile = config.age.secrets."miniflux_admin".path;
  };
}
