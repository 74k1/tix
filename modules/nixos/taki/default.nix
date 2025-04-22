{ inputs, outputs, lib, config, pkgs, allSecrets, ... }:
{
  options = {
    taki.gui = {
      enable = lib.mkEnableOption "GUI environment config";
    };
  };

  config = lib.mkMerge [
    {
      # define user account - don't forget to set password with `passwd`
      users.users.taki = {
        isNormalUser = true;
        description = "taki";
        extraGroups = [ "wheel" "networkmanager" "plex" "user-with-access-to-virtualbox" ];
        openssh.authorizedKeys.keys = allSecrets.per_service.openssh.authorizedKeys.keys;
        shell = pkgs.zsh;
      };
    }

    # GUI stuff
    (lib.mkIf config.taki.gui.enable {
      fonts = {
        fontDir.enable = true;
        #enableGhostsriptFonts = true;
        packages = with pkgs; [
          cantarell-fonts
          hack-font
          inter
          jetbrains-mono
          liberation_ttf
          monaspace
          noto-fonts
          noto-fonts-extra
          ubuntu_font_family
          ubuntu-sans
          ubuntu-sans-mono
          nerd-fonts.fira-code
          nerd-fonts.droid-sans-mono
          nerd-fonts.jetbrains-mono
          nerd-fonts.noto
          nerd-fonts.hack
          nerd-fonts.tinos
          nerd-fonts.mplus
          nerd-fonts.lilex
          nerd-fonts.zed-mono
          
          inputs.unfree-fonts.packages.x86_64-linux.berkeley-nolig-nerd-otf
        ];
      };
    })
  ];
}
