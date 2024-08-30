{ lib, pkgs, config, ... }:

let
  cfg = config.programs.wezterm;
in
{
  options = {
    programs.wezterm = {
      transparency = lib.mkOption {
        type = lib.types.bool;
        description = "transparency?";
        default = false;
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      wezterm
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono"]; })
    ];

    programs.wezterm = {
      enable = true;
      extraConfig = import ./config.nix cfg;
    };
  };
}
