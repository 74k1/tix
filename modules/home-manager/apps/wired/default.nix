# lets all love lain
{ lib, pkgs, config, ... }:
{
  services.wired = {
    enable = true;
    config = ./wired.ron;
  };
}
