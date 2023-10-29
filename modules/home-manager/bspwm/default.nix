{ config, lib, pkgs, ...}:

{
  xsession.windowManager.bspwm = {
    enable = true;
    package = pkgs.bspwm;
    extraConfig = import ./bspwmrc;
  };
}
