{ inputs, outputs, config, lib, pkgs, ... }:
let
  themeRevision = pkgs.fetchFromGitHub {
    owner = "greyaz";
    repo = "ThemeRevision";
    rev = "1.1.12";
    hash = "sha256-TQiK6uruWdSYmrDjnhGz0DNDUOqMNB/C01aDqdghw74=";
  };

  kanboardWithTheme = pkgs.kanboard.overrideAttrs (oldAttrs: rec {
    postInstall =  (oldAttrs.postInstall or "") + ''
      # Create the plugins directory if it does not exist.
      mkdir -p $out/share/kanboard/plugins/ThemeRevision

      # Unpack ThemeRevision into the plugins folder.
      cp -rv ${themeRevision}/* $out/share/kanboard/plugins/ThemeRevision
    '';
  });
in
{
  # kanboard
  services.kanboard = {
    enable = true;
    package = kanboardWithTheme;
    domain = "kb.example.com";
    dataDir = "/mnt/btrfs_pool/kanboard";
    nginx = { };
  };
}
