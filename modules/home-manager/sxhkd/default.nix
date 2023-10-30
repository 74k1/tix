{ config, lib, pkgs, ... }:

{
  services.sxhkd = {
    enable = true;
    package = pkgs.sxhkd;

    # extraConfig = builtins.readFile ./sxhkdrc;
    keybindings = {
      # open terminal
      "super + Return" = "bspc rule -a wezterm -o state=floating rectangle=1600x900x0x0 center=true && ${pkgs.wezterm}/bin/wezterm";
      # program launcher
      "super + space" = "${pkgs.rofi}/bin/rofi -config -no-lazy-grab -show drun -modi drun";

      # scrot
      "Print" = "exec --no-startup-id \"sh -e -c '${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -l -c 0.3,0.4,0.6,0.4 -f \\\\\"-i %i -g %g\\\\\") - | ${pkgs.xclip}/bin/xclip -selection clipboard -t \\\\\"image/png\\\\\"'\"";

      # close window
      "alt + F4" = "bspc node --close";
    };
  };
}
