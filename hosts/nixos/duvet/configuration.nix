{ inputs, outputs, config, lib, pkgs, allSecrets, ... }:
{
  # See [NixOS on Hetzner Cloud Wiki](https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud)

  imports = with outputs.nixosModules; [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # inputs.agenix.nixosModules.default
      # inputs.agenix-rekey.nixosModules.default

      # fail2ban
      crowdsec-bouncer
      # vector

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

    crowdsec-firewall-bouncer = {
      settings = {
        api.server = {
          api_key = "${allSecrets.per_host.duvet.crowdsec.api_key}";
        };
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # commonHttpConfig = ''
      #   log_format graylog_json escape=json '{ "nginx_timestamp": "$time_iso8601", '
      #     '"remote_addr": "$remote_addr", '
      #     '"connection": "$connection", '
      #     '"connection_requests": $connection_requests, '
      #     '"pipe": "$pipe", '
      #     '"body_bytes_sent": $body_bytes_sent, '
      #     '"request_length": $request_length, '
      #     '"request_time": $request_time, '
      #     '"response_status": $status, '
      #     '"request": "$request", '
      #     '"request_method": "$request_method", '
      #     '"host": "$host", '
      #     '"upstream_cache_status": "$upstream_cache_status", '
      #     '"upstream_addr": "$upstream_addr", '
      #     '"http_x_forwarded_for": "$http_x_forwarded_for", '
      #     '"http_referrer": "$http_referer", '
      #     '"http_user_agent": "$http_user_agent", '
      #     '"http_version": "$server_protocol", '
      #     '"remote_user": "$remote_user", '
      #     '"http_x_forwarded_proto": "$http_x_forwarded_proto", '
      #     '"upstream_response_time": "$upstream_response_time", '
      #     '"nginx_access": true }';
      #
      #   access_log syslog:server=127.0.0.1:9000 graylog_json;
      #
      #   access_log /var/log/nginx/access.log;
      #   error_log /var/log/nginx/error.log;
      # '';

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
        "wall.74k1.sh" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/wall.74k1.sh/";
          locations."/".index = "index.php";
          locations."~ \\.php$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.mypool.socket};
            fastcgi_index index.php;
          '';
        };
        "74k1.sh" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/blog/";
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

