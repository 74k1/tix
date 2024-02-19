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
    firewall.allowedTCPPorts = [ 22 80 443 465 993 ];
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
    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
      forwardPorts = [
        { destination = "10.100.0.1:25"; sourcePort = 25; } # SMTP
        { destination = "10.100.0.1:143"; sourcePort = 143; } # IMAP
        { destination = "10.100.0.1:110"; sourcePort = 110; } # POP3
      ];
    };
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
        #     extraConfig = ''
        #       include /etc/nginx/proxy_params;
        #       proxy_set_header X-Forwarded-User $remote_user;
        #       
        #       auth_request https://auth.example.com/api/verify;
        #       auth_request_set $target_url $scheme://$http_host$request_uri;
        #       auth_request_set $user $upstream_http_remote_user;
        #       proxy_set_header X-Forwarded-User $user;
        #       error_page 401 =302 https://auth.example.com/?rd=$target_url;
        #     '';
        #   };
        # };
        # "auth.example.com" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:9091";
        #     proxyWebsockets = true;
        #     extraConfig = ''
        #       proxy_set_header Host $host;
        #       proxy_set_header X-Real-IP $remote_addr;
        #       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #       proxy_set_header X-Forwarded-Proto $scheme;
        #     '';
        #   };
        # };
        # "mail.example.com-465" = {
        #   listen = [{ addr = "0.0.0.0"; port = 465; ssl = true; }];
        #   serverAliases = [ "mail.example.com" ];
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:465";
        #     proxyWebsockets = true;
        #   };
        # };
        # "mail.example.com-993" = {
        #   listen = [{ addr = "0.0.0.0"; port = 993; ssl = true; }];
        #   serverAliases = [ "mail.example.com" ];
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:143";
        #     proxyWebsockets = true;
        #   };
        # };
        # "mail.example.com-995" = {
        #   listen = [{ addr = "0.0.0.0"; port = 995; ssl = true; }];
        #   serverAliases = [ "mail.example.com" ];
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:110";
        #     proxyWebsockets = true;
        #   };
        # };
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

