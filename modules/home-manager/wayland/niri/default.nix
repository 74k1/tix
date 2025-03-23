{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
# let
#   startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
#     ${pkgs.waybar}/bin/waybar &
#     hyprctl setcursor Ukiyo 16 &
#     systemctl --user start plasma-polkit-agent &
#     ${pkgs.wl-clipboard-rs}/bin/wl-copy --watch cliphist store &
#     '';
#     #tempfile=$(${pkgs.coreutils}/bin/mktemp) &
#     #${pkgs.curl}/bin/curl https://wall.74k1.sh/ --output $tempfile &
#     #${pkgs.swww}/bin/swww init &
#     #sleep 1
#     #${pkgs.swww}/bin/swww img $tempfile &
#     # ${./wallpaper.png} &
# in
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    gnome-keyring
    wofi
    cliphist
    wl-clipboard-rs
    xwayland-satellite
  ];

  programs.niri = let
    makeCommand = command: {
      command = [command];
    };
  in {
    enable = true;
    # config = /* kdl */ {
    # };
    settings = {
      environment = {
        # CLUTTER_BACKEND = "wayland";
        DISPLAY = ":0";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        # QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        # SDL_VIDEODRIVER = "wayland";
      };
      spawn-at-startup = [
        (makeCommand "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
        (makeCommand "${pkgs.waybar}/bin/waybar")
        (makeCommand "${pkgs.wl-clipboard-rs}/bin/wl-copy --watch cliphist store")
        (makeCommand "${pkgs.mako}/bin/mako")
        (makeCommand "${pkgs.xwayland-satellite}/bin/xwayland-satellite")
      ];
      clipboard.disable-primary = true;
      # hotkey-overlay.skip-at-startup = true;
      # screenshot-path = "~/%Y%m%d%H%M%S_Screenshot.png";
      binds = with config.lib.niri.actions; {
        # Multimedia
        "XF86AudioPlay".action = spawn "${pkgs.playerctl}/bin/playerctl" "play-pause";
        "XF86AudioPause".action = spawn "${pkgs.playerctl}/bin/playerctl" "pause";
        "XF86AudioNext".action = spawn "${pkgs.playerctl}/bin/playerctl" "next_track";
        "XF86AudioPrev".action = spawn "${pkgs.playerctl}/bin/playerctl" "prev_track";

        "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";

        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%-";

        "XF86MonBrightnessUp".action = spawn "${pkgs.brillo}/bin/brillo" "-q" "-u" "300000" "-A" "5";
        "XF86MonBrightnessDown".action = spawn "${pkgs.brillo}/bin/brillo" "-q" "-u" "300000" "-U" "5";

        # Bindings
        "Mod+Return" = { repeat = false; action = spawn "${pkgs.ghostty}/bin/ghostty"; };

        "Mod+R" = { repeat = false; action = spawn "${pkgs.wofi}/bin/wofi" "--show" "drun"; };
        "Mod+Space" = { repeat = false; action = spawn "${pkgs.wofi}/bin/wofi" "--show" "drun"; };

        "Mod+V" = { repeat = false; action = spawn "${pkgs.cliphist}/bin/cliphist" "list" "|" "${pkgs.wofi}/bin/wofi" "-dmenu" "|" "${pkgs.cliphist}/bin/cliphist" "decode" "|" "${pkgs.wl-clipboard-rs}/bin/wl-copy"; };

        "Print" = { repeat = false; action = spawn "${pkgs.sway-contrib.grimshot}/bin/grimshot" "--notify" "--cursor" "copy" "area"; };
        "Mod+Shift+S" = { repeat = false; action = spawn "${pkgs.sway-contrib.grimshot}/bin/grimshot" "--notify" "--cursor" "copy" "area"; };

        "Mod+E" = { repeat = false; action = spawn "${pkgs.nemo}/bin/nemo"; };
        "Mod+N" = { repeat = false; action = spawn "${pkgs.nemo}/bin/nemo"; };

        "Ctrl+Alt+L" = { repeat = false; action = spawn "sh -c pgrep hyprlock || hyprlock"; };

        "Mod+C" = { repeat = false; action = close-window; };
        "Mod+S".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        # "Mod+Shift+F".action = fullscreen-window;
        "Mod+W".action = toggle-column-tabbed-display;

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
          active = { color = "rgb(127 200 255)"; };
          inactive = { color = "rgb(80 80 80)"; };
        };
        focus-ring = {
          enable = false;
          width = 1;
          active = { color = "rgb(127 200 255)"; };
          inactive = { color = "rgb(80 80 80)"; };
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
          display = { color = "rgb(127 200 255 / 50%)"; };
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
          corner-radius = 20.0;
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
              radius = 10.0;
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
            focus-ring = {
              active.color = "#f38ba8";
              inactive.color = "#7d0d2d";
            };

            border = {
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
              {app-id = "^(zen|firefox|chromium-browser|chrome-.*|zen-.*)$";}
              {app-id = "^(xdg-desktop-portal-gtk)$";}
            ];
            # scroll-factor = 0.1;
          }
          {
            matches = [
              {app-id = "^(zen|firefox|chromium-browser|edge|chrome-.*|zen-.*)$";}
            ];
            open-maximized = true;
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
      # animations.shaders.window-resize = ''
      #   vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
      #     vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;
      #
      #     vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
      #     vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;
      #
      #     // We can crop if the current window size is smaller than the next window
      #     // size. One way to tell is by comparing to 1.0 the X and Y scaling
      #     // coefficients in the current-to-next transformation matrix.
      #     bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
      #     bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;
      #
      #     vec3 coords = coords_stretch;
      #     if (can_crop_by_x)
      #         coords.x = coords_crop.x;
      #     if (can_crop_by_y)
      #         coords.y = coords_crop.y;
      #
      #     vec4 color = texture2D(niri_tex_next, coords.st);
      #
      #     // However, when we crop, we also want to crop out anything outside the
      #     // current geometry. This is because the area of the shader is unspecified
      #     // and usually bigger than the current geometry, so if we don't fill pixels
      #     // outside with transparency, the texture will leak out.
      #     //
      #     // When stretching, this is not an issue because the area outside will
      #     // correspond to client-side decoration shadows, which are already supposed
      #     // to be outside.
      #     if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
      #         color = vec4(0.0);
      #     if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
      #         color = vec4(0.0);
      #
      #     return color;
      #   }
      # '';
      workspaces = {
        "main" = {
          open-on-output = "DP-1";
        };
        "left" = {
          open-on-output = "DP-2";
        };
      };
      outputs = {
        "DP-1" = {
          enable = true;
          mode = {
            height = 1440;
            width = 2560;
          };
          position = {
            x = 0;
            y = 0;
          };
          scale = 1;
          variable-refresh-rate = false;
        };
        "DP-2" = {
          enable = true;
          mode = {
            height = 1080;
            width = 1920;
          };
          position = {
            x = -1080;
            y = 0;
          };
          scale = 1;
          transform.rotation = 90;
          variable-refresh-rate = false;
        };
      };
      cursor =  {
        theme = "Ukiyo";
        size = 24;
      };
      input = {
        focus-follows-mouse = {
          enable = true;
          # max-scroll-amount = "2";
        };
        warp-mouse-to-focus = true;
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
        touchpad = {
          click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
          # scroll-factor = 0.2;
        };
      };
    };
  };

}
