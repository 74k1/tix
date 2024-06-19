{ config, lib, pkgs, ... }:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    hyprctl setcursor Ukiyo 16 &
    tempfile=$(${pkgs.coreutils}/bin/mktemp) &
    ${pkgs.curl}/bin/curl https://wall.74k1.sh/ --output $tempfile&
    ${pkgs.swww}/bin/swww init &
    sleep 1
    ${pkgs.swww}/bin/swww img $tempfile & 
    '';
    # ${./wallpaper.png} &
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = ''${startupScript}/bin/start'';

      # keyboard layout
      "input" = {
        kb_layout = "ch";
      };

      # monitor
      monitor = [
        "DP-1,2560x1440@165,2560x0,1"
        "DP-2,2560x1440@165,0x0,1"
      ];

      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };

      "$mod" = "SUPER";
      
      bind = [
        # kill
        "$mod, C, killactive,"

        # term
        "$mod, Return, exec, ${pkgs.wezterm}/bin/wezterm"
        "Control_L, alt, exec, ${pkgs.wezterm}/bin/wezterm"
        
        # rofi
        "$mod, space, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "$mod, r, exec, ${pkgs.wofi}/bin/wofi --show drun"

        # apps?
        "$mod, n, exec, ${pkgs.cinnamon.nemo}/bin/nemo"
        "$mod, w, exec, brave"

        # multimedia
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl pause"
        ", XF86AudioNext, exec, ${pkgs.duvolbr}/bin/duvolbr next_track"
        ", XF86AudioPrev, exec, ${pkgs.duvolbr}/bin/duvolbr prev_track"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
    };
  };

  # home.systemPackages = [
  #   pkgs.waybar
  #   pkgs.eww
  # ];
}
