{ inputs, outputs, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.waybar;
in {
  config = {
    home.packages = with pkgs; [
      # waybar
    ];

    services.waybar = {
      enable = true;

      # https://github.com/Alexays/Waybar/wiki/Configuration
      settings = {
        
      };

      style = {

      };

      systemd.enable = true;
    };
  };
}
