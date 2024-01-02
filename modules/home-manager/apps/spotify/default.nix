{ config, inputs, pkgs, lib, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  # install spotify
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  # import the flake's module
  imports = [
    inputs.spicetify-nix.homeManagerModule
  ];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;

    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      hidePodcasts
      playlistIcons
      fullAlbumDate
      fullAppDisplayMod
      genre
    ];
  };
}
