{ inputs, outputs, lib, config, pkgs, ... }:
let
  berkeley-ttf = pkgs.callPackage "${inputs.self}/pkgs/berkeley-ttf.nix" { inherit pkgs; };
in
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
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 blabla xyz@xyz" # GPG
          "ssh-rsa blabla xyz@xyz"
        ];
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
          ubuntu_font_family
          (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono"]; } )
          berkeley-ttf
        ];
      };
    })
  ];
}
