{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    vm-test
    locale
    nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "TOKYO-3"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.taki = {
    isNormalUser = true;
    description = "taki";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhjipcpqKCIRFK3o5QqqjGteAFEJdabnZqgraK2n8pa taki@NERV"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    ntfs3g
    git wget curl tmux
    neofetch
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
      };
    };

    ## Sourcehut META and GIT
    sourcehut = {
      enable = true;
      nginx.enable = true;
      nginx.virtualHost = {
        forceSSL = false;
      };
      postgresql.enable = true;
      redis.enable = true;

      meta.enable = true;
      git.enable = false;
      
      settings = {
        "sr.ht" = {
          global-domain = "git.74k1.sh";
          service-key = pkgs.writeText "service-key" "8b327279b77e32a3620e2fc9aabce491cc46e7d821fd6713b2a2e650ce114d01";
          network-key = pkgs.writeText "network-key" "cEEmc30BRBGkgQZcHFksiG7hjc6_dK1XR2Oo5Jb9_nQ=";
        };
        "git.sr.ht" = {
          oauth-client-id = "d07cb713d920702e";
          oauth-client-secret = pkgs.writeText "gitsrht-oauth-client-secret" "3597288dc2c716e567db5384f493b09d";
        };
        webhooks.private-key = pkgs.writeText "webhook-key" "Ra3IjxgFiwG9jxgp4WALQIZw/BMYt30xWiOsqD0J7EA=";
        mail = {
          smtp-from = "root+hut@74k1.sh";
          # WARNING: take care to keep pgp-privkey outside the Nix store in production,
          # or use LoadCredentialEncrypted=
          pgp-privkey = toString (pkgs.writeText "sourcehut.pgp-privkey" ''
            -----BEGIN PGP PRIVATE KEY BLOCK-----

            lFgEYqDRORYJKwYBBAHaRw8BAQdAehGoy36FUx2OesYm07be2rtLyvR5Pb/ltstd
            Gk7hYQoAAP9X4oPmxxrHN8LewBpWITdBomNqlHoiP7mI0nz/BOPJHxEktDZuaXhv
            cy90ZXN0cy9zb3VyY2VodXQgPHJvb3QraHV0QHNvdXJjZWh1dC5sb2NhbGRvbWFp
            bj6IlwQTFgoAPxYhBPqjgjnL8RHN4JnADNicgXaYm0jJBQJioNE5AhsDBQkDwmcA
            BgsJCAcDCgUVCgkICwUWAwIBAAIeBQIXgAAKCRDYnIF2mJtIySVCAP9e2nHsVHSi
            2B1YGZpVG7Xf36vxljmMkbroQy+0gBPwRwEAq+jaiQqlbGhQ7R/HMFcAxBIVsq8h
            Aw1rngsUd0o3dAicXQRioNE5EgorBgEEAZdVAQUBAQdAXZV2Sd5ZNBVTBbTGavMv
            D6ORrUh8z7TI/3CsxCE7+yADAQgHAAD/c1RU9xH+V/uI1fE7HIn/zL0LUPpsuce2
            cH++g4u3kBgTOYh+BBgWCgAmFiEE+qOCOcvxEc3gmcAM2JyBdpibSMkFAmKg0TkC
            GwwFCQPCZwAACgkQ2JyBdpibSMlKagD/cTre6p1m8QuJ7kwmCFRSz5tBzIuYMMgN
            xtT7dmS91csA/35fWsOykSiFRojQ7ccCSUTHL7ApF2EbL968tP/D2hIG
            =Hjoc
            -----END PGP PRIVATE KEY BLOCK-----
          '');
          pgp-pubkey = pkgs.writeText "sourcehut.pgp-pubkey" ''
            -----BEGIN PGP PUBLIC KEY BLOCK-----

            mDMEYqDRORYJKwYBBAHaRw8BAQdAehGoy36FUx2OesYm07be2rtLyvR5Pb/ltstd
            Gk7hYQq0Nm5peG9zL3Rlc3RzL3NvdXJjZWh1dCA8cm9vdCtodXRAc291cmNlaHV0
            LmxvY2FsZG9tYWluPoiXBBMWCgA/FiEE+qOCOcvxEc3gmcAM2JyBdpibSMkFAmKg
            0TkCGwMFCQPCZwAGCwkIBwMKBRUKCQgLBRYDAgEAAh4FAheAAAoJENicgXaYm0jJ
            JUIA/17acexUdKLYHVgZmlUbtd/fq/GWOYyRuuhDL7SAE/BHAQCr6NqJCqVsaFDt
            H8cwVwDEEhWyryEDDWueCxR3Sjd0CLg4BGKg0TkSCisGAQQBl1UBBQEBB0BdlXZJ
            3lk0FVMFtMZq8y8Po5GtSHzPtMj/cKzEITv7IAMBCAeIfgQYFgoAJhYhBPqjgjnL
            8RHN4JnADNicgXaYm0jJBQJioNE5AhsMBQkDwmcAAAoJENicgXaYm0jJSmoA/3E6
            3uqdZvELie5MJghUUs+bQcyLmDDIDcbU+3ZkvdXLAP9+X1rDspEohUaI0O3HAklE
            xy+wKRdhGy/evLT/w9oSBg==
            =pJD7
            -----END PGP PUBLIC KEY BLOCK-----
          '';
          pgp-key-id = "0xFAA38239CBF111CDE099C00CD89C8176989B48C9";
        };
      };
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
    };    

    ## PostgreSQL
    postgresql = {
      enable = true;
      enableTCPIP = false;
      settings.unix_socket_permissions = "0770";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 22 80 443 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # Docker
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
