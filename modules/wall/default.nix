{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wallpaper;
in
{
  options = {
    services.wallpaper = {
      enable = lib.mkEnableOption "Random wallpaper service";

      wallpaperUrl = lib.mkOption {
        type = lib.types.str;
        default = "https://wall.74k1.sh/";
        example = "https://example.com/wallpaper.png";
        description = "The URL of the wallpaper image.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.wallpaper = {
      Description = "Random Wallpaper service";
      PartOf = [ "graphical-session.target" ];

      Service = {
        Type = "oneshot";
        ExecStart = let
          script = pkgs.writeShellScript "random-wallpaper" ''
            #!/bin/sh
            
            # Create a temporary file to store the image
            tempfile=$(${pkgs.coreutils}/bin/mktemp)

            # Fetch random image from url
            ${pkgs.curl}/bin/curl ${cfg.url} --output $tempfile

            # Set the image as background
            ${pkgs.feh}/bin/feh --bg-fill $tempfile

            # Remove the temp file
            rm $tempfile
          '';
        in "${script}";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
