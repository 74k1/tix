{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}: {
  age.secrets = {
    "knights_wireguard_private_key" = {
      rekeyFile = "${inputs.self}/secrets/knights_wireguard_private_key.age";
    };
    "namecheap_api_secrets" = {
      rekeyFile = "${inputs.self}/secrets/namecheap_api_secrets.age";
    };
  };

  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    # fail2ban
    crowdsec-bouncer
    vector

    anubis

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
      # ../../../secrets/identities/yubikey-1-on-person.pub
      "${inputs.self}/secrets/identities/yubikey-1-on-person.pub"
      # ../../../secrets/identities/yubikey-2-at-home.pub
      "${inputs.self}/secrets/identities/yubikey-2-at-home.pub"
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
    firewall = {
      enable = true;
      allowedUDPPorts = [80 443 2202 2277 51820];
      allowedTCPPorts = [80 443 2202 2277 51820 22]; # Added port 22 for Forgejo SSH
    };
    wireguard.interfaces = {
      wg0 = {
        ips = ["10.100.0.2/24"];
        listenPort = 51820;
        privateKeyFile = config.age.secrets."knights_wireguard_private_key".path;
        peers = [
          {
            publicKey = "vnmW4+i/tKuiUx86JGOax3wHl1eAPwZj+/diVkpiZgM=";
            allowedIPs = ["10.100.0.1"];
            endpoint = "${allSecrets.global.pub_ip}:51820";
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
    git
    wget
    curl
    tmux
    fastfetch
  ];

  users.users."cert_sync" = {
    isNormalUser = true;
    description = "only used for syncing certs";
    shell = pkgs.bashInteractive;
    extraGroups = ["nginx"];
    openssh.authorizedKeys.keys = [
      allSecrets.per_host.eiri.ssh_pub
    ];
  };

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
      ports = [2202];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    crowdsec-firewall-bouncer = {
      settings = {
        api.server = {
          api_key = "${allSecrets.per_host.knights.crowdsec.api_key}";
        };
      };
    };

    anubis.instances = {
      forgejo.settings = {
        TARGET = "http://10.100.0.1:3000";
        BIND = ":60001";
        BIND_NETWORK = "tcp";
        # METRICS_BIND = "0.0.0.0:20023";
        # METRICS_BIND_NETWORK = "tcp";
      };
      chat.settings = {
        TARGET = "http://10.100.0.1:3335";
        BIND = ":60002";
        BIND_NETWORK = "tcp";
        # METRICS_BIND = "0.0.0.0:20023";
        # METRICS_BIND_NETWORK = "tcp";
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      commonHttpConfig = ''
        log_format graylog_json escape=json '{ "nginx_timestamp": "$time_iso8601", '
          '"remote_addr": "$remote_addr", '
          '"connection": "$connection", '
          '"connection_requests": $connection_requests, '
          '"pipe": "$pipe", '
          '"body_bytes_sent": $body_bytes_sent, '
          '"request_length": $request_length, '
          '"request_time": $request_time, '
          '"response_status": $status, '
          '"request": "$request", '
          '"request_method": "$request_method", '
          '"host": "$host", '
          '"upstream_cache_status": "$upstream_cache_status", '
          '"upstream_addr": "$upstream_addr", '
          '"http_x_forwarded_for": "$http_x_forwarded_for", '
          '"http_referrer": "$http_referer", '
          '"http_user_agent": "$http_user_agent", '
          '"http_version": "$server_protocol", '
          '"remote_user": "$remote_user", '
          '"http_x_forwarded_proto": "$http_x_forwarded_proto", '
          '"upstream_response_time": "$upstream_response_time", '
          '"nginx_access": true }';

        access_log syslog:server=127.0.0.1:9000 graylog_json;

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
      '';

      # Configure SSH forwarding for Forgejo
      streamConfig = ''
        upstream git-ssh {
          server 10.100.0.1:2277;
        }

        server {
          listen 22;
          proxy_protocol on;
          proxy_pass git-ssh;
        }
      '';

      virtualHosts = let
        inherit (allSecrets.global) domain00 domain0;
      in {
        "it.74k1.sh" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:80"; # nginx based on url
          };
        };
        # "send.74k1.sh" = {
        #   addSSL = true;
        #   enableACME = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:1444";
        #     proxyWebsockets = true;
        #   };
        # };
        "umami.74k1.sh" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:3034";
          };
        };
        "${domain00}" = {
          addSSL = true;
          useACMEHost = "${allSecrets.global.domain00}";
          # enableACME = true;
          root = "/var/www/${domain00}/";
        };
        "auth.${domain00}" = {
          addSSL = true;
          useACMEHost = "${allSecrets.global.domain00}";
          # enableACME = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:1411";
            # proxyWebsockets = true;
            # recommendedProxySettings = true;
            extraConfig = ''
              # proxy_set_header Host $host;
              # proxy_set_header X-Real-IP $remote_addr;
              # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              # proxy_set_header X-Forwarded-Proto $scheme;

              proxy_busy_buffers_size   512k;
              proxy_buffers   4 512k;
              proxy_buffer_size   256k;
            '';
          };
        };
        # "vw.${domain00}" = {
        #   addSSL = true;
        #   useACMEHost = "${allSecrets.global.domain00}";
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:8222";
        #     proxyWebsockets = true;
        #   };
        # };
        # "git.${domain00}" = {
        #   addSSL = true;
        #   useACMEHost = "${allSecrets.global.domain00}";
        #   locations."/" = {
        #     proxyPass = "http://127.0.0.1${toString config.services.anubis.instances.forgejo.settings.BIND}";
        #     recommendedProxySettings = true;
        #     proxyWebsockets = true;
        #     extraConfig = ''
        #       client_max_body_size 0;
        #     '';
        #   };
        # };
        # "news.${domain00}" = {
        #   addSSL = true;
        #   useACMEHost = "${allSecrets.global.domain00}";
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:8084";
        #   };
        # };
        # Opencloud!
        # "files.${domain00}" = {
        #   addSSL = true;
        #   useACMEHost = "${allSecrets.global.domain00}";
        #   locations = {
        #     "/" = {
        #       proxyPass = "http://10.100.0.1:80";
        #       extraConfig = ''
        #         client_max_body_size 100G;
        #         client_body_buffer_size 400M;
        #       '';
        #     };
        #     # "/.well-known/carddav" = {
        #     #   return = "301 $scheme://$host$remote.php/dav";
        #     # };
        #     # "/.well-known/caldav" = {
        #     #   return = "301 $scheme://$host$remote.php/dav";
        #     # };
        #   };
        # };
        # change mum n sister
        # "immich.${domain00}" = {
        #   addSSL = true;
        #   useACMEHost = "${allSecrets.global.domain00}";
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:3001";
        #     # see https://immich.app/docs/administration/reverse-proxy/
        #     extraConfig = ''
        #       client_max_body_size 50G;
        #       proxy_set_header Host $host;
        #       proxy_set_header X-Real-IP $remote_addr;
        #       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #       proxy_set_header X-Forwarded-Proto $scheme;
        #
        #       proxy_http_version 1.1;
        #       proxy_set_header Upgrade $http_upgrade;
        #       proxy_set_header Connection "upgrade";
        #
        #       proxy_read_timeout 43200s;
        #       proxy_send_timeout 43200s;
        #       send_timeout 43200s;
        #     '';
        #   };
        # };
        # should perhaps run on chatai.74k1.sh as well
        # "chat.${domain00}" = {
        #   addSSL = true;
        #   useACMEHost = "${allSecrets.global.domain00}";
        #   locations."/" = {
        #     proxyPass = "http://127.0.0.1${toString config.services.anubis.instances.chat.settings.BIND}";
        #     proxyWebsockets = true;
        #   };
        # };
        "${domain0}" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/${domain0}/";
        };
        "vw.${domain0}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:8222";
            proxyWebsockets = true;
          };
        };
        "git.${domain0}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1${toString config.services.anubis.instances.forgejo.settings.BIND}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 0;
            '';
          };
        };
        "news.${domain0}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://10.100.0.1:8084";
          };
        };
        "files.${domain0}" = {
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
        "immich.${domain0}" = {
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
        # "n8n.${domain0}" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   locations."/" = {
        #     proxyPass = "http://10.100.0.1:5678"
        #   };
        # };
        "chatai.${allSecrets.global.domain01}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1${toString config.services.anubis.instances.chat.settings.BIND}";
            proxyWebsockets = true;
          };
        };
        # catch-all for domain00
        "*.${allSecrets.global.domain00}" = {
          forceSSL = true;
          useACMEHost = "${allSecrets.global.domain00}";
          locations."/" = {
            return = "444"; # Close connection without response
          };
        };
      };
    };
  };


  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "${allSecrets.global.mail.acme}";
      group = "nginx";
    };
    certs = let 
      inherit (allSecrets.global) domain00;
    in {
      "${domain00}" = {
        domain = "${domain00}";
        dnsProvider = "namecheap";
        dnsPropagationCheck = true;
        environmentFile = config.age.secrets."namecheap_api_secrets".path;
        extraDomainNames = [
          "*.${domain00}"
        ];
        webroot = null;
      };
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
