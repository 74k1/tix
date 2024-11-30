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

    inputs.yeetmouse.nixosModules.default

    # cachix
    #substituters

    # ly
    vm-test
    locale
    nix
    steam
    pcscd
  ];

  age.rekey = {
    # Obtain this using `ssh-keyscan` or by looking it up in your ~/.ssh/known_hosts
    # hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcSDZxE2I6ViR3oEMBGANuJeHqIUaq1MBYcRxokSOwR cyberia";
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
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "wired"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # HYPRLAND
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # If cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "0";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable the X11 windowing system.
  services = {
    greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
        };
      };
    };
    
    xserver = {
      enable = true;

      # greeter
      screenSection = ''
        Option "metamodes" "DP-2: 2560x1440_165 +0+0, DP-0: 2560x1440_165 +2560+0"
      '';
    };

    displayManager = {
      defaultSession = "Hyprland";
    };

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "flat"; 
    };

    mullvad-vpn.enable = true;
  };

  # Disable xorg Screensaver
  environment.extraInit = ''
    xset s off -dpms
  '';

  # Enable AMD GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot = {
    kernelModules = [ "amdgpu" ];
    initrd.kernelModules = [ "amdgpu" ];
  };
  hardware.graphics = {
    enable = true;
    # extraPackages = with pkgs; [ 
    #   rocm-opencl-icd
    #   rocm-opencl-runtime
    #   # rocmPackages.clr.icd
    #   # amdvlk
    #   # driversi686Linux.amdvlk
    # ];
  };

  boot.kernelParams = [
    "video=DP-2:2560x1440@165"
    "video=DP-1:2560x1440@165"
  ];

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
    browsing = true;
    browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All
      BrowseProtocols all
    '';
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf pkgs.gcr ];
  };

  programs.dconf.enable = true;
  
  # udev stuff for qmk
  services.udev.packages = [
    pkgs.qmk-udev-rules
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.taki = {
    isNormalUser = true;
    description = "taki";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
  };

  # Evolution shenanigans
  #programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;

  # # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;
  #
  # nix = {
  #   # Enable the newest nix version
  #   package = pkgs.nixUnstable;
  #
  #   # Enable flakes, the new `nix` commands and better support for flakes in it
  #   extraOptions = ''
  #     experimental-features = nix-command flakes repl-flake
  #   '';
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     ntfs3g davfs2
     git wget curl tmux
     pavucontrol
     nvidia-vaapi-driver
     egl-wayland
     kitty
     fastfetch
     brscan4
     simple-scan
     nurl
     #alttab
     #dconf
     #xorg.xkill xclip xdotool xorg.xinit
     #xfce.xfce4-pulseaudio-plugin xfce.xfce4-whiskermenu-plugin xfce.xfce4-netload-plugin xfce.xfce4-genmon-plugin
  ];

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  hardware = {
    yeetmouse = {
      enable = false;
      parameters = {
        AccelerationMode = "jump"; # looks most like motivity in Raw Accel
        Sensitivity = 0.8;
        # Offset = -15.0;
        # PreScale = 0.20;
        PreScale = 1.0;
        Acceleration = 1.56;
        Midpoint = 7.0;
        UseSmoothing = true;
        ScrollsPerTick = 1;
      };
    };
    sane = {
      enable = true;
      brscan4 = {
        enable = true;
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.syncthing = {
    enable = true;

    # Declarative node IDs
    # cert = config.age.secrets."syncthing_cert".path;
    # key = config.age.secrets."syncthing_key".path;

    user = "taki";
    group = "users";
    dataDir = "/home/taki";

    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      relaysEnabled = true;
      urAccepted = -1;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
