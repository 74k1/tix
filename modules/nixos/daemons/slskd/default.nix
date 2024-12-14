{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {

  imports = [
    "../vpnconfinement/default.nix"
  ];

  age.secrets."slskd_env" = {
    rekeyFile = "${inputs.self}/secrets/slskd_env.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

  services.slskd = {
    enable = true;
    environmentFile = config.age.secrets."slskd_env".path;
    settings = {
      directories.downloads = "/mnt/btrfs_pool/soulseek/download";
      shares.directories = [
        "/mnt/btrfs_pool/plex/Music/"
      ];
      web.logging = true;
      flags.no_logo = true;
    };
  };

  systemd.services.slskd.vpnconfinement = {
    enable = true;
    vpnnamespace = "mu";
  };
}
