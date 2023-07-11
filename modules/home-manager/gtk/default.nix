{ config, pkgs, ... }:
{
  home.package = [
    inputs.ukiyo.packages.x86_64-linux.default
  ];

  gtk = {
    theme = {
      package = pkgs.ukiyo;
      name = "Ukiyo";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    cursorTheme = {
      package = pkgs.ukiyo;
      name = "Ukiyo";
      #size = 16;
    };
  };
}
