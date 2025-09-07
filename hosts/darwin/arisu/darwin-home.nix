{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = with outputs.homeManagerModules; [
    neovim
    git
    jujutsu
    zsh
    fish
    # syncthing
    # ssh
    # ghostty
  ];

  home = {
    username = lib.mkForce "taki";
    homeDirectory = lib.mkForce "/Users/taki";
    stateVersion = "23.05";

    packages = with pkgs; [
      bat-extras.batman
      keepassxc
      joshuto
      # neovim
    ];
  };

  # programs.wezterm = {
  #   transparency = false;
  # };

  # install macos applications to the user env if targetplatform is darwin
  home.file."Applications/home-manager".source =
    let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in
    lib.mkIf pkgs.stdenv.targetPlatform.isDarwin "${apps}/Applications";

  disabledModules = [
    "target/darwin/linkapps.nix"
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry_mac;
    enableSshSupport = true;
  };

  # Set env vars
  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
