{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ({options, lib, ...}: lib.mkIf (options ? virtualisation.memorySize) {
    #   users.users.taki.password = "foo";
    # })

    # ly
    vm-test
    locale
    nix
    steam
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

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
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd hyprland";
        };
      };
    };
    xserver = {
      enable = true;

      # greeter
      displayManager = {
        # sddm = {
        #   enable = true;
        #   wayland.enable = true;
        #   theme = "Ukiyo";
        #   autoNumlock = true;
        #   settings = {
        #     Autologin = {
        #       Session = "hyprland";
        #       User = "taki";
        #     };
        #   };
        # };
        defaultSession = "hyprland";
        # lightdm = {
        #   enable = true;
        #   greeters.slick = {
        #     enable = true;
        #     theme.name = "Ukiyo";
        #   };
        # };
      };

      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        touchpad.accelProfile = "flat"; 
      };

      screenSection = ''
        Option "metamodes" "DP-2: 2560x1440_165 +0+0, DP-0: 2560x1440_165 +2560+0"
      '';
    };

    # picom = {
    #   enable = true;
    #   fade = true;
    #   # inactiveOpacity = "0.9";
    #   shadow = true;
    #   fadeDelta = 4;
    # };
  };


  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd startx";
  #       user = "taki";
  #     };
  #   };
  # };
  
  # Disable xorg Screensaver
  environment.extraInit = ''
    xset s off -dpms
  '';

  # Enable AMD GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  hardware.opengl = {
    #driSupport = true;
    #driSupport32Bit = true;
    extraPackages = with pkgs; [ 
      rocmPackages.clr.icd
      amdvlk
      driversi686Linux.amdvlk
    ];
  };
  boot.kernelParams = [
    "video=DP-2:2560x1440@165"
    "video=DP-1:2560x1440@165"
  ];
  #hardware = {
  #  opengl.enable = true;
  #  nvidia = {
  #    #open = true;
  #    modesetting.enable = true;
  #  };
  #};

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "ch";
  #   xkbVariant = "";
  # };

  # Configure console keymap
  # console.keyMap = "sg";

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
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
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
     ntfs3g
     git wget curlWithGnuTls tmux
     pavucontrol
     nvidia-vaapi-driver
     egl-wayland
     kitty
     neofetch
     brscan4
     gnome.simple-scan
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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
