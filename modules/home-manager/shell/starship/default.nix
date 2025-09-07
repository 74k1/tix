{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [ ];

  programs.starship = {
    enable = false;
    enableBashIntegration = true;
    # enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
