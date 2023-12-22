{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    vm-test
    locale
    nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "TOKYO-3"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.taki = {
    isNormalUser = true;
    description = "taki";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhjipcpqKCIRFK3o5QqqjGteAFEJdabnZqgraK2n8pa taki@NERV"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    # agenix-rekey
    btop
    docker-compose
    git wget curl tmux
    neofetch
    ntfs3g
    rage
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

    ## Gitea
    gitea = {
      enable = true;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 22 80 443 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


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
