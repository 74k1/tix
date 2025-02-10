{ inputs, outputs, config, lib, pkgs, ... }:
let
  themeRevision = pkgs.fetchFromGitHub {
    owner = "greyaz";
    repo = "ThemeRevision";
    rev = "1.1.12";
    hash = "sha256-TQiK6uruWdSYmrDjnhGz0DNDUOqMNB/C01aDqdghw74=";
  };

  kanboardWithTheme = pkgs.kanboard.overrideAttrs (oldAttrs: rec {
    installPhase = ''
      runHook preInstall

      # Create the main Kanboard directory
      mkdir -p $out/share/kanboard

      # Copy Kanboard's files into the output.
      cp -rv . $out/share/kanboard

      # Create the plugins directory if it does not exist.
      mkdir -p $out/share/kanboard/plugins/ThemeRevision

      # Unpack ThemeRevision into the plugins folder.
      cp -rv ${themeRevision}/* $out/share/kanboard/plugins/ThemeRevision

      runHook postInstall
    '';
  });
in
{
  # kanboard
  services.kanboard = {
    enable = true;
    package = kanboardWithTheme;
    domain = "kb.example.com";
    dataDir = "/mnt/brtfs_pool/kanboard";
    nginx = { };
  };
}
