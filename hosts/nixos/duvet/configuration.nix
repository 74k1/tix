{ inputs, outputs, config, lib, pkgs, ... }:
{
  # See [NixOS on Hetzner Cloud Wiki](https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud)

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

  age = {
    rekey = {
      # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
      # use strictly `ssh-keyscan <remote ip>` from host
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0pG+xpBOghFWXY7eQHOxyGuWzh2NrcLp7e9Kpgjooq duvet";
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
    # secrets."gh-private-repo-token" = {
    #   rekeyFile = "${inputs.self}/secrets/github_private_repo_token.age";
    #   owner = "blog";
    # };
  };

  networking = {
    hostName = "duvet"; # Define your hostname.
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ 80 443 2202 ];
      allowedTCPPorts = [ 80 443 2202 ];
    };
  };

  programs.zsh.enable = true;
  
  environment.systemPackages = with pkgs; [
    btop
    git wget curl tmux unzip zip
    fastfetch
  ];

  users.users.root.hashedPassword = "!"; # Disable root login

  system.activationScripts.buildBlog = /* bash */ ''
    echo "Deploying pre-built blog..."
    ${pkgs.coreutils}/bin/rm -rf /var/www/blog
    ${pkgs.coreutils}/bin/install -d -m 0755 -o taki -g users /var/www/blog
    ${pkgs.coreutils}/bin/cp -r ${inputs.blog.packages.x86_64-linux.website}/dist/* /var/www/blog/
    ${pkgs.coreutils}/bin/chmod -R 0755 /var/www/blog
    ${pkgs.coreutils}/bin/chown -R taki:users /var/www/blog
    echo "Finished deploying blog."
  '';

  systemd.tmpfiles.rules = [
    "d /var/www/blog 0755 taki users -"
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
          addSSL = true;
          enableACME = true;
          locations."/" = {
            return = "200 $remote_addr\n";
            extraConfig = ''
              default_type text/plain;
            '';
          };
        };
        # "wall.74k1.sh" = {
        #   addSSL = true;
        #   enableACME = true;
        #   root = "/var/www/wall.74k1.sh/";
        #   locations."/".index = "index.php";
        #   locations."~ \\.php$".extraConfig = ''
        #     fastcgi_pass unix:${config.services.phpfpm.pools.mypool.socket};
        #     fastcgi_index index.php;
        #   '';
        # };
        "74k1.sh" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/blog/";
        };
        "taki.moe" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/taki.moe/";
          # locations."/".index = "index.php";
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
    defaults.email = "mail@74k1.sh";
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

