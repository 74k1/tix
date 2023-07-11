{ lib, pkgs, config, ... }:

with lib;
{
  # Requires Homebrew to be installed
  system.activationScripts.preUserActivation.text = ''
    if ! xcode-select --version 2>/dev/null; then
      $DRY_RUN_CMD xcode-select --install
    fi
    if ! /usr/local/bin/brew --version 2>/dev/null; then
      $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false; # Don't update during rebuild
      upgrade = true;
      cleanup = "zap"; # Uninstall all programs not declared
    };
    global = {
      brewfile = true; # Run brew bundle from anywhere
      lockfiles = false; # Don't save lockfile (since running from anywhere)
    };
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/services"
      # "cmacrae/formulae"
      # "FelixKratz/formulae"
    ];
    brews = [
      # "libusb"
      # "sketchybar" # polybar mac
      # "switchaudio-osx"
    ];
    casks = [
      # "android-platform-tools"
      # "discord"
      # "docker"
      # "font-fira-code-nerd-font"
      "karabiner-elements"
      "caffeine"
      # "scroll-reverser"
      # "sf-symbols"
      # "spotify"
    ];
    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
  };
}
