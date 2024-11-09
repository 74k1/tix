{ inputs, outputs, config, lib, pkgs, ... }:
{
  services.youtrack = {
    enable = true;
    address = "0.0.0.0";
    package = pkgs.youtrack;
    environmentalParameters = {
      # secure-mode = "tls";
      listen-port = 8888;
    };
  };
}
