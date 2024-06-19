{ config, lib, pkgs, ... }:
{
  services.miniflux = {
    enable = true;
    config = {
      RUN_MIGRATIONS = 1;
      BASE_URL = "https://news.example.com/";
      PORT = 8808;
      FORCE_REFRESH_INTERVAL = 60;
      CREATE_ADMIN = 1;
    };
    admdinCredentialsFile = "/home/taki/miniflux-admin-secret";
  };
}
