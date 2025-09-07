{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = with outputs.darwinModules; [
    brew
    # aerospace
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    btop
    utm
    imagemagick
    neovim
    powershell
    qmk
    rectangle
    skim
    tealdeer
    tmux
    pandoc
    texliveBasic
    vim
    zellij
    qemu
    pinentry_mac
    gnupg
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Flakes and Nix Commands
  nix = {
    enable = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
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
    #   tim.raschle ALL = (ALL) ALL
    # '';
  };

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  # GPG as Agent
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # system config
  system = {
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
