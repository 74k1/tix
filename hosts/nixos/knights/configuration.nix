{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."knights_wireguard_private_key" = {
    rekeyFile = "${inputs.self}/secrets/knights_wireguard_private_key.age";
  };
  
  imports = with outputs.nixosModules; [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    locale
    nix
    taki
];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  documentation.nixos.enable = false;

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    # use strictly `ssh-keyscan <remote ip>` from host
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJp2WfgRJJHY6FF48vdSr2ZsTcvJqYTrewLNNeEB0Ps knights";
    # The path to the master identity used for decryption. See the option's description for more information.
    masterIdentities = [
      # ../../../secrets/yubikey-1-on-person.pub
      "${inputs.self}/secrets/yubikey-1-on-person.pub"
      # ../../../secrets/yubikey-2-at-home.pub
      "${inputs.self}/secrets/yubikey-2-at-home.pub"
    ];
    storageMode = "local";
    # Choose a dir to store the rekeyed secrets for this host.
    # This cannot be shared with other hosts. Please refer to this path
    # from your flake's root directory and not by a direct path literal like ./secrets
    localStorageDir = "${inputs.self}/secrets/rekeyed/${config.networking.hostName}";
  };

  networking = {
    hostName = "knights"; # Define your hostname.
    networkmanager.enable = true;
    # firewall = {
    #   enable = true;
    #   allowedUDPPorts = [ 80 443 2202 51820 ];
    #   allowedTCPPorts = [ 80 443 2202 51820 ];
    # };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.2/24" ];
        listenPort = 51820;
        privateKeyFile = config.age.secrets."knights_wireguard_private_key".path;
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
    ouch
    git wget curl tmux
    fastfetch
  ];

  services = {
    fail2ban = {
      enable = true;
      maxretry = 3;
      ignoreIP = [
        "10.0.0.0/8"
      ];
      bantime = "24h";
      bantime-increment = {
        enable = true;
        # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64 128";
        overalljails = true;
      };
      jails = {
        nginx-http-auth.settings = { enabled = true; };
        nginx-botsearch.settings = { enabled = true; };
        nginx-bad-request.settings = { enabled = true; };
      };
    };

    openssh = {
      enable = true;
      ports = [ 2202 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      config = ''
        proxy_headers_hash_max_size 512;
      '';
      
      # streamConfig = ''
      #   upstream git_server {
      #     server 10.0.0.1:727;
      #   }
      #   server {
      #     listen 22;
      #     proxy_pass git_server;
      #   }
      # '';
      virtualHosts = {
        "example.com" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/example.com/";
        };
        "vw.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:8222";
            proxyWebsockets = true;
          };
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
          locations."/" = {
            proxyPass = "http://10.100.0.1:3000";
            extraConfig = ''
              client_max_body_size 0;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_http_version 1.1;
              proxy_set_header Connection "";
              proxy_buffering off;
              proxy_read_timeout 36000s;
              proxy_redirect off;
            '';
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
            # "/.well-known/carddav" = {
            #   return = "301 $scheme://$host$remote.php/dav";
            # };
            # "/.well-known/caldav" = {
            #   return = "301 $scheme://$host$remote.php/dav";
            # };
          };
        };
        "immich.example.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:3001";
            # see https://immich.app/docs/administration/reverse-proxy/
            extraConfig = ''
              client_max_body_size 50G;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;

              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";

              proxy_read_timeout 43200s;
              proxy_send_timeout 43200s;
              send_timeout 43200s;
            '';
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
    defaults.email = "mail@example.com";
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

