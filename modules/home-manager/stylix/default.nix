{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.theme.ukiyo;
  icon = {
    name = "Colloid-Dark";

    package = (pkgs.colloid-icon-theme.overrideAttrs (old: {
      preInstall = old.preInstall or "" + ''
        echo "[categories@2x/22]" >> ./src/index.theme
        echo "Size=22" >> ./src/index.theme
        echo "Scale=2" >> ./src/index.theme
        echo "Context=Categories" >> ./src/index.theme
        echo "Type=Fixed" >> ./src/index.theme
      '';
    }));
  };
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
      iconTheme = {
        enable = true;
        dark = icon.name;
        package = icon.package;
      };
      base16Scheme = {
        base00 = "#07060B";
        base01 = "#1C1B28";
        base02 = "#323246";
        base03 = "#4C4B69";
        base04 = "#72708E";
        base05 = "#938FA8";
        base06 = "#BFBDCA";
        base07 = "#EBE9F1";
        base08 = "#FF5487";
        base09 = "#54FF80";
        base0A = "#FFE375";
        base0B = "#6682FF";
        base0C = "#F76DE2";
        base0D = "#4CCEFE";
        base0E = "#816BFF";
        base0F = "#4CBF67";
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
          package = inputs.unfree-fonts.packages.x86_64-linux.supply-mono;
          name = "PP Supply Mono";
        };
        emoji = {
          package = pkgs.twitter-color-emoji;
          name = "Twemoji";
        };
      };
      autoEnable = true;
      # targets = {
      #   spicetify.enable = false;
      #   firefox.profileNames = [ "taki" ];
      #   tmux.enable = false;
      #   gnome.enable = true;
      #   gtk = {
      #     enable = true;
      #     extraCss = /* css */ ''
      #       // Remove rounded corners
      #       window.background { border-radius: 0; }
      #     '';
      #   };
      #   neovim = {
      #     enable = false;
      #     transparentBackground = {
      #       main = true;
      #       signColumn = true;
      #     };
      #   };
      #   yazi.enable = false;
      #   zathura.enable = false;
      # };
    };
  };
}
