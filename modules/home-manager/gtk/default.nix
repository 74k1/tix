{ inputs, config, pkgs, lib, ... }:

let
  cfg = config.gtk.ukiyo;
in
{
  options = {
    gtk.ukiyo = {
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

    gtk = {
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
