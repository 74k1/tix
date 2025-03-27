{ inputs, outputs, config, lib, pkgs, ... }:
{
  # imports = [
  #   "${inputs.nixpkgs-master}/nixos/modules/services/web-servers/send.nix"
  # ];

  services.send = {
    enable = true;
    host = "0.0.0.0";
    port = 1444;
    environment = {
      "BASE_URL" = "https://send.74k1.sh/"; # TODO
      "MAX_FILE_SIZE" = "10737418240"; # 10GB
      "MAX_EXPIRE_SECONDS" = 60 * 60 * 24 * 7; # 7 days
      "DEFAULT_EXPIRE_SECONDS" = 60 * 60 * 24 * 1; # 1 day
      "DOWNLOAD_COUNTS" = "1,2,3,5,10";
      "DEFAULT_DOWNLOADS" = 1;
      "MAX_DOWNLOADS" = 10;
      "CUSTOM_DESCRIPTION" = "Encrypt and send files with a link that automatically expires.";
      "SEND_FOOTER_CLI_URL" = "";
      "SEND_FOOTER_SOURCE_URL" = "";
    };
  };
}
