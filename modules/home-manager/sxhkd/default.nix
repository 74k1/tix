{ config, lib, pkgs, ... }:

let
  cfg = services.sxhkd;
in
{
  cfg = {
    enable = true;
    package = pkgs.sxhkd;

    # extraConfig = import ./sxhkdrc;
    keybindings = {
      # open terminal
      "super + Return" = "bspc rule -a wezterm -o state=floating rectangle=1600x900x0x0 center=true && ${wezterm}/bin/wezterm";
      # program launcher
      "super + @space" = "${rofi}/bin/rofi -config -no-lazy-grab -show drun -modi drun";

      # close window
      "alt + F4" = "bspc node --close";
    };
  };
}
