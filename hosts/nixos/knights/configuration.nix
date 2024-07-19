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
    hostName = "knights"; # Define your hostname.
    networkmanager.enable = true;
    firewall.allowedUDPPorts = [ 22 51820 ];
    firewall.allowedTCPPorts = [ 22 25 80 143 443 465 587 993 4190 ];
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.2/24" ];
        listenPort = 51820;
        privateKeyFile = "/home/taki/wg_knights_private_key_secrets";
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
    # nat = {
    #   enable = true;
    #   externalInterface = "ens3";
    #   internalInterfaces = [ "wg0" ];
    #   forwardPorts = [
    #     { destination = "10.100.0.1:25"; sourcePort = 25; } # SMTP
    #     { destination = "10.100.0.1:143"; sourcePort = 143; } # IMAP
    #     { destination = "10.100.0.1:110"; sourcePort = 110; } # POP3
    #   ];
    # };
  };

  programs.zsh.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    git wget curl tmux
    neofetch
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
        "ip.74k1.sh" = {
          locations."/" = {
            return = "200 $remote_addr\n";
            extraConfig = ''
              default_type text/plain;
            '';
          };
        };
        "example.com" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/example.com/";
        };
        "vw.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "10.100.0.1:8222";
        };
        "td.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:3456";
            extraConfig = ''
              client_max_body_size 20M;
            '';
          };
        };
        # "mc.example.com" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:8123";
        #   };
        # };
        # "ls.example.com" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:5544";
        #   };
        # };
        "git.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://10.100.0.1:3000";
        };
        "files.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://10.100.0.1:80";
              extraConfig = ''
                client_max_body_size 100G;
                client_body_buffer_size 400M;
              '';
            };
          #"/.well-known/carddav" = {
          #    return = "301 $scheme://$host$remote.php/dav";
          #  };
          #"/.well-known/caldav" = {
          #    return = "301 $scheme://$host$remote.php/dav";
          #  };
          };
        };
        # "n8n.example.com" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:5678"
        #   };
        # };
        "wiki.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:3030";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
        "forever.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:3010";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
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

