{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
{
  # See [NixOS on Hetzner Cloud Wiki](https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud)

  age.secrets = {
    "duvet_wireguard_private_key" = {
      rekeyFile = "${inputs.self}/secrets/duvet_wireguard_private_key.age";
      mode = "640";
      owner = "systemd-network";
      group = "systemd-network";
    };
  };

  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    fail2ban
    # vector
    alloy

    locale
    nix
    taki
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda";
  };

  documentation.nixos.enable = false;

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    # use strictly `ssh-keyscan <remote ip>` from host
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0pG+xpBOghFWXY7eQHOxyGuWzh2NrcLp7e9Kpgjooq duvet";
    # The path to the master identity used for decryption. See the option's description for more information.
    masterIdentities = [
      "${inputs.self}/secrets/identities/yubikey-1-on-person.pub"
      "${inputs.self}/secrets/identities/yubikey-2-at-home.pub"
    ];
    storageMode = "local";
    # Choose a dir to store the rekeyed secrets for this host.
    # This cannot be shared with other hosts. Please refer to this path
    # from your flake's root directory and not by a direct path literal like ./secrets
    localStorageDir = "${inputs.self}/secrets/rekeyed/${config.networking.hostName}";
  };

  services.fail2ban.jails = {
    sshd.settings = {
      enabled = true;
      port = "ssh";
      filter = "sshd[mode=agressive]";
      maxretry = 1;
      bantime = "1h";
    };
  };

  networking = {
    hostName = "duvet"; # Define your hostname.
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedUDPPorts = [
        80
        443
        2202
        51820
      ];
      allowedTCPPorts = [
        80
        443
        2202
        51820
      ];
    };
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "10.100.0.3/32" ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;

        PrivateKeyFile = config.age.secrets."duvet_wireguard_private_key".path;

        # Automatically create routes for everything in AllowedIPs
        RouteTable = "main";

        # FirewallMark marks all packets send and received by wg0 with the number 42
        # to define policy rules on these packets
        FirewallMark = 42;
      };

      wireguardPeers = [
        {
          PublicKey = "vnmW4+i/tKuiUx86JGOax3wHl1eAPwZj+/diVkpiZgM=";
          AllowedIPs = [ "10.100.0.1/32" ];
          Endpoint = "${allSecrets.global.pub_ip}:51820";
          PersistentKeepalive = 60;
        }
      ];
    };
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    git
    wget
    curl
    tmux
    unzip
    zip
    fastfetch
  ];

  users.users.root.hashedPassword = "!"; # Disable root login

  system.activationScripts.buildBlog = # bash
    ''
      echo "Deploying pre-built blog..."
      ${pkgs.coreutils}/bin/rm -rf /var/www/blog
      ${pkgs.coreutils}/bin/install -d -m 0755 -o taki -g users /var/www/blog
      ${pkgs.coreutils}/bin/cp -r ${inputs.blog.packages.x86_64-linux.website}/* /var/www/blog/
      ${pkgs.coreutils}/bin/chmod -R 0755 /var/www/blog
      ${pkgs.coreutils}/bin/chown -R taki:users /var/www/blog
      echo "Finished deploying blog."
    '';

  systemd.tmpfiles.rules = [
    "d /var/www/blog 0755 taki users -"
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
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    phpfpm.pools.mypool = {
      user = "nobody";
      settings = {
        "pm" = "dynamic";
        "listen.owner" = config.services.nginx.user;
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
        "pm.max_requests" = 500;
      };
    };

    nginx = {
      enable = true;
      package = pkgs.master.nginxMainline;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      commonHttpConfig = ''
        access_log syslog:server=127.0.0.1:1514,facility=local6,tag=nginx,severity=info combined;
        error_log syslog:server=127.0.0.1:1514,facility=local6,tag=nginx error;
      '';

      virtualHosts = {
        "ip.${allSecrets.global.domain01}" = {
          addSSL = true;
          enableACME = true;
          locations."/" = {
            return = "200 $remote_addr\n";
            extraConfig = ''
              default_type text/plain;
            '';
          };
        };
        "wall.${allSecrets.global.domain01}" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/wall.${allSecrets.global.domain01}/";
          locations."/".index = "index.php";
          locations."~ \\.php$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.mypool.socket};
            fastcgi_index index.php;
          '';
        };
        "${allSecrets.global.domain01}" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/blog/";
          locations."/".tryFiles = "$uri $uri/ =404";
        };
        "taki.moe" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/taki.moe/";
          locations."/".index = "index.php index.html index.txt";
          locations."~ \\.php$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.mypool.socket};
            fastcgi_index index.php;
          '';
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "${allSecrets.global.mail.acme}";
  };

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
