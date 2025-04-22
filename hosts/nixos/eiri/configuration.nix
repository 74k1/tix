{ inputs, outputs, lib, config, pkgs, allSecrets, ... }:
{
  age.secrets = {
    # "cifs_secret" = {
    #   rekeyFile = "${inputs.self}/secrets/cifs_secret.age";
    #   mode = "770";
    #   # owner = "";
    #   # group = "";
    # };

    "namecheap_api_secrets" = {
      rekeyFile = "${inputs.self}/secrets/namecheap_api_secrets.age";
    };

    # "librechat_env_secret" = {
    #   rekeyFile = "${inputs.self}/secrets/librechat_env_secret.age";
    #   mode = "770";
    # };
  };
  
  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    # inputs.quadlet.nixosModules.quadlet
    inputs.vpnconfinement.nixosModules.default
    inputs.nixos-generators.nixosModules.all-formats

    # Most important
    restic
    # kanidm-server
    # kanidm-client
    vaultwarden

    # Mid importance
    graylog

    # everything else
    crowdsec
    scrutiny

    # n8n
    audiobookshelf
    paperless
    # commafeed
    miniflux
    # arion
    quadlet
    # couchdb
    # fail2ban
    forgejo
    immich
    locale
    
    ai-chat
    # librechat

    glance
    it-tools
    nextcloud
    umami
    nix
    nvidia
    syncthing
    # atuin
    plex
    navidrome 
    # send
    servarr
    taki
    transmission
    slskd
    vikunja
    kanboard
    rustdesk-server
    # linkwarden
    # filestash
    # youtrack
    vm-test
    wireguard
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 512;
    "fs.inotify.max_user_watches" = 1048576;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  networking = {
    hostName = "eiri"; # Define your hostname.
    networkmanager.enable = true;
  };

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    # use strictly `ssh-keyscan <remote ip>` from host
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNn2DDUnITFao47ugOzCxufnXkblnWXfFwaPfNu/JLm eiri";
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

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    tmux
    shpool
    ntfs3g
    btrfs-progs
    cifs-utils
    rage
    age-plugin-yubikey
    inputs.agenix-rekey.packages.x86_64-linux.default
    restic

    btop
    docker-compose
    fastfetch
    jdk21
  ];

  # Services

  services = {
    ## OpenSSH
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "yes";
        UsePAM = true;
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

        access_log syslog:server=127.0.0.1:1510 graylog_json;

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
      '';
      
      virtualHosts = {
        "eiri.${allSecrets.global.domain01}" = {
          addSSL = true;
          # enableACME = true;
          useACMEHost = "eiri.${allSecrets.global.domain01}";
          locations."/" = {
            proxyPass = "http://${allSecrets.per_host.eiri.int_ip}";
          };
        };
        "transmission.eiri.${allSecrets.global.domain01}" = {
          addSSL = true;
          # enableACME = true;
          useACMEHost = "eiri.${allSecrets.global.domain01}";
          locations."/" = {
            proxyPass = "http://${config.vpnNamespaces.prtr.namespaceAddress}:9091";
            # proxyWebsockets = true;
          };
        };
        "rd.eiri.${allSecrets.global.domain01}" = {
          addSSL = true;
          useACMEHost = "eiri.${allSecrets.global.domain01}";
          locations."/" = {
            proxyPass = "http://${allSecrets.per_host.eiri.int_ip}:21116";
            proxyWebsockets = true;
          };
        };
        "graylog.eiri.${allSecrets.global.domain01}" = {
          addSSL = true;
          useACMEHost = "eiri.${allSecrets.global.domain01}";
          locations."/" = {
            proxyPass = "http://${allSecrets.per_host.eiri.int_ip}:9000";
            proxyWebsockets = true;
          };
        };
        "chat.eiri.${allSecrets.global.domain01}" = {
          addSSL = true;
          useACMEHost = "eiri.${allSecrets.global.domain01}";
          locations."/" = {
            proxyPass = "http://${allSecrets.per_host.eiri.int_ip}:3335";
            proxyWebsockets = true;
          };
        };
        "litellm.eiri.${allSecrets.global.domain01}" = {
          addSSL = true;
          useACMEHost = "eiri.${allSecrets.global.domain01}";
          locations."/" = {
            proxyPass = "http://${allSecrets.per_host.eiri.int_ip}:3336";
            proxyWebsockets = true;
          };
        };
        "overseerr.eiri.${allSecrets.global.domain01}" = {
          addSSL = true;
          useACMEHost = "eiri.${allSecrets.global.domain01}";
          locations."/" = {
            proxyPass = "http://${allSecrets.per_host.eiri.int_ip}:5055";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  fileSystems = {
    "/mnt/btrfs_pool" = {
      device = "UUID=9ce8e79d-aa13-4f76-981f-c438eb821669";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" "autodefrag" ];
    };
    "/mnt/koi" = {
      device = "${allSecrets.per_host.koi.int_ip}:/volume1/backup"; # TODO
      fsType = "nfs";
      options = [
        "rw"
        "noatime"
        "nfsvers=4.1"
        "x-systemd.automount" # auto mount on use
        "x-systemd.idle-timeout=3600" # disconnect after 60 minutes
        "noauto" # auto mount on use
        "nofail"
        "_netdev"
      ];
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "${allSecrets.global.mail.acme}";
      group = "nginx";
    };
    certs = let 
      inherit (allSecrets.global) domain01;
    in {
      "eiri.${domain01}" = {
        domain = "eiri.${domain01}";
        dnsProvider = "namecheap";
        dnsPropagationCheck = false;
        environmentFile = config.age.secrets."namecheap_api_secrets".path;
        # credentialFiles = {
        #   "NAMECHEAP_API_KEY_FILE" = ;
        #   "NAMECHEAP_API_USER_FILE" = ;
        # };
        extraDomainNames = [
          "*.eiri.${domain01}"
        ];
        webroot = null;
      };
    };
  };

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  #networking.firewall.allowedUDPPorts = [ 22 80 443 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
