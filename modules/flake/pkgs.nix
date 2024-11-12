{ inputs, self, lib, config, ... }:

{
  perSystem = { pkgs, system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = lib.attrValues self.overlays ++ [
        inputs.nix-topology.overlays.default
        # Pseudo-overlay to add our own packages everywhere
        (_: _: self.packages.${system})
      ];
      config = {
        allowUnfree = true;
        # hack, might work, forgor
        allowUnfreePredicate = _: true;
      };
    };
  };
}
