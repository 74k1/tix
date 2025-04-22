{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  programs.ironbar = {
    enable = true;
    systemd = true;
    config = let
      power-mgmt = {
      };
    in {
      monitors = {
        DP-1 = {
          anchor_to_edges = true;
          position = "top";
          height = 16;
          start = [ # non-interactive statuses
            {
              # Power Menu
              type = "label";
              label = "󱄅";
              name = "NixOS";
            }
            # TODO: if 16:9 / landscape monitor:
            {
              # TODO: show as bars? [||||||||] or smt
              type = "sys_info";
              format = [
                " {cpu_percent}%"
                " {memory_percent}%"
              ];
            }
            # fi
            {
              type = "workspaces";
              # favorites = [ "一" "二" "三" "四" "五" ];
              all_monitors = false;
              name_map = {
                # "01" = "一";
                # "02" = "二";
                # "03" = "三";
                # "04" = "四";
                # "05" = "五";
                # "06" = "六";
                # "07" = "七";
                # "08" = "八";
                # "09" = "九";
                # "10" = "十";
                "6" = "浮";
                "7" = "浮";
                "8" = "浮";
                "9" = "浮";
                "10" = "浮";
                "11" = "浮";
                "12" = "浮";
                "13" = "浮";
                "14" = "浮";
                "15" = "浮";
              };
            }
            {
              type = "focused";
              name = "foco";
              show_icon = false;
              show_title = true;
              icon_size = 16;
              truncate = {
                mode = "end";
                max_length = 50;
              };
            }
            # {
            #   type = "music";
            #   player_type = "mpris";
            #   format = "󰝚 {title} / {artist}";
            #   truncate = {
            #     mode = "end";
            #     max_length = 20;
            #   };
            #   show_status_icon = false;
            #   icons = {
            #     play = "";
            #     pause = "󰏥";
            #     prev = "󰙣";
            #     next = "󰙡";
            #     volume = "󰕾";
            #   };
            # }
            # { 
            #   bar = [{
            #     label = "";
            #     name = "power-btn";
            #     on_click = "popup:toggle";
            #     type = "button";
            #   }];
            #   class = "power-menu";
            #   tooltip = "Up: hello2"; 
            #   type = "custom";
            #   popup = [
            #     {
            #       orientation = "v";
            #       type = "box";
            #       widgets = [
            #         {
            #           label = "Power menu";
            #           name = "header";
            #           type = "label";
            #         }
            #         {
            #           type = "box";
            #           widgets = [
            #             {
            #               class = "power-btn";
            #               label = "<span font-size='40pt'></span>";
            #               on_click = "!shutdown now";
            #               type = "button";
            #             }
            #             {
            #               class = "power-btn";
            #               label = "<span font-size='40pt'></span>";
            #               on_click = "!reboot";
            #               type = "button";
            #             }
            #           ];
            #         }
            #         {
            #           label = "Uptime: hello";
            #           name = "uptime";
            #           type = "label";
            #         }
            #       ];
            #     }
            #   ];
            # }
          ];
          center = [
            {
              type = "clock";
              format = "%H:%M:%S %a, %d %b";
              format_popup = "%Y-%m-%d %H:%M:%S";
            }
          ];
          end = [
            # TODO: if main monitor / landscape
            {
              type = "tray";
              icon_size = 16;
            }
            {
              type = "notifications";
              show_count = true;
              icons.closed_none = "󰂜";
              icons.closed_some = "󰂜";
              icons.closed_dnd = "󰪓";
              icons.open_none = "󰂚";
              icons.open_some = "󰂚";
              icons.open_dnd = "󰂠";
            }
            {
              type = "clipboard";
              max_items = 50;
              truncate = {
                mode = "end";
                length = 50;
              };
            }
            # fi
            {
              # TODO: Format as bars? [||||||||]
              type = "volume";
              format = "{icon} {percentage}%";
              max_volume = 100;
              icons = {
                volume_high = "󰕾";
                volume_medium = "󰖀";
                volume_low = "󰕿";
                muted = "󰝟";
              };
            }
            # TODO: if laptop / on batt
            # (lib.mkIf false
            #   {
            #     type = "upower";
            #     format = "{percentage}% / {state}% / {time_remaining}";
            #   }
            # )
            # fi
            {
              type = "network_manager";
              icon_size = 14;
            }
            # TODO: if laptop / on batt
            # (lib.mkIf false
            #   {
            #     type = "brightness level";
            #     format = "{percentage}% / {state}% / {time_remaining}";
            #   }
            # )
            # fi
          ];
        };
      };
    };
    style = /* css */ ''
      * {
        font-family: "TX-02", "FreeMono", monospace, sans-serif;
        font-size: 16px;
        border: none;
        border-radius: 10;
      }

      .background {
        background: none;
      }

      box, menubar, button {
          background-image: none;
          box-shadow: none;
      }

      /* button, label { */
      /*     color: @color_text; */
      /* } */

      /* button:hover { */
      /*     background-color: @color_bg_dark; */
      /* } */

      scale trough {
          min-width: 1px;
          min-height: 2px;
      }

        /* base00 = "#06040D"; */
        /* base01 = "#0B0814"; */
        /* base02 = "#211B36"; */
        /* base03 = "#292242"; */
        /* base04 = "#D2D2E0"; */
        /* base05 = "#E1E1ED"; */
        /* base06 = "#C8C3D9"; */
        /* base07 = "#D8D1E6"; */
        /* base08 = "#FF5487"; */
        /* base09 = "#FFB066"; */
        /* base0A = "#FFE375"; */
        /* base0B = "#54FF80"; */
        /* base0C = "#5C9CFF"; */
        /* base0D = "#6C69FF"; */
        /* base0E = "#4CCEFE"; */
        /* base0F = "#DA70FF"; */

      /* #bar { */
      /*     border-top: 1px solid ${config.lib.stylix.colors.withHashtag.base0D}; */
      /* } */

      /* .popup { */
      /*     border: 1px solid ${config.lib.stylix.colors.withHashtag.base0D}; */
      /*     padding: 1em; */
      /* } */

      /* -- clipboard -- */

      /* .clipboard { */
      /*     margin-left: 5px; */
      /*     font-size: 1.1em; */
      /* } */

      /* .popup-clipboard .item { */
      /*     padding-bottom: 0.3em; */
      /*     border-bottom: 1px solid ${config.lib.stylix.colors.withHashtag.base0D}; */
      /* } */

    '';
    # features = [];
  };

  # Scripts for Ironbar
  xdg.configFile."ironbar/scripts/ib-bluetooth-symbol.sh" = {
    executable = true;
    onChange = "${lib.getExe' pkgs.systemd "systemctl"} --user restart ironbar.service";
    source = ./scripts/ib-bluetooth-symbol.sh;
  };
}
