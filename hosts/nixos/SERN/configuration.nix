{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = with outputs.nixosModules; [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      locale
      nix
      taki
      
      # mailserver
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking = {
    hostName = "SERN"; # Define your hostname.
    networkmanager.enable = true;
    firewall.allowedUDPPorts = [ 22 51820 ];
    firewall.allowedTCPPorts = [ 22 25 80 143 443 465 587 993 4190 ];
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
    
    # traefik = {
    #   enable = true;
    #   staticConfigOptions = {
    #     entryPoints = {
    #       mail.address = [ ":25" ":143" ":465" ":587" ":993" ":4190" ];

    #       tcp.routers = {
    #         "mail.example.com" = {
    #           entryPoints = [ "mail" ];
    #           rule = "HostSNI(mail.example.com)";
    #           service = "mail-service@internal";
    #         };
    #       };

    #       services = {
    #         "mail-service@internal" = {
    #           loadBalancers = { roundrobin = {}; };
    #           servers = [
    #             { address = "10.100.0.1:25"; }
    #             { address = "10.100.0.1:143"; }
    #             { address = "10.100.0.1:465"; }
    #             { address = "10.100.0.1:587"; }
    #             { address = "10.100.0.1:993"; }
    #             { address = "10.100.0.1:4190"; }
    #           ];
    #         };
    #       };
    #     };
    #   };
    # };

    # haproxy = {
    #   enable = true;
    #   config = ''
    #     defaults
    #       option tcplog
    #       timeout client 30s
    #       timeout connect 5s
    #       timeout server 30s

    #     frontend imap_front
    #       bind *:143
    #       option tcplog
    #       default_backend imap_back

    #     frontend imaptls_front
    #       bind *:993
    #       option tcplog
    #       default_backend imaptls_back

    #     frontend sieve_front
    #       bind *:4190
    #       option tcplog
    #       default_backend sieve_back

    #     frontend smtp_front
    #       bind *:25
    #       option tcplog
    #       default_backend smtp_back

    #     frontend submission_front
    #       bind *:587
    #       option tcplog
    #       default_backend submission_back

    #     frontend submissions_front
    #       bind *:465
    #       option tcplog
    #       default_backend submissions_back

    #     backend imap_back
    #       mode tcp
    #       option ssl-hello-chk
    #       server imap_server 10.100.0.1:143 weight 1 check
    #     
    #     backend imaptls_back
    #       mode tcp
    #       option ssl-hello-chk
    #       server imaptls_server 10.100.0.1:993 weight 1 check ssl verify none

    #     backend sieve_back
    #       mode tcp
    #       option ssl-hello-chk
    #       server sieve_server 10.100.0.1:4190 weight 1 check

    #     backend smtp_back
    #       mode tcp
    #       option ssl-hello-chk
    #       server smtp_server 10.100.0.1:25 weight 1 check

    #     backend submission_back
    #       mode tcp
    #       option ssl-hello-chk
    #       server submission_server 10.100.0.1:587 weight 1 check
    #     
    #     backend submissions_back
    #       mode tcp
    #       option ssl-hello-chk
    #       server submissions_server 10.100.0.1:465 weight 1 check ssl verify none
    #   '';
    # };

    nginx = {
      enable = true;
      # package = pkgs.nginx.override { withMail = true; };
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      # config = ''
      #   mail {
      #     server_name mail.example.com;
      #     auth_http localhost:9000/cgi-bin/auth;

      #     proxy on;

      #     imap_capabilities "IMAP4rev1" "UIDPLUS"; ##default

      #     server {
      #       listen 25;
      #       protocol smtp;
      #       smtp_auth none;
      #     }
      #     server {
      #       listen 465;
      #       protocol smtp;
      #       smtp_auth none;
      #     }
      #     server {
      #       listen 587;
      #       protocol smtp;
      #       smtp_auth none;
      #     }
      #     server {
      #       listen 143;
      #       protocol imap;
      #       imap_auth none;
      #     }
      #     server {
      #       listen 993;
      #       protocol imap;
      #       imap_auth none;
      #     }
      #     # server {
      #     #   listen 110;
      #     #   protocol pop3;
      #     # }
      #     # server {
      #     #   listen 995;
      #     #   protocol pop3;
      #     # }
      #   }
      # '';
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
            proxyPass = "http://10.100.0.1:3456";
            extraConfig = ''
              client_max_body_size 20M;
            '';
          };
        };
        "mc.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:8123";
          };
        };
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
          locations = {
            "/".proxyPass = "http://10.100.0.1:3000";
          };
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

