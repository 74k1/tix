{ config, lib, pkgs, ... }:
{
  wayland.windowManager.river = {
    enable = true;
    package = pkgs.river;
    xwayland.enable = true;
    extraSessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
    systemd = {
      enable = true;
      variables = [
        "-all"
      ];
      extraCommands = [
        "systemctl --user stop river-session.target"
        "systemctl --user start river-session.target"
      ];
    };
    settings = {
      border-width = 2;
      declare-mode = [
        "locked"
        "normal"
        "passthrough"
      ];
      input = {
        pointer-foo-bar = {
          accel-profile = "flat";
          events = true;
          pointer-accel = -0.3;
          tap = false;
        };
      };
      map = {
        normal = {
          "Alt Q" = "close";
        };
      };
      rule-add = {
        "-app-id" = {
          "'bar'" = "csd";
          "'float*'" = {
            "-title" = {
              "'foo'" = "float";
            };
          };
        };
      };
      set-cursor-warp = "on-output-change";
      set-repeat = "50 300";
      spawn = [
        "brave"
        "wezterm"
      ];
      xcursor-theme = "Ukiyo 12"; 
    };
    extraConfig = ''
      rivertile -view-padding 6 -outer-padding 6 &
      riverctl map normal Super Return spawn wezterm &
      riverctl map normal Super+Shift E exit &
    '';
  };
}
