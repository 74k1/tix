{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: let
  wallpaper_image = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/0/07/Johan_Christian_Dahl_-_View_of_Dresden_by_Moonlight_-_Google_Art_Project.jpg";
    name = "wallpaper.jpg";
    hash = "sha256-MjBzldNqNQa1aPoxUPyimovl+YSA4m74Dx7MIsswxtU=";
  };
in {
  # BIG REMINDER
  # ADD XDG STUFF

  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    nautilus
    gnome-keyring
    wofi
    # cliphist
    wl-clipboard-rs
    xwayland-satellite
  ];

  services.swww = {
    enable = true;
    package = pkgs.swww;
  };

  programs.niri = let
    makeCommand = command: {
      command = [command];
    };
  in {
    enable = true;
    package = pkgs.niri;
    # config = /* kdl */ {
    # };
    settings = {
      environment = {
        # CLUTTER_BACKEND = "wayland";
        DISPLAY = ":0";
        GDK_BACKEND = "wayland";
        GTK_USE_PORTAL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        # QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        # SDL_VIDEODRIVER = "wayland";
      };
      spawn-at-startup = [
        (makeCommand "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
        # (makeCommand "${pkgs.wl-clipboard-rs}/bin/wl-copy --watch cliphist store")
        (makeCommand "${lib.getExe pkgs.swww} img ${wallpaper_image}")
        (makeCommand "${lib.getExe pkgs.swaynotificationcenter}")
        (makeCommand "${pkgs.xwayland-satellite}/bin/xwayland-satellite")
      ];
      clipboard.disable-primary = true;
      hotkey-overlay.skip-at-startup = false;
      screenshot-path = "~/%Y%m%d%H%M%S_Screenshot.png";
      binds = with config.lib.niri.actions; {
        # Multimedia
        "XF86AudioPlay".action = spawn "${pkgs.playerctl}/bin/playerctl" "play-pause";
        "XF86AudioPause".action = spawn "${pkgs.playerctl}/bin/playerctl" "play-pause";
        "XF86AudioNext".action = spawn "${pkgs.tix.duvolbr}/bin/duvolbr" "next_track";
        "XF86AudioPrev".action = spawn "${pkgs.tix.duvolbr}/bin/duvolbr" "prev_track";

        "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";

        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%-";

        "XF86MonBrightnessUp".action = spawn "${pkgs.brillo}/bin/brillo" "-q" "-u" "300000" "-A" "5";
        "XF86MonBrightnessDown".action = spawn "${pkgs.brillo}/bin/brillo" "-q" "-u" "300000" "-U" "5";

        # Bindings
        "Mod+Return" = { repeat = false; action = spawn "${pkgs.ghostty}/bin/ghostty"; };

        "Mod+R" = { repeat = false; action = spawn "${lib.getExe pkgs.anyrun}"; };
        "Mod+Space" = { repeat = false; action = spawn "${lib.getExe pkgs.anyrun}"; };
        # "Mod+V" = { repeat = false; action = spawn "${lib.getExe pkgs.anyrun}"; };

        # "Mod+R" = { repeat = false; action = spawn "${pkgs.wofi}/bin/wofi" "--show" "drun"; };
        # "Mod+Space" = { repeat = false; action = spawn "${pkgs.wofi}/bin/wofi" "--show" "drun"; };
        #
        "Mod+V" = { repeat = false; action = spawn "sh" "-c" "${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard-rs}/bin/wl-copy"; };

        "Print" = { repeat = false; action = screenshot; };
        "Mod+Shift+S" = { repeat = false; action = screenshot; };

        "Mod+E" = { repeat = false; action = spawn "${pkgs.nautilus}/bin/nautilus"; };
        "Mod+N" = { repeat = false; action = spawn "${pkgs.nautilus}/bin/nautilus"; };

        "Ctrl+Alt+L" = { repeat = false; action = spawn "sh" "-c" "pgrep hyprlock || ${pkgs.hyprlock}/bin/hyprlock"; };
        "Mod+Ctrl+Q" = { repeat = false; action = spawn "sh" "-c" "pgrep hyprlock || ${pkgs.hyprlock}/bin/hyprlock"; };

        "Mod+C" = { repeat = false; action = close-window; };
        "Mod+S".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+W".action = toggle-column-tabbed-display;

        # "Mod+Minus".action = set-column-width "-10%";
        # "Mod+Equal".action = set-column-width "+10%";

        # "Mod+Shift+Minus".action = set-column-height "-10%";
        # "Mod+Shift+Equal".action = set-column-height "+10%";

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+Tab".action = switch-focus-between-floating-and-tiling;

        # workspace
        "Mod+H".action = focus-column-or-monitor-left;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+L".action = focus-column-or-monitor-right;

        "Mod+Left".action = focus-column-or-monitor-left;
        "Mod+Down".action = focus-window-or-workspace-down;
        "Mod+Up".action = focus-window-or-workspace-up;
        "Mod+Right".action = focus-column-or-monitor-right;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-column-to-workspace-down;
        "Mod+Shift+K".action = move-column-to-workspace-up;
        "Mod+Shift+L".action = move-column-right;

        "Mod+Shift+Left".action = move-column-left-or-to-monitor-left;
        "Mod+Shift+Down".action = move-column-to-workspace-down;
        "Mod+Shift+Up".action = move-column-to-workspace-up;
        "Mod+Shift+Right".action = move-column-right-or-to-monitor-right;

        "Mod+WheelScrollLeft".action = focus-column-left;
        "Mod+WheelScrollDown".action = focus-workspace-down;
        "Mod+WheelScrollUp".action = focus-workspace-up;
        "Mod+WheelScrollRight".action = focus-column-right;
        
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+0".action.focus-workspace = 10;

        "Mod+Shift+1".action.move-window-to-workspace = "1";
        "Mod+Shift+2".action.move-window-to-workspace = "2";
        "Mod+Shift+3".action.move-window-to-workspace = "3";
        "Mod+Shift+4".action.move-window-to-workspace = "4";
        "Mod+Shift+5".action.move-window-to-workspace = "5";
        "Mod+Shift+6".action.move-window-to-workspace = "6";
        "Mod+Shift+7".action.move-window-to-workspace = "7";
        "Mod+Shift+8".action.move-window-to-workspace = "8";
        "Mod+Shift+9".action.move-window-to-workspace = "9";
        "Mod+Shift+0".action.move-window-to-workspace = "10";
      };
      layout = {
        border = {
          enable = true;
          width = 1;
          active = { color = "#6C69FF"; };
          inactive = { color = "#5F5A65"; };
        };
        focus-ring = {
          enable = false;
          width = 1;
          active = { color = "#6C69FF"; };
          inactive = { color = "#5F5A65"; };
        };
        shadow = {
          enable = true;
          # color = "#00000070";
          # draw-behind-window = false;
          # inactive-color = null;
          # # offset.x = 0.0;
          # # offset.y = 0.0;
          # softness = 30.0;
          # spread = 5.0;
        };
        insert-hint = {
          enable = false;
          display = { color = "rgb(87 103 255 / 50%)"; };
        };
        preset-column-widths = [
          {proportion = 0.25;}
          {proportion = 0.5;}
          {proportion = 0.75;}
          {proportion = 1.0;}
        ];
        default-column-width.proportion = 0.5;

        gaps = 8;
        struts = {
          left = 2;
          right = 2;
          top = 2;
          bottom = 2;
        };

        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
          position = "left";
          corner-radius = 0.0;
          gap = -9.0;
          gaps-between-tabs = 10.0;
          width = 4.0;
          length.total-proportion = 0.1;
        };
      };
      prefer-no-csd = true;
      window-rules = let 
        mkMatchRule = {
          appId,
          title ? "",
          openFloating ? false,
        }: let
          baseRule = {
            matches = [
              {
                app-id = appId;
                inherit title;
              }
            ];
          };
          floatingRule =
            if openFloating
            then {open-floating = true;}
            else {};
        in
          baseRule // floatingRule;

        openFloatingAppIds = [
          "^(pavucontrol)"
          "^(Volume Control)"
          "^(dialog)"
          "^(file_progress)"
          "^(confirm)"
          "^(download)"
          "^(error)"
          "^(notification)"
        ];

        floatingRules = builtins.map (appId:
          mkMatchRule {
            appId = appId;
            openFloating = true;
          })
        openFloatingAppIds;

        windowRules = [
          {
            geometry-corner-radius = let
              radius = 0.0;
            in {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
            clip-to-geometry = true;
            draw-border-with-background = false;
          }
          {
            matches = [
              {is-floating = true;}
            ];
            shadow.enable = true;
          }
          {
            matches = [
              {
                is-window-cast-target = true;
              }
            ];

            border = {
              active.color = "#f38ba8";
              inactive.color = "#7d0d2d";
            };

            shadow = {
              color = "#7d0d2d70";
            };

            tab-indicator = {
              active.color = "#f38ba8";
              inactive.color = "#7d0d2d";
            };
          }
          {
            matches = [{app-id = "org.telegram.desktop";}];
            block-out-from = "screencast";
          }
          {
            matches = [{app-id = "app.drey.PaperPlane";}];
            block-out-from = "screencast";
          }
          {
            matches = [
              {app-id = "^(zen|zen-.*|firefox|chromium-browser|edge|chrome-.*)$";}
              {app-id = "^discord$";}
            ];
            open-maximized = true;
          }
          {
            matches = [
              {title = "^wired$";}
            ];
            open-floating = true;
            open-focused = false;
            default-floating-position = {
              relative-to = "top-right";
              x = 320;
              y = 16;
            };
          }
          {
            matches = [
              {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              }
              {
                app-id = "zen-.*$";
                title = "^Picture-in-Picture$";
              }
              {
                app-id = "zen-.*$";
                title = ".*Bitwarden Password Manager.*";
              }
              {title = "^Picture in picture$";}
              {title = "^Discord Popout$";}
            ];
            open-floating = true;
            default-floating-position = {
              x = 32;
              y = 32;
              relative-to = "top-right";
            };
          }
        ];
      in windowRules ++ floatingRules;
      # workspaces = {
      #   "01" = { open-on-output = "DP-1"; name = "一"; };
      #   "02" = { open-on-output = "DP-1"; name = "二"; };
      #   "03" = { open-on-output = "DP-1"; name = "三"; };
      #   "04" = { open-on-output = "DP-1"; name = "四"; };
      #   "05" = { open-on-output = "DP-1"; name = "五"; };
      #   "06" = { open-on-output = "DP-2"; name = "六"; };
      #   "07" = { open-on-output = "DP-2"; name = "七"; };
      #   "08" = { open-on-output = "DP-2"; name = "八"; };
      #   "09" = { open-on-output = "DP-2"; name = "九"; };
      #   "10" = { open-on-output = "DP-2"; name = "十"; };
      # };
      # outputs = {
      #   # Internal Monitor
      #   "eDP-1" = {
      #     enable = true;
      #     mode = {
      #       height = 2560;
      #       width = 1600;
      #       # refresh = 144.0;
      #     };
      #     position = {
      #       x = 0;
      #       y = 0;
      #     };
      #     scale = 1.75;
      #     transform.rotation = 270;
      #     variable-refresh-rate = false;
      #     focus-at-startup = false;
      #   };
      #   "DP-6" = {
      #     enable = true;
      #     mode = {
      #       height = 2560;
      #       width = 1440;
      #     };
      #     position = {
      #       x = 0;
      #       y = 0;
      #     };
      #     scale = 1;
      #     variable-refresh-rate = false;
      #     focus-at-startup = true;
      #   };
      #   "DP-7" = {
      #     enable = true;
      #     mode = {
      #       height = 1080;
      #       width = 1920;
      #     };
      #     position = {
      #       x = -1080;
      #       y = 0;
      #     };
      #     scale = 1;
      #     transform.rotation = 90;
      #     variable-refresh-rate = false;
      #   };
      # };
      cursor =  {
        theme = "Ukiyo";
        size = 24;
      };
      input = {
        focus-follows-mouse = {
          enable = true;
          # max-scroll-amount = "2";
        };
        warp-mouse-to-focus.enable = true;
        keyboard = {
          repeat-delay = 200;
          repeat-rate = 50;
          track-layout = "global";
          xkb = {
            layout = "ch";
          };
        };
        mouse = {
          enable = true;
          accel-profile = null;
          # scroll-button = "BTN_MIDDLE";
          # scroll-factor = 1.0;
          # scroll-method = "on-button-down";
        };
        touch = {
          enable = true;
        };
        touchpad = {
          enable = true;
          # click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = false;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          # accel-profile = "adaptive";
          accel-profile = "flat";
          # scroll-factor = 0.2;
        };
      };
    };
  };

}
