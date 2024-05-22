{ config, lib, pkgs, ... }:
{
  services.stalwart-mail = {
    enable = true;
    package = pkgs.stalwart-mail;
    # settings = {
    #   xyz.
    # };
  };
}
