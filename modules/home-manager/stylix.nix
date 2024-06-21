{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.theme.ukiyo;
in {
  stylix = {
    enable = true;
    image = ./wall.png;
    cursor = {
      package = cfg.package;
      name = "Ukiyo";
    };
    colors.withHashtag = {
      base00 = "#08040C";
      base01 = "#403B45";
      base02 = "#5F5A65";
      base03 = "#76707C";
      base04 = "#8D8893";
      base05 = "#A09BA6";
      base06 = "#BEBAC2";
      base07 = "#F6F6F6";
      base08 = "#FF2465";
      base09 = "#FFB066";
      base0A = "#FFE16E";
      base0B = "#22EF92";
      base0C = "#46DAF8";
      base0D = "#5767FF";
      base0E = "#B366FF";
      base0F = "#EB52FF";
    };
    font = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      
      sans = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      
      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twemoji";
      };
    };
    autoEnable = false;
    target = {
      gnome.enable = false;
    };
  };
}
