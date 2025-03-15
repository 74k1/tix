{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.theme.ukiyo;
  berkeley-otf = pkgs.callPackage "${inputs.self}/pkgs/berkeley-otf.nix" { inherit pkgs; };
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
      # image = "${inputs.self}/modules/home-manager/stylix/wall.png";
      image = ./wall.png;
      cursor = {
        size = 16;
        package = cfg.package;
        name = "Ukiyo";
      };
      base16Scheme = {
        base00 = "08040C";
        base01 = "403B45";
        base02 = "5F5A65";
        base03 = "76707C";
        base04 = "8D8893";
        base05 = "A09BA6";
        base06 = "BEBAC2";
        base07 = "F6F6F6";
        base08 = "FF2465";
        base09 = "FFB066";
        base0A = "FFE16E";
        base0B = "22EF92";
        base0C = "46DAF8";
        base0D = "5767FF";
        base0E = "B366FF";
        base0F = "EB52FF";
      };
      fonts = {
        # serif = {
        #   package = pkgs.dejavu_fonts;
        #   name = "DejaVu Serif";
        # };
        #
        # sansSerif = {
        #   package = pkgs.dejavu_fonts;
        #   name = "DejaVu Sans";
        # };
        #
        monospace = {
          package = berkeley-otf;
          name = "TX02 Nerd Font";
        };

        emoji = {
          package = pkgs.twitter-color-emoji;
          name = "Twemoji";
        };
      };
      autoEnable = true; # false;
      targets = {
        spicetify.enable = false;
      };
      # target = {
      #   tmux.enable = false;
      #   gnome.enable = true;
      #   gtk = {
      #     enable = true;
      #     extraCss = ''
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
