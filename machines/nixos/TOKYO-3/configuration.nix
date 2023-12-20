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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhjipcpqKCIRFK3o5QqqjGteAFEJdabnZqgraK2n8pa taki@NERV"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g
    git wget curl tmux
    neofetch
  ];

  # Services

  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "yes";
      };
    };
    sourcehut = {
      enable = true;
      nginx.enable = true;
      postgresql.enable = true;
      redis.enable = true;

      meta.enable = true;
      git.enable = false;
      
      settings = {
        "git.sr.ht" = {
          oauth-client-id = "d07cb713d920702e";
          oauth-client-secret = pkgs.writeText "gitsrht-oauth-client-secret" "3597288dc2c716e567db5384f493b09d";
        };
      };
    };
    postgresql = {
      enable = true;
      enableTCPIP = false;
      settings.unix_socket_permissions = "0770";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 22 80 443 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
