{ lib, pkgs, ... }:
{
  services.swaync = {
    enable = true;
    # https://github.com/ErikReider/SwayNotificationCenter/blob/main/src/configSchema.json
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      layer-shell = true;
      cssPriority = "user";

      control-center-layer = "top";
      control-center-width = 400;
      control-center-height = 850;
      # control-center-margin-top = 2;
      # control-center-margin-bottom = 2;
      # control-center-margin-right = 1;
      # control-center-margin-left = 0;

      notification-2fa-action = true;
      notification-body-image-height = 160;
      notification-body-image-width = 200;
      notification-icon-size = 48;
      notification-inline-replies = false;
      notification-window-width = 400;

      timeout = 4;
      timeout-low = 2;
      timeout-critical = 6;

      fit-to-screen = false;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = false;
      script-fail-notify = true;
      scripts = {
        "example-script" = {
          exec = "echo 'Do something...'";
          urgency = "Normal";
        };
      };

      notification-visibility = {
        "example-name" = {
          state = "muted";
          urgency = "Low";
          app-name = "Spotify";
        };
      };

      widgets = [
        "title"
        "mpris"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          # button-text = " 󰎟 ";
        };
        dnd = {
          text = "Do not disturb";
        };
        mpris = {
          image-size = 64; # 96;
          image-radius = 0;
        };
      };
    };
    # https://github.com/ErikReider/SwayNotificationCenter/blob/main/src/style.css
    style = # css
      ''
        /* -----------------------------------
           🟤 Catppuccin Mocha – Crust Palette
        -------------------------------------- */
        /* @define-color background rgba(18, 17, 27, 0.9); */
        /* @define-color background-alt rgba(18, 17, 27, 0.8); */
        /* @define-color background-faded rgba(18, 17, 27, 0.5); */
        @define-color background rgb(18, 17, 27);
        @define-color background-alt rgb(18, 17, 27);
        @define-color background-faded rgb(18, 17, 27);

        @define-color crust #11111b;
        @define-color foreground #cdd6f4;
        @define-color red #f38ba8;
        @define-color green #a6e3a1;
        @define-color yellow #f9e2af;
        @define-color blue #89b4fa;
        @define-color gray #313244;
        @define-color select #585b70;

        /* 🎵 MPRIS */
        @define-color mpris-album-art-overlay rgba(0, 0, 0, 0.55);
        @define-color mpris-button-hover rgba(0, 0, 0, 0.5);
        @define-color mpris-button-bg @foreground;
        @define-color mpris-button-fg @crust;

        /* -----------------------------------
           🔤 Global Defaults
        -------------------------------------- */
        * {
          outline: none;
          font-family: "JetBrainsMono Nerd Font Propo";
          font-size: 18px;
          text-shadow: none;
          color: @foreground;
          background-color: transparent;
          border-radius: 2px;
        }

        /* -----------------------------------
           🧩 Control Center
        -------------------------------------- */
        .control-center {
          background-color: alpha(@background, 1);
          /* box-shadow: 0 0 10px rgba(0, 0, 0, 0.65); */
          box-shadow: none;
          padding: 2px;
          border-bottom: 9px solid @blue;
        }

        .notification-row .notification-background {
          border-radius: 2px;
          margin: 5px 0 15px;
        }

        /* -----------------------------------
           🔔 Notifications
        -------------------------------------- */
        .notification {
          background-color: @background;
          border: 1px solid alpha(@foreground, 0.05);
          border-radius: 2px;
          padding: 6px 10px;
          margin-bottom: 6px;
          min-height: 50px;
          box-shadow: none;
        }

        .notification .summary {
          font-size: 1rem;
          font-weight: 500;
          margin-bottom: 2px;
        }

        .notification .time {
          font-size: 0.75rem;
          color: alpha(@foreground, 0.6);
        }

        .notification .body {
          font-size: 0.95rem;
          color: @foreground;
        }

        .notification-action>button {
          padding: 5px 10px;
          font-size: 0.9rem;
          background-color: @select;
          color: @foreground;
          border-radius: 2px;
          border: none;
          margin: 6px 6px 0 0;
        }

        .notification-action>button:hover {
          background-color: @blue;
        }

        .notification-action>button:hover label {
          background-color: @blue;
          color: @crust;
        }

        /* Urgency */
        .notification.critical {
          background: @red;
          border-left: 9px solid red;
        }

        .notification.critical .title,
        .notification.critical .body,
        .notification.critical .summary {
          color: alpha(@crust, 0.9);
          font-weight: bold;
        }

        .notification.low,
        .notification.normal {
          background-color: alpha(@background, 0.95);
          border-left: 9px solid @blue;
        }

        /* -----------------------------------
           🖼️ Image/Icon
        -------------------------------------- */
        .image {
          margin-right: 10px;
          min-width: 36px;
          min-height: 36px;
          border: none;
        }

        /* -----------------------------------
           ❌ Close Buttons
        -------------------------------------- */
        .close-button {
          background-color: alpha(@gray, 0.8);
          border-radius: 8px;
        }

        .close-button label {
          color: aliceblue;
        }

        .close-button:hover {
          background-color: alpha(@red, 0.8);
        }

        /* -----------------------------------
           🔃 Group Header Buttons
        -------------------------------------- */
        .notification-group-collapse-button,
        .notification-group-close-all-button {
          background-color: @gray;
          color: @foreground;
          border-radius: 6px;
        }

        .notification-group-collapse-button:hover {
          background-color: @blue;
          color: @crust;
        }

        .notification-group-close-all-button:hover {
          background-color: @red;
          color: @crust;
        }

        /* -----------------------------------
           📊 Sliders (Volume/Brightness)
        -------------------------------------- */
        scale trough {
          margin: 0 1rem;
          background-color: @gray;
          min-height: 8px;
          min-width: 70px;

          border-radius: 30px;
        }

        trough highlight {
          background: @blue;

          border-radius: 30px;
        }

        slider {
          border-radius: 30px;
          background-color: @foreground;
        }

        /* -----------------------------------
           💬 Tooltip
        -------------------------------------- */
        tooltip {
          background-color: @gray;
          color: @foreground;
        }

        /* -----------------------------------
           🔘 Buttons Grid
        -------------------------------------- */
        .widget-buttons-grid {
          font-size: 1rem;
          padding: 20px 20px 10px;
        }

        .widget-buttons-grid button {
          background: @crust;
          color: #fff;
          border-radius: 50px;
          min-width: 60px;
          min-height: 30px;
          margin: 0 3px;
          padding: 6px;
        }

        .widget-buttons-grid button:hover {
          background: @select;
        }

        .widget-buttons-grid button.toggle:checked {
          background: @blue;
        }

        .widget-buttons-grid button.toggle:checked label {
          background: @blue;
          color: @background;
        }


        .widget-buttons-grid button.toggle:checked:hover {
          background: alpha(@blue, 0.8);
        }

        /* -----------------------------------
           🎵 MPRIS Player
        -------------------------------------- */
        .widget-mpris .widget-mpris-player {
          padding: 6px;
          margin: 6px 10px;
          background-color: transparent;
          box-shadow: none;
          border-radius: 2px;
        }

        .widget-mpris label,
        .widget-mpris-title,
        .widget-mpris-subtitle {
          color: @foreground;
        }

        .widget-mpris-title {
          font-size: 1.2rem;
          font-weight: bold;
          margin: 0 8px 8px;
          text-align: center;
        }

        .widget-mpris-subtitle {
          font-size: 1rem;
          text-align: center;
        }

        .widget-mpris-album-art.art {
          border-radius: 999px;
          min-width: 128px;
          min-height: 128px;
          background-size: cover;
          background-repeat: no-repeat;
          overflow: hidden;
          box-shadow: none;
          background: red;
        }

        picture.mpris-background {
          opacity: 0;
          background: none;
          box-shadow: none;
          border: none;
        }


        /* -----------------------------------
           🔊 Volume Widget
        -------------------------------------- */
        .widget-volume {
          padding: 6px 5px 5px;
          font-size: 1.3rem;
        }

        .widget-volume button {
          border: none;
        }

        /* -----------------------------------
           🎚️ Per-App Volume
        -------------------------------------- */
        .per-app-volume {
          padding: 4px 8px 8px;
          margin: 0 8px 8px;
        }

        /* -----------------------------------
           💡 Backlight
        -------------------------------------- */
        .widget-backlight {
          padding: 0 0 3px 16px;
          font-size: 1.1rem;
        }

        /* -----------------------------------
           🔕 DND
        -------------------------------------- */
        .widget-dnd {
          font-weight: bold;
          padding: 20px 15px 15px;
        }

        .widget-dnd>switch {
          background: @yellow;
          border: none;
          border-radius: 100px;
          padding: 3px;
        }

        .widget-dnd>switch:checked {
          background: @green;
        }

        .widget-dnd>switch slider {
          background: @background;
          border-radius: 12px;
          min-width: 18px;
          min-height: 18px;
        }

        /* -----------------------------------
           🏷️ Title
        -------------------------------------- */
        .widget-title {
          padding: 15px;
          font-weight: bold;
        }

        .widget-title>label {
          font-size: 1.5rem;
        }

        .widget-title>button {
          background: @red;
          border: none;
          border-radius: 100px;
          padding: 0 6px;
          transition: all 0.7s ease;
        }

        .widget-title>button label {
          color: @crust;
        }

        .widget-title>button:hover {
          background: alpha(@red, 0.8);
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.65);
        }
      '';
  };
}
