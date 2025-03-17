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
    kdePackages.polkit-kde-agent-1
    cliphist
    wl-clipboard-rs
    hyprland
    hyprland-qtutils
  ];

  programs.niri = {
    enable = true;
    # config = /* kdl */ {
    # };
    settings = {
      clipboard.disable-primary = true;
      # hotkey-overlay.skip-at-startup = true;
      # screenshot-path = "~/%Y%m%d%H%M%S_Screenshot.png";
      binds = {
        "Mod+D".action.spawn = "fuzzel";
        "Mod+1".action.focus-workspace = 1;
        # "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        # "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        # "Mod+Shift+E".action.quit.skip-confirmation = true;
      };
      layout = {
        border = {
          enable = false;
          width = 1;
          active = { color = "#C0FFEE"; };
          inactive = { color = "#2B2B2B"; };
        };
        focus-ring = {
          enable = true;
          width = 1;
          active = { color = "rgb(127 200 255)"; };
          inactive = { color = "rgb(80 80 80)"; };
        };
        shadow = {
          enable = false;
          color = "#00000070";
          draw-behind-window = false;
          inactive-color = null;
          # offset.x = 0.0;
          # offset.y = 0.0;
          softness = 30.0;
          spread = 5.0;
        };
        insert-hint = {
          enable = true;
          display = { color = "rgb(127 200 255 / 50%)"; };
        };
      };
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
            # refresh = 165;
          };
          position = {
            x = 0;
            y = 0;
          };
          scale = 1;
          variable-refresh-rate = true;
        };
        "DP-2" = {
          enable = true;
          mode = {
            height = 1080;
            width = 1920;
            # refresh = 165;
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
      cursor = {
        theme = "Ukiyo";
        size = 24;
      };
      input = {
        focus-follows-mouse = {
          enable = true;
          # max-scroll-amount = "2";
        };
        keyboard = {
          repeat-delay = 300;
          repeat-rate = 25;
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
      };
    };
  };

}
