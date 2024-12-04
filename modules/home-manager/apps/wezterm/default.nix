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
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];

    programs.wezterm = {
      enable = true;
      extraConfig = import ./config.nix cfg;
    };
  };
}
