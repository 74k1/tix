{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
let
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
      tooltip-format = "<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "month";
        mode-mon-col = 3;
        weeks-pos = "left";
        format = {
          months = "<span><b>{}</b></span>";
          weeks = "<span color='#ffcc66'><b>{}</b></span>";
          weekdays = "<span color='#ffcc66'><b>{}</b></span>";
          days = "<span color='#ecc6d9'><b>{}</b></span>";
          today = "<span color='#ff6699'><b><u>{}</u></b></span>";
        };
      };
      actions = {
        on-click-right = "mode";
        on-scroll-up = "shift_up";
        on-scroll-down = "shift_down";
      };
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
      exec = lib.getExe (
        pkgs.writeShellApplication {
          name = "wb-net";
          runtimeInputs = [
            pkgs.networkmanager
          ];
          text = builtins.readFile ./scripts/wb-net.sh;
        }
      );
      return-type = "json";
      format = "{icon}";
      format-icons = {
        lan = "";
        wifi-1 = "";
        wifi-2 = "";
        wifi-3 = "";
        wifi-4 = "";
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
          text =
            # sh
            ''
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

    "power-profiles-daemon" = {
      format = "{icon}";
      tooltip-format = "Power profile: {profile}\nDriver: {driver}";
      tooltip = true;
      format-icons = {
        default = "";
        performance = "";
        balanced = "";
        power-saver = "";
      };
    };

    "battery" = {
      states = {
        good = 88;
        warning = 30;
        critical = 15;
      };
      format = "BAT {capacity}% {icon}";
      # format-charging = "BAT  {capacity}% {icon}";
      # format = "{capacity}% {icon}";
      # format-charging = "{capacity}% {icon}";

      full-at = 89;
      tooltip-format = "{power}w {timeTo} {}";
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
in
{
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
          "ASUSTek COMPUTER INC - MQ16AHE - DP-6"
          "ASUSTek COMPUTER INC - MQ16AHE - DP-7"
          "Audio Processing Technology  Ltd - CX158 - DP-7"
          "Audio Processing Technology  Ltd - CX158 - DP-6"
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
      }
      // modules;

      mainBar = {
        height = 32;
        spacing = 8;
        position = "top";
        layer = "top";
        margin-left = 8;
        margin-right = 8;
        margin-top = 8;

        output = [
          "PNP(AOC) - AG276QZD2 - DP-6"
          "PNP(AOC) - AG276QZD2 - DP-7"
          "PNP(AOC) - 16T3E - DP-2"
          "eDP-1"
          "DP-2"
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
          "power-profiles-daemon"
          "battery"
        ];
      }
      // modules;
    };
    style =
      lib.mkForce
        # css
        ''
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
          #custom-tray-btn,
          #power-profiles-daemon {
            font-family: "PP Supply Mono", "Material Symbols Sharp";
            font-weight: 600;
          }

          window#waybar {
            /* background-color: @bg0; */
            background: rgba(7, 6, 11, 0.9);
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
              color: @fg0;
          }

          #clock {
              color: @fg0;
          }

          #battery {
              color: @fg0;
          }

          #battery.charging, #battery.plugged {
              color: @green;
              /* border: 1px solid #FFFFFF; */
          }

          @keyframes blink {
              to {
                  color: @fg0;
              }
          }

          #battery.critical:not(.charging) {
            color: @red;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          label:focus {
          }

          #cpu {
            color: @fg0;
          }

          #memory {
            color: @fg0;
          }

          #disk {
            color: @fg0;
          }

          #backlight {
            color: @fg0;
          }

          #network {
            color: @fg0;
          }

          #network.disconnected {
            color: @red;
          }

          #pulseaudio {
            color: @fg0;
          }

          #pulseaudio.muted {
            color: @red;
          }

          #mpris {
            color: @fg0;
          }

          #mpris.spotify {
            color: @fg0;
          }

          #mpris.vlc {
            color: @fg0;
          }

          #mpris.brave {
            color: @fg0;
          }

          #custom-power{
            color: @fg0;
          }

          #tags{
            color: @fg0;
          }

          #tags button.occupied {
            color: @fg0;
          }

          #tags button.focused {
            background-color: @bg2;
            color: @fg0;
          }

          #tags button.urgent{
            color: @red;
          }


          #temperature {
            color: @fg0;
          }

          #temperature.critical {
            color: @red;
          }

          #tray {
            color: @fg0;
          }

          #tray > .passive {
              -gtk-icon-effect: dim;
            color: @fg0;
          }

          #tray > .needs-attention {
              -gtk-icon-effect: highlight;
            background-color: @bg2;
            color: @fg0;
          }

          #language {
            color: @fg0;
            min-width: 16px;
          }

          #keyboard-state {
            color: @fg0;
            min-width: 16px;
          }

          #keyboard-state > label.locked {
              background: rgba(0, 0, 0, 0.2);
          }
        '';
  };
}
