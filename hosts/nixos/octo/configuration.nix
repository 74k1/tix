{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = with outputs.nixosModules; [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # inputs.raspberry-pi-nix.nixosModules.raspberry-pi

    locale
    nix
    taki
  ];

  # raspberry-pi-nix.board = "bcm2711";

  # hardware.raspberry-pi = {
  #   config.all.options.camera_auto_detect.enable = true;
  # };

  # nixpkgs.overlays = [
  #   (_prev: _final: {
  #     octoprint = inputs.nixpkgs-master.legacyPackages.${pkgs.hostPlatform.system}.octoprint;
  #   })
  # ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  documentation.nixos.enable = false;

  networking = {
    hostName = "octo"; # Define your hostname.
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    ouch
    git wget curl tmux
    fastfetch
    libraspberrypi
    # inputs.nixpkgs-master.legacyPackages.${pkgs.hostPlatform.system}.octoprint
  ];

  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    fluidd = {
      enable = true;
      hostName = "octo";
      nginx.locations."/webcam".proxyPass = "http://127.0.0.1:8080/stream";
    };

    nginx.clientMaxBodySize = "1000m";

    moonraker = {
      enable = true;
      address = "0.0.0.0";
      allowSystemControl = true;
      settings = {
        # Fluidd
        # virtual_sdcard.path = "~/gcode_files";
        # display_status = {};
        # pause_resume = {};
        #
        # "gcode_macro PAUSE" = {
        #   description = "Pause the actual running print";
        #   rename_existing = "PAUSE_BASE";
        #   variable_extrude = 1.0;
        #   gcode = ''
        #       ##### read E from pause macro #####
        #       {% set E = printer["gcode_macro PAUSE"].extrude|float %}
        #       ##### set park positon for x and y #####
        #       # default is your max posion from your printer.cfg
        #       {% set x_park = printer.toolhead.axis_maximum.x|float - 5.0 %}
        #       {% set y_park = printer.toolhead.axis_maximum.y|float - 5.0 %}
        #       ##### calculate save lift position #####
        #       {% set max_z = printer.toolhead.axis_maximum.z|float %}
        #       {% set act_z = printer.toolhead.position.z|float %}
        #       {% if act_z < (max_z - 2.0) %}
        #           {% set z_safe = 2.0 %}
        #       {% else %}
        #           {% set z_safe = max_z - act_z %}
        #       {% endif %}
        #       ##### end of definitions #####
        #       PAUSE_BASE
        #       G91
        #       {% if printer.extruder.can_extrude|lower == 'true' %}
        #         G1 E-{E} F2100
        #       {% else %}
        #         {action_respond_info("Extruder not hot enough")}
        #       {% endif %}
        #       {% if "xyz" in printer.toolhead.homed_axes %}
        #         G1 Z{z_safe} F900
        #         G90
        #         G1 X{x_park} Y{y_park} F6000
        #       {% else %}
        #         {action_respond_info("Printer not homed")}
        #       {% endif %} 
        #   '';
        # };
        #
        # "gcode_macro RESUME" = {
        #   description = "Resume the actual running print";
        #   rename_existing = "RESUME_BASE";
        #   gcode = ''
        #     ##### read E from pause macro #####
        #     {% set E = printer["gcode_macro PAUSE"].extrude|float %}
        #     #### get VELOCITY parameter if specified ####
        #     {% if 'VELOCITY' in params|upper %}
        #       {% set get_params = ('VELOCITY=' + params.VELOCITY)  %}
        #     {%else %}
        #       {% set get_params = "" %}
        #     {% endif %}
        #     ##### end of definitions #####
        #     {% if printer.extruder.can_extrude|lower == 'true' %}
        #       G91
        #       G1 E{E} F2100
        #     {% else %}
        #       {action_respond_info("Extruder not hot enough")}
        #     {% endif %}  
        #     RESUME_BASE {get_params}
        #   '';
        # };
        #
        # "gcode_macro CANCEL_PRINT" = {
        #   description = "Cancel the actual running print";
        #   rename_existing = "CANCEL_PRINT_BASE";
        #   gcode = ''
        #     TURN_OFF_HEATERS
        #     CANCEL_PRINT_BASE
        #   '';
        # };

        announcements = {
          susbscriptions = [ "fluidd" ];
        };

        "update_manager fluidd" = {
          type = "web";
          repo = "fluidd-core/fluidd";
          path = "/var/lib/fluidd";
        };
        
        # Moonraker
        authorization = {
          force_logins = true;
          trusted_clients = [
            "10.0.0.0/8"
            "127.0.0.0/8"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "FE80::/10"
            "::1/128"
          ];
          cors_domains = [
            "*.local"
            "*.lan"
            "*://localhost"
            "*://app.fluidd.xyz"
          ];
        };

        octoprint_compat = {};

        history = {};

        update_manager = {
          enable_auto_refresh = true;
        };
      };
    };

    klipper = {
      enable = true;
      inherit (config.services.moonraker) user group;
      firmwares.mcu = {
        enable = true;
        configFile = ./config;
        serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
      };
      mutableConfig = true;
      mutableConfigFolder = config.services.moonraker.stateDir + "/config";
      configFile = ./printer.cfg;
    };
    
    # octoprint = {
    #   enable = true;
    #   openFirewall = true; # 5000
    #   plugins = plugins: with plugins; [
    #     dashboard
    #     firmwareupdater
    #     bedlevelvisualizer
    #     fullscreen
    #     # smartpreheat
    #     # camerasettings
    #     # PrintTimeGenius
    #     simpleemergencystop
    #     themeify
    #     # uicustomizer
    #     stlviewer
    #   ];
    # };
  };
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 7125 ];
  networking.firewall.allowedUDPPorts = [ 80 7125 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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

