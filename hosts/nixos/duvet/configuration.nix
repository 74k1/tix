{ inputs, outputs, config, lib, pkgs, ... }:
{
  # See [NixOS on Hetzner Cloud Wiki](https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud)

  imports = with outputs.nixosModules; [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      locale
      nix
      taki
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  documentation.nixos.enable = false;

  networking = {
    hostName = "duvet"; # Define your hostname.
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ 80 443 2202 ];
      allowedTCPPorts = [ 80 443 2202 ];
    };

    # wireguard.interfaces = {
    #   wg0 = {
    #     ips = [ "10.100.0.2/24" ];
    #     listenPort = 51820;
    #     privateKeyFile = "/home/taki/wg_knights_private_key_secrets";
    #     peers = [
    #       {
    #         publicKey = "vnmW4+i/tKuiUx86JGOax3wHl1eAPwZj+/diVkpiZgM=";
    #         allowedIPs = [ "10.100.0.1" ];
    #         endpoint = "example.com:51820";
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
  };

  programs.zsh.enable = true;
  
  environment.systemPackages = with pkgs; [
    btop
    git wget curl tmux unzip zip
    fastfetch
  ];

  users.users.root.hashedPassword = "!"; # Disable root login

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
        "wall.74k1.sh" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/wall.74k1.sh/";
          locations."~ \\.php$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.mypool.socket};
            fastcgi_index index.php;
          '';
        };
        "74k1.sh" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/74k1.sh/";
        };
        "taki.moe" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/taki.moe/";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "74k1@pm.me";
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

