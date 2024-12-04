{ inputs, outputs, config, lib, pkgs, ... }:
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
      # Key Bindings
      map = {
        normal = {
          # Close Session?
          "Super+Shift E" = "exit";

          # Wofi
          "Super Space" = "spawn ${pkgs.wofi}/bin/wofi --show drun";
          "Super R" = "spawn ${pkgs.wofi}/bin/wofi j-show drun";

          # Apps
          "Super Return" = "spawn ${inputs.ghostty.packages.x86_64-linux.default}/bin/ghostty";
          "Super N" = "spawn ${pkgs.nemo}/bin/nemo";
          "Super W" = "spawn ${inputs.zen-browser.packages."${pkgs.system}".default}/bin/zen";

          # Multimedia
          "XF86AudioPlay" = "spawn ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "spawn ${pkgs.playerctl}/bin/playerctl pause";
          "XF86AudioNext" = "spawn ${pkgs.duvolbr}/bin/duvolbr next_track";
          "XF86AudioPrev" = "spawn ${pkgs.duvolbr}/bin/duvolbr prev_track";

          # Scrot
          "Print" = "spawn ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify --cursor copy area";

          # Window Management
          "Super Q" = "close";
          "Super+Shift+Control Q" = "exit";

          "Super J" = "focus-view next";
          "Super K" = "focus-view preview";
          "Super+Shift J" = "swap next";
          "Super+Shift K" = "swap previous";

          "Super Period" = "focus-output next";
          "Super Comma" = "focus-output previous";
          "Super+Shift Period" = "send-to-output next";
          "Super+Shift Comma" = "send-to-output previous";

          "Super H" = "send-layout-cmd rivertile \"main-ratio -0.05\"";
          "Super L" = "send-layout-cmd rivertile \"main-ratio +0.05\"";
          "Super+Shift H" = "send-layout-cmd rivertile \"main-count +1\"";
          "Super+Shift L" = "send-layout-cmd rivertile \"main-ratio -1\"";
        };
      };
      # Mouse Bindings
      map-pointer = {
        normal = {
          # Window Management
          "Super BTN_LEFT" = "move-view";
          "Super BTN_RIGHT" = "resize-view";

          # Toggle Floating with Super + Middle Mouse Button
          "Super BTN_MIDDLE" = "toggle-float";
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
      spawn = [];
      # xcursor-theme = "Ukiyo 12"; 
    };
    extraConfig = ''
      riverctl keyboard-layout ch &
      rivertile -view-padding 6 -outer-padding 6 &
    '';
  };
}
