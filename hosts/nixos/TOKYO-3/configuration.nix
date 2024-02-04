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
    taki
    gitea
    nvidia
    n8n
    # vaultwarden
    outline
    plex
    vikunja
    wireguard
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "TOKYO-3"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

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
    ntfs3g
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
