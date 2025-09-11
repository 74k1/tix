{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.sherlock = {
    enable = true;

    # for faster startup times
    systemd.enable = true;

    package = inputs.sherlock.packages.${pkgs.system}.default;

    # config.json / config.toml
    settings = {
      default_apps = {
        terminal = "${lib.getExe pkgs.ghostty} -e";
      };

      units = {
        lengths = "meters";
        weights = "kg";
        volumes = "l";
        temperatures = "C";
        currency = "chf";
      };

      debug = {
        try_suppress_errors = false;
        try_suppress_warnings = true;
      };

      appearance = {
        width = 350;
        height = 440;
        gsk_renderer = "cairo";
        icon_size = 0;
        use_base_css = false;
        opacity = 1.0;
        mod_key_ascii = ["⇧" "⇧" "⌘" "⌘" "⎇" "✦" "✦" "⌘"];
      };

      behavior = {
        use_xdg_data_dir_icons = false;
        animate = false;
      };

      binds = {
        modifier = "alt";
        exec_inplace = "alt-return";
      };

      expand = {
        enable = false;
        edge = "top";
        margin = 0;
      };

      backdrop = {
        enable = false;
        opacity = 0.6;
        edge = "top";
      };

      search_bar_icon = {
        enable = false;
        icon = "system-search-symbolic";
        icon_back = "go-previous-symbolic";
        size = 22;
      };
    };

    # sherlock_alias.json
    # aliases = {
    #   vesktop = { name = "Discord"; };
    # };

    # sherlockignore
    # ignore = ''
    #   Avahi*
    # '';

    # fallback.json
    launchers = [
      {
        name = "Kill Process";
        alias = "kill";
        type = "process";
        args = {};
        priority = 0;
      }
      {
        name = "Calculator";
        type = "calculation";
        args = {
          capabilities = [
            "calc.math"
            "calc.units"
          ];
        };
        priority = 1;
      }
      {
        name = "App Launcher";
        type = "app_launcher";
        args = { };
        priority = 2;
        home = "Home";
      }
      {
        name = "Emoji Picker";
        type = "emoji_picker";
        args = {
          default_skin_tone = "Simpsons";
        };
        priority = 4;
        home = "Search";
      }
      {
        name = "Power Management";
        type = "command";
        alias = "pm";
        args = {
          commands = {
            "Shutdown" = {
              icon = "system-shutdown";
              icon_class = "reactive";
              exec = "systemctl poweroff";
              search_string = "Poweroff;Shutdown";
            };
            "Lock" = {
              icon = "system-lock-screen";
              icon_class = "reactive";
              exec = "systemctl suspend & hyprlock";
              search_string = "Lock";
            };
            "Reboot" = {
              icon = "system-reboot";
              icon_class = "reactive";
              exec = "systemctl reboot";
              search_string = "Reboot;Restart";
            };
            "Log Out" = {
              icon = "system-log-out";
              icon_class = "reactive";
              exec = "niri msg action quit -s";
              search_string = "logout;exit";
            };
          };
        };
        priority = 5;
      }
    ];

    # main.css
    style = # css
      ''
        * {
          font-family: "PP Supply Mono";
        }
      '';
  };
}
