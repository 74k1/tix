{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  modules = {
    "group/power" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 0;
        transition-left-to-right = true;
        click-to-reveal = true;
      };
      modules = [
        "custom/power-icon"
        "custom/power-lock"
        "custom/power-logout"
        "custom/power-off"
        "custom/power-reboot"
      ];
    };

    "custom/power-icon" = {
      # format = "[ ☯ ]";
      # format = "[  ]";
      # format = "[  ]";
      # format = "🀄";
      # format = "[  ]";
      # format = " ⏻ ";
      # format = " λ ";
      # format = "⊹";
      # format = " ⛶ ";
      format = "ℵ";
    };

    "custom/power-lock" = {
      format = "";
      tooltip = false;
      on-click = "${lib.getExe pkgs.hyprlock}";
    };

    "custom/power-logout" = {
      format = "";
      tooltip = false;
      on-click = "niri msg action quit -s";
    };

    "custom/power-off" = {
      format = "";
      tooltip = false;
      on-click = "systemctl poweroff";
    };

    "custom/power-reboot" = {
      format = "";
      tooltip = false;
      on-click = "systemctl reboot";
    };

    "clock" = {
      # "timezone" = "Europe/Zurich";
      format = "[ {:%d, %H:%M} ]";
      format-alt = "[ {:%Y-%m-%d, %H:%M:%S} ]";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

    "cpu" = {
      format = "CPU {usage}% {icon}";
      tooltip = false;
      format-icons = [
        "[        ]"
        "[|       ]"
        "[||      ]"
        "[|||     ]"
        "[||||    ]"
        "[|||||   ]"
        "[||||||  ]"
        "[||||||| ]"
        "[||||||||]"
      ];
    };

    "custom/mem" = {
      exec = lib.getExe (pkgs.writeScriptBin "wb-mem" (builtins.readFile ./scripts/wb-mem.sh));
      return-type = "json";
      tooltip = false;
      format = "MEM {percentage}% {icon}";
      format-icons = [
        "[        ]"
        "[|       ]"
        "[||      ]"
        "[|||     ]"
        "[||||    ]"
        "[|||||   ]"
        "[||||||  ]"
        "[||||||| ]"
        "[||||||||]"
      ];
    };

    "group/interactibles" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 0;
        # childern-class = "tray-child";
        transition-left-to-right = false;
        click-to-reveal = true;
      };
      modules = [
        "custom/tray-btn"
        "tray"
      ];
    };

    "custom/tray-btn" = {
      # format = " ⏺ ";
      # format = "⛶";
      # format = "⯎";
      # format = "✱";
      format = "";
      tooltip = false;
    };

    "tray" = {
      icon-size = 16;
      spacing = 16;
    };

    "custom/net" = {
      exec = lib.getExe (pkgs.writeScriptBin "wb-net" (builtins.readFile ./scripts/wb-net.sh));
      return-type = "json";
      format = "{icon}";
      format-icons = {
        lan = "";
        wifi = "";
        none = "";
      };
    };

    "wireplumber" = {
      format = "VOL {volume}% {icon}";
      format-icons = [
        "[        ]"
        "[|       ]"
        "[||      ]"
        "[|||     ]"
        "[||||    ]"
        "[|||||   ]"
        "[||||||  ]"
        "[||||||| ]"
        "[||||||||]"
      ];
      on-click = "pavucontrol";
      on-click-right = lib.getExe (
          pkgs.writeShellApplication {
          name = "wb-select-output";
          runtimeInputs = [
            pkgs.fuzzel
            pkgs.pulseaudio
          ];
          text = builtins.readFile ./scripts/wb-select-output.sh;
        }
      );
      on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      scroll-step = 5.0;
    };

    "custom/swaync" = {
      exec = lib.getExe (
        pkgs.writeShellApplication {
          name = "wb-swaync-count";
          runtimeInputs = [
            pkgs.swaynotificationcenter
          ];
          text = /* sh */ ''
            #!/usr/bin/env bash

            while :; do
              # number of unread notifications
              unread=''$(swaync-client -c)

              # dnd on? (swaync-client -D returns "true" or "false")
              if [[ ''$(swaync-client -D) == "true" ]]; then
                alt="dnd"
              else
                if (( unread == 0 )); then
                  alt="none"
                else
                  alt="some"
                fi
              fi

              # build tooltip
              if (( unread == 0 )); then
                tooltip="no notifications"
              elif (( unread == 1 )); then
                tooltip="1 notification"
              else
                tooltip="''${unread} notifications"
              fi

              printf '{"alt": "%s", "tooltip": "%s"}\n' "''$alt" "''$tooltip"

              sleep 0.5
            done
          '';
        }
      );
      return-type = "json";
      format = "{icon}";
      on-click = "swaync-client -t";
      format-icons = {
        dnd = "";
        some = "";
        none = "";
      };
    };

    "battery" = {
      states = {
        good = 88;
        warning = 30;
        critical = 15;
      };
      format = "BAT {capacity}% {icon}";
      format-charging = "BAT  {capacity}% {icon}";
      # format = "{capacity}% {icon}";
      # format-charging = "{capacity}% {icon}";
      full-at = 89;
      tooltip-format = "{power}w {timeTo}";
      format-time = "{H}h {M}m left";
      format-icons = [
        # ""
        # ""
        # ""
        # ""
        # ""
        # ""
        # ""
        # ""
        "[        ]"
        "[|       ]"
        "[||      ]"
        "[|||     ]"
        "[||||    ]"
        "[|||||   ]"
        "[||||||  ]"
        "[||||||| ]"
        "[||||||||]"
      ];
    };
  };
