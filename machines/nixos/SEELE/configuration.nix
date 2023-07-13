# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ({options, lib, ...}: lib.mkIf (options ? virtualisation.memorySize) {
#        users.users.taki.password = "foo";
#      })
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "SEELE"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # VM shenanigans
  virtualisation.vmVariant = {
    users = {
      mutableUsers = false;
      users.taki.password = "foo";
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    #desktopManager = {
    #  xfce = {
    #    enable = true;
    #    noDesktop = true;
    #    enableXfwm = false; 
    #  };
    #};
    # TODO
    ## displayManager.ly = {
    ##   enable = true;
    ##   defaultUser = "taki";
    ## };
    displayManager.lightdm.enable = true;
    windowManager.i3.enable = true;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "flat"; 
    };
    screenSection = ''
      Option "metamodes" "DP-2: 1920x1080_165 +1920+0, DP-0: 1920x1080_165 +0+0"
    '';
  };

  services.picom.enable = true;

  #services.greetd = {
  #  enable = true;
  #  settings = {
  #    default_session = {
  #      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd i3";
  #      user = "taki";
  #    };
  #  };
  #};

  # Enable the XFCE Desktop Environment.
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.desktopManager.xfce.xfce4-panel.enable = false;
  
  #services.xserver.displayManager.sessionPackages = with pkgs; [ sway ];
  
  # Disable X.org Screensaver
  
  environment.extraInit = ''
    xset s off -dpms
  '';

  # Wayland Specific
  #services.xserver = {
  #  enable = true;
  #  displayManager = {
  #    defaultSession = "sway";
  #    sessionPackages = with pkgs; [
  #      sway
  #    ];
  #    gdm = {
  #      enable = true;
#	wayland = true;
#      };
#    };
 # };


  # Enable NVIDIA Drivers.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl.enable = true;
    nvidia = {
      open = true;
      # modesetting.enable = true;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
  # nvidia-drm modeset=1 is required for some wayland compositors, e.g. sway
  #hardware.nvidia = {
  #  open = true;
  #  modesetting.enable = true;
  #  package = config.boot.kernelPackages.nvidiaPackages.stable;
  #};

  # XDG Stuff?
  #xdg.portal = {
  #  enable = true;
  #  wlr = {
  #    enable = true;
  #  };
  #  extraPortals = with pkgs; [
  #    xdg-desktop-portal-wlr
  #    xdg-desktop-portal-gtk
  #  ];
  #};

  # Configure keymap in X11
  services.xserver = {
    layout = "ch";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "sg";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };

  # udev qmk stuff
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
  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    # Enable the newest nix version
    package = pkgs.nixUnstable;

    # Enable flakes, the new `nix` commands and better support for flakes in it
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #   ly
     ntfs3g
     git wget curl tmux
     exa bat tealdeer viu 
     pavucontrol
     neofetch
     xorg.xkill xclip xdotool
     xfce.xfce4-pulseaudio-plugin xfce.xfce4-whiskermenu-plugin xfce.xfce4-netload-plugin xfce.xfce4-genmon-plugin
  ];

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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
