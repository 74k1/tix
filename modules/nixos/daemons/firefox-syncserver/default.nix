{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."firefox_syncserver_secrets" = {
    rekeyFile = "${inputs.self}/secrets/firefox_syncserver_secrets.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

  # firefox-syncserver
  services.firefox-syncserver = {
    enable = true;
    secrets = config.age.secrets."firefox_syncserver_secrets".path;
    singleNode = {
      enable = true;
      hostname = "localhost";
      url = "http://localhost:5000";
    };
  };
}
