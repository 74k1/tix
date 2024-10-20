{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = with outputs.nixosModules; [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    locale
    nix
    taki
  ];

  nixpkgs.overlays = [
    (_prev: _final: {
      octoprint = inputs.nixpkgs-master.legacyPackages.${pkgs.hostPlatform.system}.octoprint;
    })
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  documentation.nixos.enable = false;

  networking = {
    hostName = "octo"; # Define your hostname.
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    ouch
    git wget curl tmux
    fastfetch
    inputs.nixpkgs-master.legacyPackages.${pkgs.hostPlatform.system}.octoprint
  ];

  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    octoprint = {
      enable = true;
      openFirewall = true; # 5000
      # plugins = plugins: with plugins; [
      #   octoprint-dashboard
      #   # octoprint-firmwareupdater
      #   # octoprint-bedlevelvisualizer
      #   # octoprint-preheat
      #   # octoprint-fullscreen
      #   # octoprint-camerasettings
      #   # octoprint-printtimegenius
      #   # simpleemergencystop
      #   themeify
      #   # octoprint-uicustomizer
      #   stlviewer
      # ];
    };
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

