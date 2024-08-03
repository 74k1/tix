{ config, lib, pkgs, ... }:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    hyprctl setcursor Ukiyo 16 &
    '';
    #tempfile=$(${pkgs.coreutils}/bin/mktemp) &
    #${pkgs.curl}/bin/curl https://wall.74k1.sh/ --output $tempfile &
    #${pkgs.swww}/bin/swww init &
    #sleep 1
    #${pkgs.swww}/bin/swww img $tempfile & 
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
        "eDP-1,2560x1600@165,0x0,1"
        "DP-1,2560x1440@165,2560x0,1"
        "DP-2,2560x1440@165,0x0,1"
      ];

      decoration = {
        shadow_offset = "0 5";
        # "col.shadow" = "rgba(00000099)";
      };

      "$mod" = "SUPER";
      
      bind = [
        # term
        "$mod, Return, exec, ${pkgs.wezterm}/bin/wezterm"
        #"Control_L, alt, exec, ${pkgs.wezterm}/bin/wezterm"

        # kill # not sure yet
        "$mod, C, killactive,"

        # rofi
        "$mod, space, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "$mod, r, exec, ${pkgs.wofi}/bin/wofi --show drun"
        #"$mod, d, exec, ${pkgs.wofi}/bin/wofi --show drun"

        # apps?
        "$mod, n, exec, ${pkgs.nemo}/bin/nemo"
        "$mod, w, exec, ${pkgs.brave}/bin/brave"

        # multimedia
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl pause"
        ", XF86AudioNext, exec, ${pkgs.duvolbr}/bin/duvolbr next_track"
        ", XF86AudioPrev, exec, ${pkgs.duvolbr}/bin/duvolbr prev_track"
        
        # window focus
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        # window movement
        # "$mod, v, split vertically"
        # "$mod, h, split horizontally"
        "$mod, f, fullscreen, 0"

        # workspace focus
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 0"
      ];
      
      binds = [ # s -> seperate, for multi binds with &
        # kill hyprland
        #"$mod&Shift_L, e, exit"

        # window movement
        "$mod&Shift_L, h, movewindow, l"
        "$mod&Shift_L, j, movewindow, d"
        "$mod&Shift_L, k, movewindow, u"
        "$mod&Shift_L, l, movewindow, r"

        # window workspace movement
        "$mod&Shift_L, 1, movetoworkspace, 1"
        "$mod&Shift_L, 2, movetoworkspace, 2"
        "$mod&Shift_L, 3, movetoworkspace, 3"
        "$mod&Shift_L, 4, movetoworkspace, 4"
        "$mod&Shift_L, 5, movetoworkspace, 5"
        "$mod&Shift_L, 6, movetoworkspace, 6"
        "$mod&Shift_L, 7, movetoworkspace, 7"
        "$mod&Shift_L, 8, movetoworkspace, 8"
        "$mod&Shift_L, 9, movetoworkspace, 9"
        "$mod&Shift_L, 0, movetoworkspace, 0"
      ];

      bindr = [ # r -> release, will trigger on release of key.
        #", $mod, exec, pkill wofi || wofi"
      ];

      binde = [ # e -> repeat on hold
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindm = [ # 272 left, 273 right
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      workspace = [
        ""
      ];
    };
  };

  # home.systemPackages = [
  #   pkgs.waybar
  #   pkgs.eww
  # ];
}
