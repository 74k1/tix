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

    package = inputs.sherlock-gpui.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # config.json / config.toml
    # settings = {
    #   default_apps = {
    #     terminal = "${lib.getExe pkgs.ghostty} -e";
    #   };
    #
    #   units = {
    #     lengths = "meters";
    #     weights = "kg";
    #     volumes = "l";
    #     temperatures = "C";
    #     currency = "chf";
    #   };
    #
    #   debug = {
    #     try_suppress_errors = false;
    #     try_suppress_warnings = true;
    #   };
    #
    #   appearance = {
    #     width = 350;
    #     height = 440;
    #     gsk_renderer = "cairo";
    #     icon_size = 0;
    #     use_base_css = false;
    #     opacity = 1.0;
    #     mod_key_ascii = ["⇧" "⇧" "⌘" "⌘" "⎇" "✦" "✦" "⌘"];
    #   };
    #
    #   behavior = {
    #     use_xdg_data_dir_icons = false;
    #     animate = false;
    #   };
    #
    #   binds = {
    #     modifier = "alt";
    #     exec_inplace = "alt-return";
    #   };
    #
    #   expand = {
    #     enable = false;
    #     edge = "top";
    #     margin = 0;
    #   };
    #
    #   backdrop = {
    #     enable = false;
    #     opacity = 0.6;
    #     edge = "top";
    #   };
    #
    #   search_bar_icon = {
    #     enable = false;
    #     icon = "system-search-symbolic";
    #     icon_back = "go-previous-symbolic";
    #     size = 22;
    #   };
    # };
    #
    # # sherlock_alias.json
    # # aliases = {
    # #   vesktop = { name = "Discord"; };
    # # };
    #
    # # sherlockignore
    # # ignore = ''
    # #   Avahi*
    # # '';
    #
    # # fallback.json
    # launchers = [
    #   {
    #     name = "Kill Process";
    #     alias = "kill";
    #     type = "process";
    #     args = {};
    #     priority = 0;
    #   }
    #   {
    #     name = "Calculator";
    #     type = "calculation";
    #     args = {
    #       capabilities = [
    #         "calc.math"
    #         "calc.units"
    #       ];
    #     };
    #     priority = 1;
    #   }
    #   {
    #     name = "App Launcher";
    #     type = "app_launcher";
    #     args = { };
    #     priority = 2;
    #     home = "Home";
    #   }
    #   {
    #     name = "Emoji Picker";
    #     type = "emoji_picker";
    #     args = {
    #       default_skin_tone = "Simpsons";
    #     };
    #     priority = 4;
    #     home = "Search";
    #   }
    #   {
    #     name = "Power Management";
    #     type = "command";
    #     alias = "pm";
    #     args = {
    #       commands = {
    #         "Shutdown" = {
    #           icon = "system-shutdown";
    #           icon_class = "reactive";
    #           exec = "systemctl poweroff";
    #           search_string = "Poweroff;Shutdown";
    #         };
    #         "Lock" = {
    #           icon = "system-lock-screen";
    #           icon_class = "reactive";
    #           exec = "systemctl suspend & hyprlock";
    #           search_string = "Lock";
    #         };
    #         "Reboot" = {
    #           icon = "system-reboot";
    #           icon_class = "reactive";
    #           exec = "systemctl reboot";
    #           search_string = "Reboot;Restart";
    #         };
    #         "Log Out" = {
    #           icon = "system-log-out";
    #           icon_class = "reactive";
    #           exec = "niri msg action quit -s";
    #           search_string = "logout;exit";
    #         };
    #       };
    #     };
    #     priority = 5;
    #   }
    # ];
    #
    # # main.css
    # style = # css
    #   ''
    #     /*----------------------------------------------------------
    #     --  | |__  _   _  ___| | ____      _____  _ __| | _____   --
    #     --  | '_ \| | | |/ __| |/ /\ \ /\ / / _ \| '__| |/ / __|  --
    #     --  | |_) | |_| | (__|   <  \ V  V / (_) | |  |   <\__ \  --
    #     --  |_.__/ \__,_|\___|_|\_\  \_/\_/ \___/|_|  |_|\_\___/  --
    #     --                                                        --
    #     --             https://github.com/kbuckleys/              --
    #     ----------------------------------------------------------*/
    #
    #     overshoot *,
    #     undershoot *,
    #     overshoot.top,
    #     overshoot.right,
    #     overshoot.bottom,
    #     overshoot.left undershoot.top,
    #     undershoot.right,
    #     undershoot.bottom,
    #     undershoot.left,
    #     .scroll-window>*,
    #     overshoot:backdrop {
    #         background: none;
    #         border: none;
    #         background-color: transparent;
    #     }
    #
    #     * {
    #         all: unset;
    #         padding: 0px;
    #         margin: 0px;
    #         outline-width: 0px;
    #         outline-offset: -3px;
    #         outline-style: dashed;
    #         line-height: 1;
    #         font-family: "PP Supply Mono";
    #     }
    #
    #     label {
    #         color: hsl(var(--text));
    #     }
    #     #overlay spinner {
    #         color: hsl(var(--text));
    #     }
    #     #backdrop {
    #         background: black;
    #     }
    #
    #     row:selected,
    #     #overlay * {
    #         background: transparent;
    #     }
    #     .notifications {
    #         background: transparent;
    #     }
    #
    #     scrolledwindow>viewport,
    #     scrolledwindow>viewport>*,
    #     listview,
    #     gridview,
    #     window {
    #         background: #1C1B28;
    #     }
    #     window:not(#backdrop) {
    #         color: hsl(var(--text));
    #         border-radius: 0px;
    #         border: 1px solid #323246;
    #     }
    #
    #     /* SEARCH PAGE */
    #     #search-bar {
    #         outline: none;
    #         border: none;
    #         background: #07060B;
    #         min-height: 22px;
    #         max-height: 22px;
    #         color: #EBE9F1;
    #         font-size: 14px;
    #         padding-left: 10px;
    #     }
    #     #search-bar-holder {
    #         border-bottom: 1px solid #4C4B69;
    #         padding: 4px 10px 4px 10px;
    #     }
    #     #search-icon-holder image {
    #         transition: 0.1s ease;
    #     }
    #     #search-icon-holder.search image:nth-child(1) {
    #         transition-delay: 0.05s;
    #         opacity: 1;
    #     }
    #     #search-icon-holder.search image:nth-child(2) {
    #         transform: rotate(-180deg);
    #         opacity: 0;
    #     }
    #     #search-icon-holder.back image:nth-child(1) {
    #         opacity: 0;
    #     }
    #     #search-icon-holder.back image:nth-child(2) {
    #         transition-delay: 0.05s;
    #         opacity: 1;
    #     }
    #     #search-icon {
    #         margin-left: 10px;
    #     }
    #     #search-bar:focus {
    #         outline: none;
    #     }
    #     #search-bar placeholder {
    #         background: transparent;
    #         background-color: transparent;
    #         color: #323246;
    #         font-weight: 700;
    #     }
    #
    #     #category-type {
    #         font-size: 0;
    #         padding: 0 20px 0px 20px;
    #     }
    #
    #     .scrolled-window {
    #         padding: 0px 0px 0px 0px;
    #         min-width: var(--width) * 0.2;
    #     }
    #
    #     image {
    #         color: #EBE9F1;
    #     }
    #
    #     .tile {
    #         outline: none;
    #         min-height: 26px;
    #         margin-bottom: 0px;
    #         border: none;
    #     }
    #
    #     .tile:hover *,
    #     .tile:hover {
    #         background: transparent;
    #     }
    #
    #     .tile.animate {
    #         transform: translateY(20px);
    #         opacity: 0;
    #         animation: fadeInUp 0.2s ease-out forwards;
    #     }
    #
    #     row:nth-child(1) .tile.animate {
    #         animation-delay: 0.05s;
    #     }
    #     row:nth-child(2) .tile.animate {
    #         animation-delay: 0.1s;
    #     }
    #     row:nth-child(3) .tile.animate {
    #         animation-delay: 0.15s;
    #     }
    #     row:nth-child(4) .tile.animate {
    #         animation-delay: 0.2s;
    #     }
    #     row:nth-child(5) .tile.animate {
    #         animation-delay: 0.25s;
    #     }
    #     row:nth-child(6) .tile.animate {
    #         animation-delay: 0.3s;
    #     }
    #     row:nth-child(7) .tile.animate {
    #         animation-delay: 0.35s;
    #     }
    #     row:nth-child(8) .tile.animate {
    #         animation-delay: 0.4s;
    #     }
    #     row:nth-child(9) .tile.animate {
    #         animation-delay: 0.45s;
    #     }
    #     row:nth-child(10) .tile.animate {
    #         animation-delay: 0.5s;
    #     }
    #
    #     @keyframes fadeInUp {
    #         from {
    #             letter-spacing: 1px;
    #             opacity: 0;
    #             transform: translateY(20px);
    #         }
    #         to {
    #             letter-spacing: 0px;
    #             opacity: 1;
    #             transform: translate(0px);
    #         }
    #     }
    #
    #     .tile #title {
    #         font-size: 14px;
    #         color: #EBE9F1;
    #     }
    #     .tile #icon {
    #         margin: 0px;
    #         padding: 0px;
    #     }
    #
    #     row:selected .tile {
    #         background: #323246;
    #     }
    #     row:selected .tile.multi-active,
    #     .tile.multi-active {
    #         background: hsla(var(--foreground), 1);
    #         background-color: hsla(var(--foreground), 1);
    #     }
    #
    #     .tile:focus {
    #         outline: none;
    #     }
    #
    #     #launcher-type {
    #         font-size: 0;
    #     }
    #
    #     #color-icon-holder {
    #         border-radius: 50px;
    #     }
    #
    #     /*SHORTCUT*/
    #     #shortcut-holder {
    #         margin-right: 15px;
    #         background: transparent;
    #     }
    #     #shortcut,
    #     #shortcut-modkey {
    #         font-size: 14px;
    #         font-weight: bold;
    #         color: #938FA8;
    #     }
    #
    #     /*CALCULATOR*/
    #     .calc-tile {
    #         padding: 10px 10px 20px 10px;
    #     }
    #     #calc-tile-quation {
    #         font-size: 10px;
    #         color: transparent;
    #     }
    #     #calc-tile-result {
    #         font-size: 25px;
    #         color: #938FA8;
    #     }
    #
    #     /*EVENT TILE*/
    #     .tile.tile.event-tile {
    #         padding: 5px 10px;
    #     }
    #     .tile.event-tile #title-label {
    #         padding: 2px 0px 7px 5px;
    #         text-transform: capitalize;
    #     }
    #     .tile.event-tile #time-label {
    #         font-size: 3rem;
    #     }
    #     #end-time-label {
    #         color: #72708E;
    #     }
    #
    #     /* BULK TEXT TILE */
    #     .bulk-text {
    #         padding-bottom: 10px;
    #         min-height: 50px;
    #     }
    #     #bulk-text-title {
    #         margin-left: 10px;
    #         padding: 10px 0px;
    #         font-size: 10px;
    #         color: #72708E;
    #     }
    #     #bulk-text-content-title {
    #         font-size: 17px;
    #         font-weight: bold;
    #         color: hsl(var(--text));
    #         min-height: 20px;
    #     }
    #     #bulk-text-content-body {
    #         font-size: 14px;
    #         color: hsl(var(--text));
    #         line-height: 1.4;
    #         min-height: 20px;
    #     }
    #
    #     /* EMOJI */
    #     gridview child {
    #         padding: 5px;
    #         background: transparent;
    #     }
    #     gridview child box {
    #         background: hsl(var(--foreground));
    #         border-radius: 5px;
    #         border: 1px solid transparent;
    #     }
    #     gridview child:selected box {
    #         border: 1px solid hsl(var(--tag-color));
    #     }
    #
    #     /* NEXT PAGE */
    #     .next_tile {
    #         color: hsl(var(--text));
    #         background: hsl(var(--background));
    #     }
    #     .next_tile #content-body {
    #         background: hsl(var(--background));
    #         padding: 10px;
    #         color: hsl(var(--text));
    #     }
    #     .raw_text,
    #     .next_tile #content-body {
    #         font-family: '0xProto Nerd Font';
    #         font-feature-settings: "kern" off;
    #         font-kerning: None;
    #     }
    #
    #     /*Error*/
    #     .error-tile #scroll-window {
    #         padding: 10px;
    #         min-height: 50px;
    #     }
    #     .error-tile {
    #         border-radius: 4px;
    #         padding: 5px 10px 10px 10px;
    #         color: #EBE9F1;
    #         border: 1px solid transparent;
    #         margin-bottom: 10px;
    #     }
    #     .error-tile * {
    #         background: transparent;
    #     }
    #     .error {
    #         border: 1px solid hsla(var(--error), 0.5);
    #         background: hsla(var(--error), 0.1);
    #     }
    #     .warning {
    #         border: 1px solid hsla(var(--warning), 0.5);
    #         background: hsla(var(--warning), 0.1);
    #     }
    #     .error-tile #title {
    #         padding: 10px;
    #         font-size: 10px;
    #         color: #72708E;
    #     }
    #     .error-tile #content-title {
    #         margin-left: 10px;
    #         font-size: 16px;
    #         font-weight: bold;
    #         color: hsl(var(--text));
    #     }
    #     .error-tile #content-body {
    #         margin-left: 10px;
    #         font-size: 14px;
    #         color: hsl(var(--text));
    #         line-height: 1.4;
    #         color: #72708E;
    #     }
    #
    #     /* CONTEXT MENU */
    #     #context-menu {
    #         min-width: 50px;
    #         padding: 5px;
    #         margin: 4px;
    #         background: hsl(var(--background));
    #         border: 1px solid hsl(var(--border));
    #         border-radius: 0px;
    #         box-shadow: unset;
    #     }
    #     #context-menu row {
    #         color: hsla(var(--text), 0.8);
    #         transition: 0.1s ease;
    #         padding: 10px 20px;
    #     }
    #     #context-menu label {
    #         color: hsla(var(--text), 0.8);
    #         font-size: 13px;
    #     }
    #     #context-menu row:selected {
    #         background: hsl(var(--foreground));
    #     }
    #
    #     /* TIMER TILE */
    #     .tile.timer-tile {
    #         padding: 10px 10px 10px 15px;
    #         background: transparent;
    #     }
    #     .tile.timer-tile.normal #timer-count {
    #         font-size: 2.5em;
    #         padding: 1.25em;
    #     }
    #     .tile.timer-tile.minimal #timer-count {
    #         font-size: 1.5em;
    #     }
    #     #timer-title {
    #         color: hsla(var(--text), 0.7);
    #         font-size: 11px;
    #     }
    #     #timer-image {
    #         /* -gtk-icon-filter: brightness(10) saturate(100%) contrast(100%); /1* white *1/ */
    #         filter: brightness(10) saturate(100%) contrast(100%);
    #         /* black */
    #     }
    #
    #     /* EMOJIES */
    #     .emoji-item {
    #         padding: 20px;
    #     }
    #     .emoji-item #emoji-name {
    #         font-size: 10px;
    #         color: hsla(var(--text), 0.3);
    #     }
    #     #context-menu.emoji row {
    #         padding: 3px;
    #     }
    #     #context-menu.emoji label {
    #         padding: 5px;
    #         border-radius: 3px;
    #     }
    #     #context-menu.emoji label.active {
    #         background: hsla(var(--text), 0.1);
    #     }
    #
    #     /*ANIMATIONS*/
    #     @keyframes vanish-rotate {
    #         from {
    #             opacity: 1;
    #         }
    #         to {
    #             opacity: 0;
    #             transform: rotate(360deg);
    #         }
    #     }
    #
    #     @keyframes rotate {
    #         from {
    #             transform: rotate(0deg);
    #             --start-rotation: 0deg;
    #         }
    #         to {
    #             transform: rotate(360deg);
    #             --start-rotation: 360deg;
    #         }
    #     }
    #
    #     @keyframes ease-opacity {
    #         from {
    #             opacity: 0;
    #         }
    #         to {
    #             opacity: 1;
    #         }
    #     }
    #
    #     @keyframes slide {
    #         from {
    #             transform: translate(0px, 0px);
    #         }
    #         to {
    #             transform: translate(-20px, 0px);
    #         }
    #     }
    #
    #     @keyframes slide {
    #         from {
    #             transform: translate(0px, 0px);
    #         }
    #         to {
    #             transform: translate(-20px, 0px);
    #         }
    #     }
    #
    #     .bulk-text {
    #         padding: 20px;
    #     }
    #   '';
  };
}
