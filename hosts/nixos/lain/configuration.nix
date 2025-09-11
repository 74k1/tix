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
  # See [NixOS DGX Spark](https://github.com/graham33/nixos-dgx-spark)

  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix

    inputs.tixpkgs.nixosModules'.services.mc-gate

    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    inputs.dgx-spark.nixosModules.dgx-spark

    # fail2ban
    # vector
    # alloy

    locale
    nix
    dgx-interconnect
    glm53-exl3
    taki
  ];

  age.secrets."hf_read_token_env" = {
    rekeyFile = "${inputs.self}/secrets/hf_read_token_env.age";
    # mode = "640";
    # owner = "";
    # group = "";
  };

  hardware.dgx-spark.enable = true;

  # CX-7 RoCEv2 interconnect to arisu (the peer Spark). lain is host #1 →
  # every CX-7 MAC ends in .10, arisu's in .11. All four logical MACs are
  # addressed so the cable works in either QSFP socket; the linked pair is
  # whatever shows (Up) in `ibdev2netdev` after cabling.
  tix.dgx-interconnect = {
    enable = true;
    addresses = {
      enp1s0f0np0 = "192.168.100.10";
      enP2p1s0f0np0 = "192.168.101.10";
      enp1s0f1np1 = "192.168.102.10";
      enP2p1s0f1np1 = "192.168.103.10";
    };
    peers = [
      "192.168.100.11"
      "192.168.101.11"
      "192.168.102.11"
      "192.168.103.11"
    ];
  };

  # GLM-5.3-Flash EXL3 (rank 0, OpenAI API :8888) — weights auto-fetch into
  # /var/lib/models/hf on switch; members poll until the fetch completes.
  services.glm53-exl3 = {
    enable = true;
    role = "head";
  };

  nix.gc.automatic = true;

  # nixpkgs is wired as an external pre-built instance (see
  # modules/flake/configurations.nix), so modules may not set
  # nixpkgs.config/overlays. The dgx-spark module's settings are provided
  # via the shared perSystem pkgs instead (modules/flake/nixpkgs.nix).
  nixpkgs.config = lib.mkForce { };
  nixpkgs.overlays = lib.mkForce [ ];

  boot = {
    # GB10 is UEFI-only arm64; systemd-boot is what the dgx-spark install
    # path uses and avoids grub's device assertions on this nixpkgs rev.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    plymouth = {
      enable = true;
      theme = "cuts_alt";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "cuts_alt" ]; })
      ];
    };

    binfmt.emulatedSystems = [ "x86_64-linux" ];
  };

  documentation.nixos.enable = false;

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    # use strictly `ssh-keyscan <remote ip>` from host
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnAXeqTwizNib10w/qzwbBqD7Jb6HGvj4EuoszfXUpF lain";
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

  # services.fail2ban.jails = {
  #   sshd.settings = {
  #     enabled = true;
  #     port = "ssh";
  #     banaction = "iptables-multiport";
  #     bantime = "1h";
  #     filter = "sshd[mode=agressive]";
  #     maxretry = 1;
  #   };
  # };

  networking = {
    hostName = "lain";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [
        80
      ];
      allowedTCPPorts = [
        22
        443
        8888
      ];
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting = {
        enable = true;
        autohint = true;
      };
    };
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    ouch
    git
    wget
    curl
    tmux
    fastfetch
  ];

  services = {
    resolved.enable = true;

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  virtualisation.podman.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

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
  system.stateVersion = "26.05"; # Did you read the comment?
}
