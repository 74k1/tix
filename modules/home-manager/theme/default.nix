{ inputs, config, pkgs, lib, ... }:

let
  cfg = config.theme.ukiyo;
in
{
  options = {
    theme.ukiyo = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "Ukiyo package";
      };
    };
  };

  config = {
    home.packages = [
      cfg.package
    ];
    
    qt = {
      enable = true;
      
      platformTheme = "gtk";
      style = {
        name = "Ukiyo";
        package = cfg.package;
      };
    };

    gtk = {
      enable = true;
      theme = {
        package = cfg.package;
        name = "Ukiyo";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      cursorTheme = {
        package = cfg.package;
        name = "Ukiyo";
        #size = 16;
      };
    };
  };
}
