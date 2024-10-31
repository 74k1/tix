{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = with outputs.nixosModules; [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    locale
    nix
    taki
  ];

  # nixpkgs.overlays = [
  #   (_prev: _final: {
  #     octoprint = inputs.nixpkgs-master.legacyPackages.${pkgs.hostPlatform.system}.octoprint;
  #   })
  # ];

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
    libraspberrypi
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

    fluidd = {
      enable = true;
      hostName = "octo";
      nginx.locations."/webcam".proxyPass = "http://127.0.0.1:8080/stream";
    };

    nginx.clientMaxBodySize = "1000m";

    moonraker = {
      enable = true;
      address = "0.0.0.0";
      allowSystemControl = true;
      settings = {
        authorization = {
          force_logins = true;
          trusted_clients = [
            "10.0.0.0/8"
            "127.0.0.0/8"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "FE80::/10"
            "::1/128"
          ];
          cors_domains = [
            "*.local"
            "*.lan"
            "*://localhost"
            "*://app.fluidd.xyz"
          ];
        };

        octoprint_compat = {};

        history = {};

        update_manager = {
          enable_auto_refresh = true;
        };

        "update_manager fluidd" = {
          type = "web";
          repo = "fluidd-core/fluidd";
          path = "/var/lib/fluidd";
        };
      };
    };

    klipper = {
      enable = true;
      inherit (config.services.moonraker) user group;
      firmwares.mcu = {
        enable = true;
        configFile = ./config;
        serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
      };
      mutableConfig = true;
      mutableConfigFolder = config.services.moonraker.stateDir + "/config";
      configFile = ./printer.cfg;
    };
    
    # octoprint = {
    #   enable = true;
    #   openFirewall = true; # 5000
    #   plugins = plugins: with plugins; [
    #     dashboard
    #     firmwareupdater
    #     bedlevelvisualizer
    #     fullscreen
    #     # smartpreheat
    #     # camerasettings
    #     # PrintTimeGenius
    #     simpleemergencystop
    #     themeify
    #     # uicustomizer
    #     stlviewer
    #   ];
    # };
  };
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 7125 ];
  networking.firewall.allowedUDPPorts = [ 80 7125 ];
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

