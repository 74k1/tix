{ config, lib, pkgs, ... }:

{
  services.sxhkd = {
    enable = true;
    package = pkgs.sxhkd;

    # extraConfig = import ./sxhkdrc;
    keybindings = {
      # open terminal
      "super + Return" = "bspc rule -a wezterm -o state=floating rectangle=1600x900x0x0 center=true && ${pkgs.wezterm}/bin/wezterm";
      # program launcher
      "super + @space" = "${pkgs.rofi}/bin/rofi -config -no-lazy-grab -show drun -modi drun";

      # close window
      "alt + F4" = "bspc node --close";
    };
  };
}
