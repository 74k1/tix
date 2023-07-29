{ lib, pkgs, config, ... }:

let
  mod = "Mod4";
  alt = "Mod1";
  fm = "DP-0";
  sm = "DP-2";
in {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      modifier = mod;

      # fonts = [""]
      bars = [ ];

      window.border = 1;

      gaps = {
        inner = 15;
        outer = 5;
      };

      keybindings = lib.mkOptionDefault {
        # Term
        "Ctrl+${alt}+t" = "exec ${pkgs.wezterm}/bin/wezterm";
        "${mod}+Return" = "exec ${pkgs.wezterm}/bin/wezterm";
        # Scrot
        "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png'";
        "Print" = "exec sh -c '${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png'";
        # Mac-like Keybind :^)
        "${alt}+Shift+s" = "exec sh -c '${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png'";

        # Rofi
        "${mod}+space" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${mod}+r" = "exec ${pkgs.rofi}/bin/rofi -show drun";

        #pactl & playerctl
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";
        #"XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 5";
        #"XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 5";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        #"XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

        # Focus
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+h" = "focus left";
        "${mod}+l" = "focus right";

        # Move
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+l" = "move right";

        # Multi Monitor Setup
        #"${mod}+m" = "move workspace to output DP-X"
        #"${mod}+Shift+m" = "move workspace to output DP-X"

        # workspace binds
        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+6" = "workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace 9";
        "${mod}+0" = "workspace 10";
        "${mod}+${alt}+1" = "workspace 11";
        "${mod}+${alt}+2" = "workspace 12";
        "${mod}+${alt}+3" = "workspace 13";
        "${mod}+${alt}+4" = "workspace 14";
        "${mod}+${alt}+5" = "workspace 15";
        "${mod}+${alt}+6" = "workspace 16";
        "${mod}+${alt}+7" = "workspace 17";
        "${mod}+${alt}+8" = "workspace 18";
        "${mod}+${alt}+9" = "workspace 19";
        "${mod}+${alt}+0" = "workspace 20";

        # move to second screen / 10s / alt + shift + num
        "${mod}+${alt}+Shfit+1" = "move container to workspace 11";
        "${mod}+${alt}+Shift+2" = "move container to workspace 12";
        "${mod}+${alt}+Shift+3" = "move container to workspace 13";
        "${mod}+${alt}+Shift+4" = "move container to workspace 14";
        "${mod}+${alt}+Shift+5" = "move container to workspace 15";
        "${mod}+${alt}+Shift+6" = "move container to workspace 16";
        "${mod}+${alt}+Shift+7" = "move container to workspace 17";
        "${mod}+${alt}+Shift+8" = "move container to workspace 18";
        "${mod}+${alt}+Shift+9" = "move container to workspace 19";
        "${mod}+${alt}+Shift+0" = "move container to workspace 20";
        
        # i3 reload shenanigans
        #"${mod}+Shift+c" = ""
      };
    };
    extraConfig = ''
      workspace 1 output ${fm}
      workspace 2 output ${fm}
      workspace 3 output ${fm}
      workspace 4 output ${fm}
      workspace 5 output ${fm}
      workspace 6 output ${fm}
      workspace 7 output ${fm}
      workspace 8 output ${fm}
      workspace 9 output ${fm}
      workspace 10 output ${fm}
      workspace 11 output ${sm}
      workspace 12 output ${sm}
      workspace 13 output ${sm}
      workspace 14 output ${sm}
      workspace 15 output ${sm}
      workspace 16 output ${sm}
      workspace 17 output ${sm}
      workspace 18 output ${sm}
      workspace 19 output ${sm}
      workspace 20 output ${sm}
              
      for_window [window_type="dialog"] floating enable
      for_window [window_type="utility"] floating enable
      for_window [window_type="toolbar"] floating enable
      for_window [window_type="splash"] floating enable
      for_window [window_type="menu"] floating enable
      for_window [window_type="dropdown_menu"] floating enable
      for_window [window_type="popup_menu"] floating enable
      for_window [window_type="tooltip"] floating enable
      for_window [window_type="notification"] floating enable
    '';
  };
}
