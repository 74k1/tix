{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.polybar;
  
in {
  config = {
    services.polybar = {
      enable = true;
      script = ''
        for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
          MONITOR=$m polybar --reload &
        done
      '';
      config = {
        "bar/main" = {
          monitor = "\${env:MONITOR:}";
        };
      };
      extraConfig = builtins.readFile ./polybar.ini;
    };

    xsession.initExtra = ''
      systemctl --user enable --now polybar.service
    '';
  };
}
