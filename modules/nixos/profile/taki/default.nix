{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  allSecrets,
  ...
}:
{
  options = {
    taki.gui = {
      enable = lib.mkEnableOption "GUI environment config";
    };
  };

  config = lib.mkMerge [
    {
      # define user account - don't forget to set password with `passwd`
      users = {
        mutableUsers = true;
        users.taki = {
          isNormalUser = true;
          description = "taki";
          extraGroups = [
            "wheel"
            "networkmanager"
            "plex"
            "user-with-access-to-virtualbox"
          ];
          openssh.authorizedKeys.keys = allSecrets.per_service.openssh.authorizedKeys.keys;
          shell = pkgs.zsh;
          initialHashedPassword = "$6$TbBYnHu9RRCkuV6.$q7aBn/LLC2doT6MKoFY9yV8j9qzNz45UWmaMgCsGCKrb0pf7kpPmcBzrc7puOmoJT5B5Cz/guST2.WFgs2FKo1";
        };
      };
    }

    # GUI stuff
    (lib.mkIf config.taki.gui.enable {
      fonts = {
        fontDir.enable = true;
        #enableGhostsriptFonts = true;
        packages = with pkgs; [
          # my own super cool fonts
          # inputs.tixpkgs-unfree.packages.x86_64-linux.berkeley-nolig-otf
          inputs.tixpkgs-unfree.packages.x86_64-linux.suisse-intl-mono
          inputs.apple-emoji.packages.x86_64-linux.apple-emoji-linux

          # main fonts
          corefonts
          vistafonts

          jetbrains-mono
          nerd-fonts.fira-code
          nerd-fonts.droid-sans-mono
          nerd-fonts.jetbrains-mono
          ubuntu_font_family
          ubuntu-sans
          ubuntu-sans-mono

          # others
          helvetica-neue-lt-std
          cantarell-fonts
          hack-font
          inter
          liberation_ttf
          monaspace
          fragment-mono
          # noto-fonts
          # noto-fonts-extra
          nerd-fonts.noto
          nerd-fonts.hack
          nerd-fonts.tinos
          nerd-fonts.lilex
          nerd-fonts.zed-mono

        ];
      };
    })
  ];
}
