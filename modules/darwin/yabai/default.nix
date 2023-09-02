{ lib, pkgs, config, ... }:
{
  services= {
    yabai = {
      enable = false;
      package = pkgs.yabai;
      enableScriptingAddition = true;
      extraConfig = (builtins.readFile ./yabairc);
    };

    skhd = {
      enable = false;
      package = pkgs.skhd;
      skhdConfig = (builtins.readFile ./skhdrc);
    };

    # sketchybar = {
    #   enable = true;
    #   package = pkgs.sketchybar;
    # };
  };
}
