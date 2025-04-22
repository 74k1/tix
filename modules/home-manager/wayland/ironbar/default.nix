{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  ib-cpu = pkgs.writeScriptBin "ib-cpu" (builtins.readFile ./scripts/ib-cpu.sh);
  ib-mem = pkgs.writeScriptBin "ib-mem" (builtins.readFile ./scripts/ib-mem.sh);
  ib-vol = pkgs.writeScriptBin "ib-vol" (builtins.readFile ./scripts/ib-vol.sh);
  get-set-vol = pkgs.writeScriptBin "get-set-vol" (builtins.readFile ./scripts/get-set-vol.sh);
in {
  imports = [
    inputs.ironbar.homeManagerModules.default
  ];

  programs.ironbar = {
    enable = true;
    systemd = true;
    config = {
      # ironvar_defaults = {
      #   # see https://github.com/JakeStanger/ironbar/wiki/ironvars
      # };
      # monitors = {
      #   eDP-1 = {
          popup_gap = 0;
          # autohide = 500;
          # start_hidden = true;
          anchor_to_edges = true;
          position = "top";
          height = 16;
          start = [
            {
              bar = [
                {
                  label = "[ PWR ]";
                  name = "power-btn";
                  on_click = "popup:toggle";
                  on_mouse_enter = "popup:toggle";
                  on_mouse_exit = "popup:toggle";
                  type = "button";
                }
              ];
              class = "power-menu";
              tooltip = "Up: {{uptime}}";
              type = "custom";
              popup = [
                {
                  orientation = "v";
                  type = "box";
                  widgets = [
                    {
                      label = "Power menu";
                      name = "header";
                      type = "label";
                    }
                    {
                      type = "box";
                      widgets = [
                        {
                          class = "power-btn";
                          label = "<span font-size='32pt'></span>";
                          on_click = "!shutdown now";
                          type = "button";
                        }
                        {
                          class = "power-btn";
                          label = "<span font-size='32pt'></span>";
                          on_click = "!reboot";
                          type = "button";
                        }
                      ];
                    }
                    {
                      label = "Uptime: hello";
                      name = "uptime";
                      type = "label";
                    }
                  ];
                }
              ];
            }
            {
              type = "clock";
              format = "[ %H:%M:%S ]";
              format_popup = "%Y-%m-%d, %a %H:%M:%S";
            }
            # TODO: if 16:9 / landscape monitor:
            {
              # CPU
              type = "script";
              cmd = lib.getExe ib-cpu;
              mode = "poll";
              interval = 2500;
            }
            {
              # MEM
              type = "script";
              cmd = lib.getExe ib-mem;
              mode = "poll";
              interval = 2500;
            }
            # fi
          ];
          # center = [
          #   {
          #     type = "focused";
          #     show_icon = false;
          #     show_title = true;
          #     icon_size = 16;
          #     # truncate = {
          #       # mode = "end";
          #       # max_length = 50;
          #     # };
          #   }
          #   {
          #     type = "music";
          #     player_type = "mpris";
          #     format = "// PLY: {title} / {artist}";
          #     # truncate = {
          #     #   mode = "end";
          #     #   max_length = 20;
          #     # };
          #     show_status_icon = false;
          #     icons = {
          #       play = "";
          #       pause = "󰏥";
          #       prev = "󰙣";
          #       next = "󰙡";
          #       volume = "󰕾";
          #     };
          #   }
          # ];
          end = [
            {
              bar = [
                {
                  label = "{{100:${lib.getExe ib-vol}}}";
                  name = "vol-btn";
                  on_click = "popup:toggle";
                  on_mouse_enter = "popup:toggle";
                  on_mouse_exit = "popup:toggle";
                  type = "button";
                }
              ];
              class = "vol-menu";
              tooltip = "dev/{{5000:uptime}}";
              type = "custom";
              on_scroll_up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
              on_scroll_down = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-";
              on_click_middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              popup = [
                {
                  orientation = "v";
                  type = "box";
                  widgets = [
                    {
                      label = "Volume Menu";
                      name = "header";
                      type = "label";
                    }
                    {
                      type = "box";
                      name = "idk";
                      orientation = "v";
                      widgets = [
                        {
                          type = "slider";
                          length = 100;
                          step = 5;
                          min = 0;
                          max = 100;
                          show_label = true;
                          orientation = "h";
                          # on_change  = "${lib.getExe get-set-vol} $${0%.*}";
                          value = "200:${lib.getExe get-set-vol}";
                        }
                        # {
                        #   type = "label";
                        #   class = "data";
                        #   label = "#data1";
                        # }
                        # {
                        #   type = "label";
                        #   class = "data";
                        #   label = "#data2";
                        # }
                      ];
                    }
                    {
                      label = "Current Device: {{uptime}}";
                      name = "curr-dev";
                      type = "label";
                    }
                  ];
                }
              ];
            }
            # TODO: if main monitor / landscape
            {
              type = "custom";
              # tooltip = "Tray";
              bar = [
                {
                  label = "[···]";
                  name = "tray";
                  on_click = "popup:toggle";
                  type = "button";
                }
              ];
              popup = [
                {
                  orientation = "vertical";
                  type = "box";
                  widgets = [
                    {
                      type = "tray";
                      icon_size = 16;
                    }
                  ];
                }
              ];
            }
            {
              type = "clipboard";
              name = "clipboard";
              max_items = 50;
              truncate = {
                mode = "end";
                length = 50;
              };
            }
            {
              type = "notifications";
              show_count = true;
              # icons.closed_none = "󰂜";
              # icons.closed_some = "󰂜";
              # icons.closed_dnd = "󰪓";
              # icons.open_none = "󰂚";
              # icons.open_some = "󰂚";
              # icons.open_dnd = "󰂠";
            }
            # fi
            # TODO: if laptop / on batt
            # (lib.mkIf false
            {
              type = "upower";
              format = "{percentage}% / {state}% / {time_remaining}";
            }
            # )
            # fi
            # {
            #   type = "network_manager";
            #   icon_size = 16;
            # }
            # TODO: if laptop / on batt
            # (lib.mkIf false
            #   {
            #     type = "brightness level";
            #     format = "{percentage}% / {state}% / {time_remaining}";
            #   }
            # )
            # fi
            # {
            #   # Power Menu
            #   type = "custom";
            #   label = "󱄅 ";
            #   tooltip = "Up: {{30000:uptime -p | cut -d ' ' -f2-}}";
            #   name = "NixOS";
            # }
          ];
      #   };
      # };
    };
    style =
      /*
      css
      */
      ''
        @define-color color_bg ${config.lib.stylix.colors.withHashtag.base01};
        @define-color color_bg_dark ${config.lib.stylix.colors.withHashtag.base00};
        @define-color color_border ${config.lib.stylix.colors.withHashtag.base06};
        @define-color color_accent ${config.lib.stylix.colors.withHashtag.base0D};
        @define-color color_text ${config.lib.stylix.colors.withHashtag.base05};
        @define-color color_urgent ${config.lib.stylix.colors.withHashtag.base08};

        * {
          font-family: "PP Supply Mono", "FreeMono", monospace, sans-serif;
          font-size: 16px;
          border: none;
          border-radius: 0;
          outline: none;
          font-weight: 500;
          /* padding: 0; */
          /* margin: 0; */
          transition: unset;
          color: @color_text;
        } 

        box, menubar, button {
          background-color: alpha(@color_bg_dark, 0.925);
          background-image: none;
          box-shadow: none;
        }

        button, label {
          color: @color_text;
        }

        button:hover {
          background-color: @color_bg;
        }

        .item, .label, .script, .tray {
          padding-left: 0.5em;
          padding-right: 0.5em;
        }

        scale trough {
          min-width: 1px;
          min-height: 2px;
        }

        /* #bar { */
        /*   border-top: 1px solid @color_accent; */
        /* } */

        .popup {
          border: 1px solid @color_accent;
          padding: 1em;
        }

        .popup-clock .calendar-clock {
          padding-bottom: 0.1em;
        }

        .popup-clock .calendar .header {
          padding-top: 1em;
        }

        .popup-clock .calendar {
          padding: 0.2em 0.4em;
        }

        .popup-clock .calendar:selected {
          color: @color_accent;
        }

        /* -- upower -- */

        .upower {
          padding-left: 0.2em;
          padding-right: 0.2em;
        }

        .upower .label {
          padding-left: 0;
          padding-right: 0;
        }

        /* -- launcher -- */

        .launcher .item {
          padding-left: 1em;
          padding-right: 1em;
          margin-right: 4px;
        }

        /* -- clipboard -- */

        .clipboard {
          margin-left: 5px;
          font-size: 1.1em;
        }

        .popup-clipboard .item {
          padding-bottom: 0.3em;
          border-bottom: 1px solid ${config.lib.stylix.colors.withHashtag.base0D};
        }
      '';
    # features = [];
  };
}
