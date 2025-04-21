{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.theme.ukiyo;
  berkeley-otf = pkgs.callPackage "${inputs.self}/pkgs/berkeley-otf.nix" {inherit pkgs;};
in {
  options = {
    theme.ukiyo = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "Ukiyo package";
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      polarity = "dark";
      # image = ./wall.png;
      image = pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/0/07/Johan_Christian_Dahl_-_View_of_Dresden_by_Moonlight_-_Google_Art_Project.jpg";
        name = "wallpaper.jpg";
        hash = "sha256-MjBzldNqNQa1aPoxUPyimovl+YSA4m74Dx7MIsswxtU=";
      };
      cursor = {
        size = 16;
        package = cfg.package;
        name = "Ukiyo";
      };
      base16Scheme = {
        base00 = "#06040D";
        base01 = "#0B0814";
        base02 = "#211B36";
        base03 = "#292242";
        base04 = "#D2D2E0";
        base05 = "#E1E1ED";
        base06 = "#C8C3D9";
        base07 = "#D8D1E6";
        base08 = "#FF5487";
        base09 = "#FFB066";
        base0A = "#FFE375";
        base0B = "#54FF80";
        base0C = "#5C9CFF";
        base0D = "#6C69FF";
        base0E = "#4CCEFE";
        base0F = "#DA70FF";
      };

      fonts = {
        # serif = {
        #   package = pkgs.dejavu_fonts;
        #   name = "DejaVu Serif";
        # };

        # sansSerif = {
        #   package = pkgs.dejavu_fonts;
        #   name = "DejaVu Sans";
        # };

        monospace = {
          package = berkeley-otf;
          name = "TX02 Nerd Font";
        };

        emoji = {
          package = pkgs.twitter-color-emoji;
          name = "Twemoji";
        };
      };

      autoEnable = true;

      targets = {
        spicetify.enable = false;
        firefox.profileNames = [ "taki" ];
        tmux.enable = false;
        gnome.enable = true;
        gtk = {
          enable = true;
          extraCss = /* css */ ''
            // Remove rounded corners
            window.background { border-radius: 0; }
          '';
        };
        neovim = {
          enable = false;
          transparentBackground = {
            main = true;
            signColumn = true;
          };
        };
        yazi.enable = false;
        zathura.enable = false;
      };
    };
  };
}
