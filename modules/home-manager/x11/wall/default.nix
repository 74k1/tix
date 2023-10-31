{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wallpaper;
in
{
  options.services.wallpaper = {
    enable = mkEnableOption "Random wallpaper service";

    wallpaperUrl = mkOption {
      type = types.str;
      default = "https://wall.74k1.sh/";
      example = "https://example.com/wallpaper.png";
      description = "The URL of the wallpaper image.";
    };

    setWallCommand = mkOption {
      type = types.str;
      default = "${pkgs.feh}/bin/feh --bg-fill $tempfile";
      example = "xfconf-query -c xfce4-desktop -p $(xfconf-query -c xfce4-desktop -l | grep 'workspace0/last-image') -s $tempfile";
      description = "The command, that sets the wallpaper. ($tempfile is the wallpaper file)";
    };
  };

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      initExtra = ''
        tempfile=$(${pkgs.coreutils}/bin/mktemp)
        ${pkgs.curl}/bin/curl ${cfg.wallpaperUrl} --output $tempfile
        ${cfg.setWallCommand}
        rm $tempfile
      '';
    };
  };
}

