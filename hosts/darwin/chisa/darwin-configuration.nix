{
  outputs,
  pkgs,
  ...
}:

{
  imports = with outputs.darwinModules; [
    brew
    rift
    sketchybar
  ];

  services.rift = {
    enable = true;
    settings.default_disable = false;

    keys = {
      # focus
      "Meta + H" = {
        move_focus = "left";
      };
      "Meta + J" = {
        move_focus = "down";
      };
      "Meta + K" = {
        move_focus = "up";
      };
      "Meta + L" = {
        move_focus = "right";
      };

      # move windows
      "Meta + Shift + H" = {
        move_node = "left";
      };
      "Meta + Shift + J" = {
        move_node = "down";
      };
      "Meta + Shift + K" = {
        move_node = "up";
      };
      "Meta + Shift + L" = {
        move_node = "right";
      };

      # workspaces
      "Meta + 1" = {
        switch_to_workspace = 0;
      };
      "Meta + 2" = {
        switch_to_workspace = 1;
      };
      "Meta + 3" = {
        switch_to_workspace = 2;
      };
      "Meta + 4" = {
        switch_to_workspace = 3;
      };

      "Meta + Shift + 1" = {
        move_window_to_workspace = 0;
      };
      "Meta + Shift + 2" = {
        move_window_to_workspace = 1;
      };
      "Meta + Shift + 3" = {
        move_window_to_workspace = 2;
      };
      "Meta + Shift + 4" = {
        move_window_to_workspace = 3;
      };

      # terminal (niri: Mod+Return spawn ghostty +new-window)
      "Meta + Return" = {
        exec = [
          "/Applications/Ghostty.app/Contents/MacOS/ghostty"
          "+new-window"
        ];
      };

      # files (niri: Mod+E nautilus)
      "Meta + E" = {
        exec = [
          "/usr/bin/open"
          "-a"
          "Finder"
        ];
      };

      # fullscreen (niri: Mod+F maximize-column)
      "Meta + F" = "toggle_fullscreen";

      # floating (niri: Mod+Alt+Space toggle-window-floating)
      "Meta + Alt + Space" = "toggle_window_floating";
    };
  };

  environment.systemPackages = with pkgs; [
    bat-extras.batman
    btop
    gnupg
    imagemagick
    joshuto
    neovim
    pandoc
    pinentry_mac
    qemu
    qmk
    skim
    tealdeer
    texliveBasic
    tmux
    utm
    vim
    zellij
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operator"
    ];
    package = pkgs.nixVersions.stable;
  };

  fonts.packages = [
    pkgs.dejavu_fonts
  ];

  # TouchID Sudo
  security = {
    pam.services.sudo_local.touchIdAuth = true;
    # sudo.extraConfig = ''
    #   taki ALL = (ALL) ALL
    # '';
  };

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  # GPG as Agent, already done in home.nix
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # system config
  system = {
    primaryUser = "taki";
    defaults = {
      dock = {
        # autohide = true;
        # autohide-delay = 10000;
        launchanim = false;
        magnification = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        FXPreferredViewStyle = "Nlsv"; # icnv Icon view, Nlsv list view, clmv column view, Flwv gallery view
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "Home";
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";
      menuExtraClock = {
        Show24Hour = true;
      };
      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true;
        "com.apple.mouse.tapBehavior" = 1;
        _HIHideMenuBar = false;
        AppleInterfaceStyle = "Dark";
        # Expand print panel by default
        PMPrintingExpandedStateForPrint = true;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 12;
        KeyRepeat = 2;
        # Save to local disk by default, not iCloud
        NSDocumentSaveNewDocumentsToCloud = false;
        # Disable autocorrect capitalization
        NSAutomaticCapitalizationEnabled = false;
        # Disable autocorrect smart dashes
        NSAutomaticDashSubstitutionEnabled = false;
        # Disable autocorrect adding periods
        NSAutomaticPeriodSubstitutionEnabled = false;
        # Disable autocorrect smart quotation marks
        NSAutomaticQuoteSubstitutionEnabled = false;
        # Disable autocorrect spellcheck
        NSAutomaticSpellingCorrectionEnabled = false;
        # (Effectively) disable resize animations
        NSWindowResizeTime = 0.003;
        # Disable scrollbar animations
        NSScrollAnimationEnabled = false;
        # Disable automatic window animations
        NSAutomaticWindowAnimationsEnabled = false;
      };
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      spaces.spans-displays = false;
      universalaccess = {
        closeViewScrollWheelToggle = true;
        reduceMotion = true;
      };
      WindowManager = {
        EnableTilingByEdgeDrag = false;
        EnableStandardClickToShowDesktop = false;
        EnableTilingOptionAccelerator = false;
        EnableTopTilingByEdgeDrag = false;
        StandardHideDesktopIcons = true;
        StandardHideWidgets = true;
      };
    };
  };

  ids.gids.nixbld = 350;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
