{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."miniflux_secrets" = {
    rekeyFile = "${inputs.self}/secrets/miniflux_secrets.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = config.age.secrets."miniflux_secrets".path;
    config = {
      PORT = 8084;
      BASE_URL = "https://news.example.com/";
    };
  };
}
