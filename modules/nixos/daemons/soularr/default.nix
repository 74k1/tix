{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.tixpkgs}/modules/nixos/misc/soularr.nix"
  ];
  services.soularr = {
    enable = true;
    interval = "30m";
    settings = {
      lidarr = {
        apiKeyFile = "/tmp/lidarr-api-key";
        downloadDir = "/var/lib/lidarr/downloads";
      };
      slskd = {
        apiKeyFile = "/tmp/slskd-api-key";
        downloadDir = "/var/lib/slskd/downloads";
      };
      search = {
        allowedFiletypes = [
          "flac"
          "mp3"
          "wav"
        ];
        numberOfAlbumsToGrab = 20;
      };
    };
  };
}
