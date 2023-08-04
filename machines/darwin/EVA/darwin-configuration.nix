{ inputs, outputs, config, pkgs, lib, ... }:

{
  imports = with outputs.darwinModules; [
    brew
    yabai
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # karabiner-elements:
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  system = {
    defaults = {
      NSGlobalDomain = {
        # Automatically show and hide the menu bar
        #_HIHideMenuBar = true;

        # Set a fast key repeat rate
        KeyRepeat = 2;

        # Shorten delay before key repeat begins
        InitialKeyRepeat = 24;
      };
      
      dock = {
        # Automatically show and hide the dock
        autohide = true;

        show-recents = false;
      };
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
