{ lib, pkgs, config, ... }:

let
  cfg = config.programs.wezterm;
in
{
  options = {
    programs.wezterm = {
      transparency = lib.mkOption {
        type = lib.types.boolean;
        description = "Whether to enable transparency or not";
        default = false;
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      wezterm
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    programs.wezterm = {
      enable = true;
      extraConfig = import ./config.nix cfg;
    };
  };
}
