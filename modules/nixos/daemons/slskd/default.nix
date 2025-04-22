{
  inputs,
  outputs,
  config,
  pkgs,
  allSecrets,
  ...
}: {
  imports = [
    ../vpnconfinement
  ];

  vpnNamespaces.prsl = {
    portMappings = [
      {
        from = 5030;
        to = 5030;
      }
    ];
  };

  age.secrets."slskd_env" = {
    rekeyFile = "${inputs.self}/secrets/slskd_env.age";
  };

  services.slskd = {
    enable = true;
    environmentFile = config.age.secrets."slskd_env".path;
    domain = null;
    settings = {
      web.authentication.api_keys = {
        "tubifarry" = {
          key = "${allSecrets.per_service.slskd.api_key}";
          role = "readwrite";
          cidr = "0.0.0.0/0,::/0";
        };
      };
      soulseek = {
        diagnostic_level = "Info";
        # listen_port = 50300; # has to be dynamic. to whatever i get
      };
      global.upload.slots = 5;
      directories = {
        downloads = "/mnt/btrfs_pool/soulseek/download";
        incomplete = "/mnt/btrfs_pool/soulseek/incomplete";
      };
      shares.directories = [
        "/mnt/btrfs_pool/plex_media/Music/"
      ];
      web.logging = true;
      rooms = [
        "The Lobby"
        "indie"
        "japanese music"
        "nicotine"
      ];
    };
  };

  systemd.services.slskd.vpnconfinement = {
    enable = true;
    vpnnamespace = "prsl";
  };
}
