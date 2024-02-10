{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = with outputs.nixosModules; [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      locale
      nix
      taki
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking = {
    hostName = "SERN"; # Define your hostname.
    networkmanager.enable = true;
    firewall.allowedUDPPorts = [ 22 51820 ];
    firewall.allowedTCPPorts = [ 22 80 443 3456 ];
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.2/24" ];
        listenPort = 51820;
        privateKeyFile = "/home/taki/wg_SERN_private_key_secrets";
        peers = [
          {
            publicKey = "vnmW4+i/tKuiUx86JGOax3wHl1eAPwZj+/diVkpiZgM=";
            allowedIPs = [ "10.100.0.1" ];
            endpoint = "example.com:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  programs.zsh.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    git wget curl tmux
    neofetch
    ntfs3g
  ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "yes";
      };
    };
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "example.com" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/example.com/";
        };
        "td.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:80";
          };
        };
        "ls.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:5544";
          };
        };
        # "n8n.example.com" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:5678"
        #   };
        # };
        # "wiki.example.com" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:3030";
        #   };
        # };
        "auth.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:9091";
          };
        };
        # "td.example.com-3456" = {
        #   listen = [{ addr = "0.0.0.0"; port = 3456; }];
        #   serverAliases = [ "td.example.com" ];
        #   forceSSL = false;
        #   enableACME = false;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:3456";
        #     proxyWebsockets = true;
        #   };
        # };
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
  system.stateVersion = "23.11"; # Did you read the comment?

}

