{ lib, pkgs, config, ... }:
{
  services= {
    yabai = {
      enable = true;
      package = pkgs.yabai;
      enableScriptingAddition = true;
      extraConfig = (builtins.readFile ./yabairc);
    };

    skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = (builtins.readFile ./skhdrc);
    };

    # sketchybar = {
    #   enable = true;
    #   package = pkgs.sketchybar;
    # };
  };
}
