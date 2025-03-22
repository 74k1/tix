{ config, inputs, pkgs, lib, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  # import the flake's module
  imports = [
    inputs.spicetify-nix.homeManagerModules
  ];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    theme = lib.mkForce spicePkgs.themes.text;
    colorScheme = "custom";
    customColorScheme = {
      accent             = "5665FB";
      accent-active      = "6D7CFF";
      accent-inactive    = "0E0C36";
      banner             = "6D7CFF";
      border-active      = "6D7CFF";
      border-inactive    = "404040";
      header             = "404040";
      highlight          = "0E0C36";
      main               = "06040C";
      notification       = "1AE981";
      notification-error = "FF5A74";
      subtext            = "b3b3b3";
      text               = "EEF2EE";
    };

    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      hidePodcasts
      fullAlbumDate
      fullAppDisplayMod
      # genre
    ];
  };
}
