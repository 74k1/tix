{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."vaultwarden_secret" = {
    rekeyFile = "${inputs.self}/secrets/vaultwarden_secret.age";
    # mode = "770";
    # owner = "";
    # group = "";
  };
  services.vaultwarden = {
    enable = true;
    package = pkgs.master.vaultwarden;
    # environmentFile = "/home/taki/vaultwarden_env_secrets";
    environmentFile = config.age.secrets."vaultwarden_secret".path;
    dbBackend = "sqlite";
    # backupDir = "/vaultwarden";
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = "8222";
      DOMAIN = "https://vw.example.com/"; # TODO
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