in {
  home.packages = [
    pkgs.material-symbols
    pkgs.material-icons
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      smallBar = {
        height = 32;
        spacing = 8;
        position = "top";
        layer = "top";
        margin-left = 8;
        margin-right = 8;
        margin-top = 8;

        output = [
          "DP-7"
        ];

        modules-left = [
          "group/power"
        ];

        modules-center = [
          "clock"
        ];
        
        modules-right = [
          "battery"
        ];
      } // modules;

      mainBar = {
        height = 32;
        spacing = 8;
        position = "top";
        layer = "top";
        margin-left = 8;
        margin-right = 8;
        margin-top = 8;

        output = [
          "DP-6"
          "eDP-1"
        ];

        modules-left = [
          "group/power"
          "cpu"
          "custom/mem"
        ];

        modules-center = [
          "clock"
        ];
        
        modules-right = [
          "group/interactibles"
          "custom/net"
          "custom/swaync"
          "wireplumber"
          "battery"
        ];

      } // modules;
    };
    style = lib.mkForce /* css */ ''
      /* @define-color fg0 #EBE9F1; */
      @define-color fg0 #938FA8;
      @define-color bg0 #07060B;
      /* @define-color bg1 #1C1B28; */
      @define-color bg1 #07060B;
      @define-color bg2 #323246;
      @define-color bg3 #4C4B69;
      @define-color accent #816BFF;
      @define-color cyan #4CCEFE;
      @define-color green #50E074;
      @define-color red #FF5487;
      @define-color yellow #FFE375;

      * {
        border: none;
        border-radius: 0px;
        font-family: "PP Supply Mono", "JetBrainsMono NF Regular", "JetBrains Mono";
        font-size: 16px;
        min-height: 32px;
      }

      #custom-power-icon,
      #custom-power-lock,
      #custom-power-logout,
      #custom-power-off,
      #custom-power-reboot,
      #custom-net,
      #custom-swaync,
      #custom-tray-btn {
        font-family: "PP Supply Mono", "Material Symbols Sharp";
        font-weight: 600;
      }

      window#waybar {
        background-color: @bg0;
        color: @fg0;
        transition-property: background-color;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #mpris,
      #wireplumber,
      #tags,
      #taskbar,
      #tray,
      #mode,
      #idle_inhibitor,
      #custom-tray-btn,
      #custom-mem,
      #custom-swaync,
      #custom-power-icon,
      #custom-power-lock,
      #custom-power-logout,
      #custom-power-off,
      #custom-power-reboot,
      #mpd {
          padding: 0 8px;
          background-color: @bg1;
          color: @fg0;
      }

      #clock {
          background-color: @bg1;
          color: @fg0;
      }

      #battery {
          background-color: @bg1;
          color: @fg0;
      }

      #battery.charging, #battery.plugged {
          color: @green;
          background-color: @bg1;
          /* border: 1px solid #FFFFFF; */
      }

      @keyframes blink {
          to {
              background-color: @bg1;
              color: @fg0;
          }
      }

      #battery.critical:not(.charging) {
        background-color: @bg1;
        color: @red;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      label:focus {
        background-color: @bg0;
      }

      #cpu {
        background-color: @bg1;
        color: @fg0;
      }

      #memory {
        background-color: @bg1;
        color: @fg0;
      }

      #disk {
        background-color: @bg1;
        color: @fg0;
      }

      #backlight {
        background-color: @bg1;
        color: @fg0;
      }

      #network {
        background-color: @bg1;
        color: @fg0;
      }

      #network.disconnected {
        background-color: @bg1;
        color: @red;
      }

      #pulseaudio {
        background-color: @bg1;
        color: @fg0;
      }

      #pulseaudio.muted {
        background-color: @bg1;
        color: @red;
      }

      #mpris {
        background-color: @bg1;
        color: @fg0;
      }

      #mpris.spotify {
        background-color: @bg1;
        color: @fg0;
      }

      #mpris.vlc {
        background-color: @bg1;
        color: @fg0;
      }

      #mpris.brave {
        background-color: @bg1;
        color: @fg0;
      }

      #custom-power{
        background-color: @bg1;
        color: @fg0;
      }

      #tags{
        background-color: @bg1;
        color: @fg0;
      }

      #tags button.occupied {
        background-color: @bg1;
        color: @fg0;
      }

      #tags button.focused {
        background-color: @bg2;
        color: @fg0;
      }

      #tags button.urgent{
        background-color: @bg1;
        color: @red;
      }


      #temperature {
        background-color: @bg1;
        color: @fg0;
      }

      #temperature.critical {
        background-color: @bg1;
        color: @red;
      }

      #tray {
        background-color: @bg1;
        color: @fg0;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
        background-color: @bg0;
        color: @fg0;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
        background-color: @bg2;
        color: @fg0;
      }

      #language {
        background-color: @bg1;
        color: @fg0;
        min-width: 16px;
      }

      #keyboard-state {
        background-color: @bg1;
        color: @fg0;
        min-width: 16px;
      }

      #keyboard-state > label.locked {
          background: rgba(0, 0, 0, 0.2);
      }
    '';
  };
}
