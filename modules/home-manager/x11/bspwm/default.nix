{ config, lib, pkgs, ...}:

{
  xsession.windowManager.bspwm = {
    enable = true;
    package = pkgs.bspwm;
    extraConfig = builtins.readFile ./bspwmrc;
  };
}
