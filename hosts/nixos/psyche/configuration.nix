{ inputs, outputs, config, lib, pkgs, ... }:

# to rebuild:
# `sudo nixos-rebuild boot --flake ./#psyche`
# `exit`
# `wsl -t NixOS`
# `wsl -d NixOS --user root exit`
# `wsl -t NixOS`
# run nixos as normal again

{
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.default
    outputs.nixosModules.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "taki";
    interop.register = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    neofetch
    deploy-rs
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
