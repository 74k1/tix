{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Requires Homebrew to be installed
  # system.activationScripts.preUserActivation.text = ''
  #   if ! xcode-select --version 2>/dev/null; then
  #     $DRY_RUN_CMD xcode-select --install
  #   fi
  #   if ! /usr/local/bin/brew --version 2>/dev/null; then
  #     $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  #   fi
  # '';

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false; # Don't update during rebuild
      upgrade = true;
      cleanup = "zap"; # Uninstall all programs not declared
    };
    global = {
      brewfile = true; # Run brew bundle from anywhere
    };
    taps = [
      # "FelixKratz/formulae"
      # "LizardByte/homebrew"
      # "cmacrae/formulae"
      # "homebrew/cask"
      # "homebrew/cask-fonts"
      # "homebrew/core"
      # "homebrew/services"
      # "hashicorp/tap"
      # "acsandmann/tap"
      {
        name = "edde746/plezy";
        clone_target = "https://github.com/edde746/plezy.git"; # repo isn't homebrew- prefixed, needs explicit url
        trusted = true; # homebrew 6 refuses untrusted taps during activation otherwise
      }
    ];
    brews = [
      # "sunshine"
      "fd"
      "ffmpegthumbnailer"
      "jq"
      "poppler"
      "unar"
      "zoxide"
    ];
    casks = [
      "waterfox"
      "plezy" # from plezy tap
      "alt-tab"
      "bitwarden"
      # "affinity-photo"
      # "affinity-designer"
      # "affinity-publisher"
      "ghostty"
      "hiddenbar"
      # "insomnia"
      # "kap"
      "keka"
      "kekaexternalhelper"
      "maccy"
      # "notunes"
      # "obsidian"
      "raycast"
      "shottr"
      "stats"
      # "windows-app"
      # "powershell"
      "zed"
      # "rustdesk"
      "localsend"
    ];
    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
  };
}
