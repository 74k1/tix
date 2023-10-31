{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.polybar;
in {
  config = {
    home.packages = with pkgs; [
      # polybar
      siji
    ];
    
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        alsaSupport = true;
        # githubSupport = true;
        # mpdSupport = true;
        pulseSupport = true;
        # i3GapsSupport = true;
      };
      script = ''
        for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
          MONITOR=$m polybar --reload &
        done
      '';
      config = {
        "bar/main" = {
          monitor = "\${env:MONITOR:}";
        };
        "module/pulse" = {
          click-left = "${pkgs.pulseaudio}/bin/pactl -- set-sink-volume @DEFAULT_SINK@ 100%";
          click-right = "${pkgs.wezterm}/bin/wezterm -e ${pkgs.pulsemixer}/bin/pulsemixer";
        };
      };
      extraConfig = builtins.readFile ./polybar.ini;
    };

    xsession.initExtra = ''
      systemctl --user enable --now polybar.service
    '';
  };
}
