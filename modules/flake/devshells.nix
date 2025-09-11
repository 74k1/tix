{
  lib,
  config,
  self,
  inputs,
  withSystem,
  ...
}:
{
  perSystem =
    {
      self,
      lib,
      pkgs,
      system,
      inputs',
      ...
    }:
    {
      devShells = {
        # usage:
        # `nix develop <name>`
        default = pkgs.mkShell {
          buildInputs = [
            # pkgs.git
            # inputs'.agenix-rekey.packages.agenix-rekey
            # inputs'.deploy-rs.packages.deploy-rs
            inputs'.rix101.packages.nix-enraged
            (inputs'.nixpkgs.legacyPackages.nh.override {
              nix = inputs'.rix101.packages.nix-enraged;
            })
            (inputs'.nixos-anywhere.packages.nixos-anywhere.override {
              nix = inputs'.rix101.packages.nix-enraged;
            })
            (inputs'.nixpkgs.legacyPackages.nixos-rebuild.override {
              nix = inputs'.rix101.packages.nix-enraged;
            })
            (inputs'.nixpkgs.legacyPackages.nixos-rebuild-ng.override {
              nix = inputs'.rix101.packages.nix-enraged;
            })
          ];
        };
        # with-macchina = pkgs.mkShell {
        #   buildInputs = with pkgs; [
        #     macchina
        #   ];
        # };
      };
    };
}
