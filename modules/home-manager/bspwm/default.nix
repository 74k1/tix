{ config, lib, pkgs, ...}:

let
  cfg = config.xsession.windowManager.bspwm;
in
{
  cfg = {
    enable = true;
    package = pkgs.bspwm;
    extraConfig = import ./bspwmrc;
  };
}
