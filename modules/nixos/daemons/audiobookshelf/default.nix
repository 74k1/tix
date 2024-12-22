{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 4510;
  };
}
