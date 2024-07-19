{ config, lib, pkgs, ... }:
{
  services.vaultwarden = {
    enable = true;
    environmentFile = "/home/taki/vaultwarden_env_secrets";
    dbBackend = "sqlite";
    # backupDir = "/vaultwarden";
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = "8222";
      DOMAIN = "https://vw.example.com/";
      SIGNUPS_ALLOWED = false;
      SIGNUPS_VERIFY = true;
      SENDS_ALLOWED = true;
      INVITATIONS_ALLOWED = false;
      REQUIRE_DEVICE_EMAIL = true;
      # LOG_FILE = "/var/log/vaultwarden/vaultwarden.log";
      SENDMAIL_COMMAND = "${lib.getExe pkgs.system-sendmail}";
    };
  };
}
