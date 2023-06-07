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
  };

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      initExtra = ''
        tempfile=$(${pkgs.coreutils}/bin/mktemp)
        ${pkgs.curl}/bin/curl ${cfg.wallpaperUrl} --output $tempfile && ${pkgs.feh}/bin/feh --bg-fill $tempfile && rm $tempfile
      '';
    };
  };
}

