{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../vpnconfinement
  ];

  vpnNamespaces.proton = {
    portMappings = [
      {
        from = 5030;
        to = 5030;
      }
    ];
    openVPNPorts = [
      {
        port = 50300;
        protocol = "both";
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
      soulseek = {
        diagnostic_level = "Info";
        listen_port = 50300; # has to be dynamic. to whatever i get
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
    vpnnamespace = "proton";
  };

  # systemd.services.slskd-proton-port-forward = {
  #   description = "ProtonVPN Port Forwarding for Slskd";
  #   after = ["network-online.target" "proton.service" "slskd.service"];
  #   requires = ["proton.service" "slskd.service"];
  #   wantedBy = ["multi-user.target"];
  #
  #   vpnconfinement = {
  #     enable = true;
  #     vpnnamespace = "proton";
  #   };
  #
  #   script = ''
  #     while true; do
  #       ${pkgs.libnatpmp}/bin/natpmpc -g 10.2.0.1 -a 50300 0 tcp 60
  #       ${pkgs.libnatpmp}/bin/natpmpc -g 10.2.0.1 -a 50300 0 udp 60
  #       sleep 45
  #     done
  #   '';
  # };
}
