{ inputs, outputs, lib, config, pkgs, ... }:
{
  disabledModules = [ "services/networking/syncthing.nix" ];

  imports = with outputs.nixosModules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ({options, lib, ...}: lib.mkIf (options ? virtualisation.memorySize) {
    #   users.users.taki.password = "foo";
    # })

    inputs.nixos-generators.nixosModules.all-formats

    inputs.yeetmouse.nixosModules.default
    inputs.musnix.nixosModules.musnix

    ../../../modules/syncthing.nix

    # cachix
    substituters

    # ly
    vm-test
    locale
    nix
    steam
    pcscd
    firefox
    bash
    # kanidm-client
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [
      "quiet"
      "splash"
      "systemd.show_status=auto"
      "video=DP-1:2560x1440@165"
      "video=HDMI-A-1:1920x1080@60,rotate=90"
    ];
    plymouth.enable = true;
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

  networking.firewall.checkReversePath = "loose";

  # HYPRLAND
  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  #   xwayland.enable = true;
  # };

  environment.sessionVariables = {
    # If cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "0";
  };

  # Enable the X11 windowing system.
  services = {
    greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd niri-session";
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
      # ly = {
      #   enable = true;
      #   settings = {
      #     bigclock = "en";
      #     box_title = "Hello, User...";
      #     clock = "%c";
      #   };
      # };
      defaultSession = "niri-session";
    };

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "flat"; 
    };
  };

  # systemd.user.services = {
  #   xdg-desktop-portal.after = [ "xdg-desktop-autostart.target" ];
  #   xdg-desktop-portal-gtk.after = [ "xdg-desktop-autostart.target" ];
  #   xdg-desktop-portal-gnome.after = [ "xdg-desktop-autostart.target" ];
  #   niri-flake-polkit.after = [ "xdg-desktop-autostart.target" ];
  # };

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

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    # drivers = with pkgs; [ hplip ];
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
  security.rtkit.enable = true;
  # RT Music with the help of musnix
  # musnix = {
  #   enable = true;
  #   kernel.realtime = true;
  # };

  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      wireplumber.extraConfig = {
        "51-audio-priority" = {
          "monitor.alsa.rules" = [
            # {
            #   matches = [
            #     { "node.name" = "alsa_output.usb-MOTU_M4_M4MA01A3Q6-00.HiFi__Line1__sink"; }
            #     { "node.name" = "alsa_output.usb-MOTU_M4_M4MA01A3Q6-00.HiFi__Line2__sink"; }
            #     { "node.name" = "bluez_output.A8_F5_E1_CD_2D_00.1"; }
            #   ];
            #   actions = {
            #     update-props = {
            #       "priority.driver" = 1010;
            #       "priority.session" = 1010;
            #     };
            #   };
            # }
            {
              matches = [
                { "node.name" = "easyeffects_sink"; }
              ];
              actions.update-props = {
                "priority.driver" = 10;
                "priority.session" = 10;
              };
            }
            {
              matches = [
                { "node.name" = "~alsa_output.*"; }
              ];
              actions = {
                update-props = {
                  "device.profile.switch-on-connect" = false;
                };
              };
            }
          ];
        };
        "52-bluetooth-properties" = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
          };
        };
      };
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
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

  # nix = {
  #   # Enable the newest nix version
  #   package = inputs.rix101.packages.${pkgs.hostPlatform.system}.nix-enraged;
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
     git wget curl tmux jq
     shpool
     pavucontrol
     nvidia-vaapi-driver
     egl-wayland
     kitty
     fastfetch
     brscan4
     simple-scan
     nurl
     # flatpak
     # gnome.gnome-software
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
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      input = {
        General = {
          UserspaceHID = true;
        };
      };
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
    yeetmouse = {
      enable = true;
      sensitivity = 0.8;
      outputCap = 0.0;
      inputCap = 0.0;
      offset = 0.0;
      preScale = 1.0;
      mode.jump = {
        acceleration = 1.56;
        midpoint = 7.0;
        smoothness = 1.0;
        useSmoothing = true;
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

  services = {
    syncthing = {
      enable = true;
      # package = pkgs.stable.syncthing;

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
    blueman.enable = true;
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
