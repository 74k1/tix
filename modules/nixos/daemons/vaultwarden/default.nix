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
      # PUSH_ENABLED = true;
      # PUSH_INSTALLATION_ID=CHANGEME;
      # PUSH_INSTALLATION_KEY=CHANGEME;
      # PUSH_RELAY_URI=https://push.bitwarden.eu/
      # PUSH_IDENTITY_URI=https://identity.bitwarden.eu/
      SENDS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;
      REQUIRE_DEVICE_EMAIL = true;
      #LOG_FILE = "/var/log/vaultwarden.log";
      SENDMAIL_COMMAND = "${lib.getExe pkgs.system-sendmail}";
    };
  };
}
