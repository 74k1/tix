{ inputs, self, lib, config, ... }:

{
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = lib.attrValues self.overlays ++ [
        inputs.nix-topology.overlays.default
      ];
      config = {
        allowUnfree = true;
      };
    };
  };
}
