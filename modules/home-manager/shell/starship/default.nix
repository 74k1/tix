{ lib, pkgs, config, ... }:

{
  imports = [];

  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
