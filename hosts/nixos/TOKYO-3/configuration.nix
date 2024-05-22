{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    inputs.nixos-generators.nixosModules.all-formats

    vm-test
    authelia
    locale
    nix
    fail2ban
    taki
    nextcloud
    couchdb
    forgejo
    nvidia
    # n8n
    # vaultwarden
    outline
    mailserver
    servarr
    plex
    vikunja
    wireguard
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  networking = {
    hostName = "TOKYO-3"; # Define your hostname.
    networkmanager.enable = true;

    # wg-quick.interfaces = {
    #   wg1 = {
    #     address = [ "10.65.87.4/32" "fc00:bbbb:bbbb:bb01::2:5703/128" ];
    #     privateKeyFile = "/home/taki/mullvad_private_key_secret";
    #     dns = [ "10.64.0.1" ];
    #     peers = [
    #       {
    #         publicKey = "5Ms10UxGjCSzwImTrvEjcygsWY8AfMIdYyRvgFuTqH8=";
    #         allowedIPs = [ "0.0.0.0/0" "::0/0" ];
    #         endpoint = "193.32.127.68:51820";
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };

  };

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVrGnNjwaQ8CL4IBKWx0Z3A+PFpy96r0t8e2zc7jRr+ TOKYO-3";
    # The path to the master identity used for decryption. See the option's description for more information.
    masterIdentities = [
      ./secrets/yubikey-1-on-person.pub
      ./secrets/yubikey-2-at-home.pub
    ];
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.agenix-rekey.packages.x86_64-linux.default
    btop
    docker-compose
    git wget curl tmux
    neofetch
    ntfs3g btrfs-progs
    rage
    age-plugin-yubikey
    cifs-utils
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
      };
    };

    samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        security = user
        hosts allow = 192.168.1. 10.100.0. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
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
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  fileSystems."/var/plex" = {
    device = "//255.255.255.255/share/plex";
    fsType = "cifs";
    options = [
      "credentials=/home/taki/cifs_secrets"
      "iocharset=utf8"
      "vers=3.0"
      "noperm"
      "uid=0"
    ];
  };

  fileSystems."/mnt/btrfs_pool" = {
    device = "/dev/sda";
    fsType = "btrfs";
    options = [ "defaults" "noatime" "compress=zstd" "autodefrag" ];
  };

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  #networking.firewall.allowedUDPPorts = [ 22 80 443 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Docker
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
