{ lib, pkgs, config, ... }:
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
      # "LizardByte/homebrew"
      # "cmacrae/formulae"
      # "FelixKratz/formulae"
    ];
    brews = [
      # "sunshine"
      "fd"
      "ffmpegthumbnailer"
      "jq"
      "poppler"
      "python@3.10"
      "syncthing"
      "unar"
      "yazi"
      "zoxide"
    ];
    casks = [
      # "docker"
      "alt-tab"
      "affinity-photo"
      "affinity-designer"
      "affinity-publisher"
      # "bitwarden"
      "parsec"
      "orion"
      "zen"
      "ghostty"
      # "github"
      # "slack"
      # "hiddenbar"
      # "insomnia"
      # "kap"
      "keka"
      "kekaexternalhelper"
      "maccy"
      # "notunes"
      # "obsidian"
      # "raycast"
      "shottr"
      "stats"
      # "windows-app"
      # "powershell"
      "zed"
      "rustdesk"
      # "yazi"
      # "jq"
      # "ffmpegthumbnailer"
      # "unar"
      # "jq"
      # "poppler"
      # "fd"
      # "ripgrep"
      # "fzf"
      # "zoxide"
    ];
    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
  };
}
