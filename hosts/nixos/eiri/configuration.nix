{ inputs, outputs, lib, config, pkgs, ... }:
{
  age.secrets = {
    "cifs_secret" = {
      rekeyFile = "${inputs.self}/secrets/cifs_secret.age";
      mode = "770";
      # owner = "";
      # group = "";
    };

    # "librechat_env_secret" = {
    #   rekeyFile = "${inputs.self}/secrets/librechat_env_secret.age";
    #   mode = "770";
    # };
  };
  
  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    inputs.arion.nixosModules.arion
    inputs.vpnconfinement.nixosModules.default
    inputs.nixos-generators.nixosModules.all-formats

    restic

    scrutiny

    # n8n
    vaultwarden
    audiobookshelf
    paperless
    # commafeed
    miniflux
    affine
    docmost
    arion
    # couchdb
    fail2ban
    forgejo
    immich
    locale
    
    # ollama
    # librechat

    glance
    nextcloud
    nix
    nvidia
    syncthing
    # atuin
    outline
    plex
    # send
    servarr
    taki
    transmission
    slskd
    vikunja
    kanboard
    linkwarden
    # filestash
    # youtrack
    vm-test
    wireguard
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 512;
    "fs.inotify.max_user_watches" = 1048576;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  networking = {
    hostName = "eiri"; # Define your hostname.
    networkmanager.enable = true;
  };

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    # use strictly `ssh-keyscan <remote ip>` from host
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNn2DDUnITFao47ugOzCxufnXkblnWXfFwaPfNu/JLm eiri";
    # The path to the master identity used for decryption. See the option's description for more information.
    masterIdentities = [
      # ../../../secrets/yubikey-1-on-person.pub
      "${inputs.self}/secrets/yubikey-1-on-person.pub"
      # ../../../secrets/yubikey-2-at-home.pub
      "${inputs.self}/secrets/yubikey-2-at-home.pub"
    ];
    storageMode = "local";
    # Choose a dir to store the rekeyed secrets for this host.
    # This cannot be shared with other hosts. Please refer to this path
    # from your flake's root directory and not by a direct path literal like ./secrets
    localStorageDir = "${inputs.self}/secrets/rekeyed/${config.networking.hostName}";
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    tmux
    ntfs3g
    btrfs-progs
    cifs-utils
    rage
    age-plugin-yubikey
    inputs.agenix-rekey.packages.x86_64-linux.default
    restic

    btop
    docker-compose
    fastfetch
    jdk17
  ];

  # Services

  services = {
    ## OpenSSH
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "yes";
        UsePAM = true;
      };
    };

    # librechat = {
    #   enable = true;
    #   # port = 3080;
    #   # environmentFile = config.age.secrets."librechat_env_secret".path;
    #   user = "librechat";
    #   group = "librechat";
    #   mongodbDatabase = "librechat";
    #   stateDir = "/var/lib/librechat";
    # };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "hosts allow" = "192.168.1. 10.100.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "plex_media" = {
          path = "/mnt/btrfs_pool/plex_media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "plex";
          "force group" = "plex";
        };
        "torrents" = {
          path = "/mnt/btrfs_pool/torrents";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "transmission";
          "force group" = "transmission";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  fileSystems = {
    "/mnt/btrfs_pool" = {
      device = "UUID=9ce8e79d-aa13-4f76-981f-c438eb821669";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" "autodefrag" ];
    };
    "/mnt/koi" = {
      device = "255.255.255.255:/volume1/backup";
      fsType = "nfs";
      options = [
        "rw"
        "noatime"
        "nfsvers=4.1"
        "x-systemd.automount" # auto mount on use
        "x-systemd.idle-timeout=3600" # disconnect after 60 minutes
        "noauto" # auto mount on use
        "nofail"
        "_netdev"
      ];
    };
  };

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  #networking.firewall.allowedUDPPorts = [ 22 80 443 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
