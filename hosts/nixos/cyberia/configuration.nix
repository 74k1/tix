{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ({options, lib, ...}: lib.mkIf (options ? virtualisation.memorySize) {
    #   users.users.taki.password = "foo";
    # })

    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default

    inputs.nixos-generators.nixosModules.all-formats

    # ly
    openssh
    vm-test
    locale
    nix
    taki
    steam
  ];

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcSDZxE2I6ViR3oEMBGANuJeHqIUaq1MBYcRxokSOwR cyberia";
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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cyberia"; # Define your hostname.
  networking.networkmanager.enable = true;

  # HYPRLAND
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  # environment.sessionVariables = {
  #   If cursor becomes invisible
  #   WLR_NO_HARDWARE_CURSORS = "1";
  #   Hint electron apps to use wayland
  #   NIXOS_OZONE_WL = "1";
  # };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable the X11 windowing system.
  services = {
    pcscd.enable = true;
    greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd river";
        };
      };
    };

    xserver = {
      enable = true;
    };

    displayManager = {
      defaultSession = "river";
    };
    
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      # touchpad.accelProfile = "flat"; 
      touchpad = {
        naturalScrolling = true;
        middleEmulation = true;
        tapping = true;
      };
    };
    # picom = {
    #   enable = true;
    #   fade = true;
    #   # inactiveOpacity = "0.9";
    #   shadow = true;
    #   fadeDelta = 4;
    # };
  };
  
  # Disable xorg Screensaver
  environment.extraInit = ''
    xset s off -dpms
  '';

  boot.kernelParams = [
    "video=eDP-1:2560x1600@165"
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };
  
  # udev stuff for qmk
  services.udev.packages = [
    pkgs.qmk-udev-rules
  ];

  programs.zsh = {
    enable = true;
  };

  # Evolution shenanigans
  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ntfs3g
    git wget curl tmux
    pavucontrol
    nvidia-vaapi-driver
    egl-wayland
    kitty # def. term
    fastfetch # neofetch
    brscan4 # Brother Driver?
    simple-scan # Document Scanner
    acpi # Battery
    wireguard-tools

    rage
    inputs.agenix-rekey.packages.${pkgs.system}.agenix-rekey
    wl-clipboard

    #alttab
    #dconf
    #xorg.xkill xclip xdotool xorg.xinit
    #xfce.xfce4-pulseaudio-plugin xfce.xfce4-whiskermenu-plugin xfce.xfce4-netload-plugin xfce.xfce4-genmon-plugin
  ];


  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
