{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
{
  # age.secrets."miniflux_admin" = {
  #   rekeyFile = "${inputs.self}/secrets/miniflux_admin.age";
  #   # mode = "770";
  #   # owner = "nextcloud";
  #   # group = "nextcloud";
  # };

  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/btrfs_pool/plex_media/Music";
      dataDir = "/var/lib/navidrome";
      EnableSharing = true;
      CoverJpegQuality = 100;
      EnableUserEditing = true;
      ScanExclude = [ "lost+found" ];
      # LastFM = {
      #   Enabled = true;
      #   ApiKey = "LASTFMKEY";
      #   Secret = "LASTFM SECRET";
      #   Language = "en";
      # };
    };
  };
}
