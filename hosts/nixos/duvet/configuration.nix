{ inputs, outputs, config, lib, pkgs, ... }:
{
  # See [NixOS on Hetzner Cloud Wiki](https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud)

  imports = with outputs.nixosModules; [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      locale
      nix
      taki
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4"];

  documentation.nixos.enable = false;

  networking = {
    hostName = "duvet"; # Define your hostname.
    networkmanager.enable = true;
    firewall.allowedUDPPorts = [ 22 ];
    firewall.allowedTCPPorts = [ 22 ];
    # wireguard.interfaces = {
    #   wg0 = {
    #     ips = [ "10.100.0.2/24" ];
    #     listenPort = 51820;
    #     privateKeyFile = "/home/taki/wg_knights_private_key_secrets";
    #     peers = [
    #       {
    #         publicKey = "vnmW4+i/tKuiUx86JGOax3wHl1eAPwZj+/diVkpiZgM=";
    #         allowedIPs = [ "10.100.0.1" ];
    #         endpoint = "example.com:51820";
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
  };

  programs.zsh.enable = true;
  
  environment.systemPackages = with pkgs; [
    btop
    git wget curl tmux unzip zip
    fastfetch
  ];

  services = {
    # fail2ban = {
    #   enable = true;
    #   maxretry = 3;
    #   ignoreIP = [
    #     "10.0.0.0/8"
    #   ];
    #   bantime = "24h";
    #   bantime-increment = {
    #     enable = true;
    #     # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
    #     multipliers = "1 2 4 8 16 32 64 128";
    #     overalljails = true;
    #   };
    #   jails = {
    #     nginx-http-auth.settings = { enabled = true; };
    #     nginx-botsearch.settings = { enabled = true; };
    #     nginx-bad-request.settings = { enabled = true; };
    #   };
    # };

    openssh = {
      enable = true;
      ports = [ 2202 ];
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "boss@example.com";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

