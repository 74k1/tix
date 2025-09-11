{
  allSecrets,
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.walker.homeManagerModules.default ];

  programs.walker = {
    enable = true;
    runAsService = true;
    config = # toml
      {
        # https://github.com/abenz1267/walker/blob/master/resources/config.toml
        force_keyboard_focus = true;
        close_when_open = true;
        theme = "yueye";
        disable_mouse = false;

        hide_quick_activation = true;
        hide_action_hints = true;
        hide_action_hints_dmenu = false;
        hide_return_action = true;

        shell = {
          anchor_top = true;
          anchor_bottom = true;
          anchor_left = true;
          anchor_right = true;
        };

        columns."symbols" = 3;

        placeholders."default" = {
          input = "search";
          list = "no results";
        };

        keybinds.quick_activate = [];

        providers = {
          default = [
            "desktopapplications"
            "calc"
            "websearch"
          ];
          empty = [ "desktopapplications" ];
          max_results = 48;
          prefixes = [
            { prefix = "; "; provider = "providerlist"; }
            { prefix = "> "; provider = "runner"; }
            { prefix = "/ "; provider = "files"; }
            { prefix = ". "; provider = "symbols"; }
            { prefix = "emoji "; provider = "symbols"; }
            { prefix = "= "; provider = "calc"; }
            { prefix = "@ "; provider = "websearch"; }
            { prefix = ": "; provider = "clipboard"; }
          ];

          clipboard.time_format = "%Y-%m-%d - %H:%M:%S";

          desktopapplications = {
            history = true;
            history_when_empty = true;
            window_integration = true;
            wm_integration = true;
          };

          websearch = {
            history = true;
            entries = [
              {
                # default = true;
                name = "Kagi";
                prefix = "k";
                url = "https://kagi.com/search?q=%TERM%";
              }
              {
                name = "MyNixOS";
                url = "https://mynixos.com/search?q=%TERM%";
                prefix = "mn";
              }
              {
                name = "GitHub";
                url = "https://github.com/search?q=%TERM%";
                prefix = "gh";
              }
            ];
          };
        };
      };
    themes = {
      "yueye" = {
        # Check out the default css theme as an example https://github.com/abenz1267/walker/blob/master/resources/themes/default/style.css
        style = /* css */ ''
          @define-color window_bg_color #07060B;
          @define-color theme_fg_color #BFBDCA;
          @define-color accent_bg_color #7089FF;

          * {
            font-family: "PP Supply Mono", monospace !important;
            border-radius = 0px !important;
          }

          child:hover .item-box, child:selected .item-box { background: alpha(@accent_bg_color, 0.33); }
          .keybind-hints { opacity: 0.5; color: @theme_fg_color; }
          .item-box { padding: 10px; }
          .item-subtext { font-size: 12px; opacity: 0.5; }
          .preview .large-icons { -gtk-icon-size: 64px; }
          .todo.done .item-text-box { opacity: 0.25; }
          .symbols .item-image { font-size: 24px; }
          .normal-icons { -gtk-icon-size: 16px; }
          .large-icons { -gtk-icon-size: 32px; }
          .calc .item-text { font-size: 24px; }
          .input placeholder { opacity: 0.5; }
          .todo.active { font-weight: bold; }
          .item-image { margin-right: 10px; }
          .list { color: @theme_fg_color; }
          .todo.urgent { font-size: 24px; }
          .input:focus, .input:active { }
          scrollbar { opacity: 0; }
          .calc .item-subtext { }
          .content-container { }
          .item-text-box { }
          * { all: unset; }
          .preview-box { }
          .placeholder { }
          .item-text { }
          .scroll { }
          child { }
          .box { }

          .box-wrapper {
            box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22);
            background: @window_bg_color;
            padding: 20px;
          }

          .input {
            caret-color: @theme_fg_color;
            background: lighter(@window_bg_color);
            padding: 10px;
            color: @theme_fg_color;
          }

          .preview {
            border: 1px solid alpha(@accent_bg_color, 0.75);
            padding: 10px;
            color: @theme_fg_color;
          }
        '';

        # Check out the default layouts for examples https://github.com/abenz1267/walker/tree/master/resources/themes/default
        # layouts = {
        #   "layout" = /* xml */ ''
        #   '';
        # };
      };
    };
  };
}
