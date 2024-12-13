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

        # HACK: until https://github.com/NixOS/nixpkgs/issues/360592 is resolved
        permittedInsecurePackages = [
          "aspnetcore-runtime-6.0.36"
          "aspnetcore-runtime-wrapped-6.0.36"
          "dotnet-sdk-6.0.428"
          "dotnet-sdk-wrapped-6.0.428"
        ];
      };
    };
  };
}
