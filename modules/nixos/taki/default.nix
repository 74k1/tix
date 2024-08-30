{ inputs, outputs, lib, config, pkgs, ... }:
let
  berkeley-ttf = pkgs.callPackage "${inputs.self}/pkgs/berkeley-ttf.nix" { inherit pkgs; };
in
{
  options = {
    taki.gui = {
      # NEW way: bool, default false --v
      enable = lib.mkEnableOption "GUI environment config";

      # OG way: --v
      # enable = lib.mkOption {
      #   type = lib.types.bool;
      #   description = "is GUI environment?";
      #   default = false;
      # };
    };
  };

  config = lib.mkMerge [
    # Normal stuff, always enabled
    {
      # define user account - don't forget to set password with `passwd`
      users.users.taki = {
        isNormalUser = true;
        description = "taki";
        extraGroups = [ "wheel" "networkmanager" "plex" ];
        # packages = with pkgs; [];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmB5TLlaoy7JVpMYP0voMEQrGn2WGYapppxnQRD5JRS knights"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhjipcpqKCIRFK3o5QqqjGteAFEJdabnZqgraK2n8pa psyche"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5VblfuasqhILQMzPNsJiEl4jVw+9HSa4rvH8ftHGZL navi"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAixkN1qkHsQI752vzxubx/2cGpuQN+ZFbMUswC3lBga wired"
          # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmsit4uJM5PL6HBiyHlC7fMhI9MvfK4fwVeK3lZnpjk EVA"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVrGnNjwaQ8CL4IBKWx0Z3A+PFpy96r0t8e2zc7jRr+ eiri"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcSDZxE2I6ViR3oEMBGANuJeHqIUaq1MBYcRxokSOwR cyberia"
          "ssh-rsa blabla xyz@xyz"
        ];
        shell = pkgs.zsh;
      };

      programs.ssh = {
        startAgent = true;
        agentTimeout = "1h";
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
