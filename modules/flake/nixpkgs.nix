{ inputs, self, lib, config, ... }:

{
  perSystem = { pkgs, system, ... }: {
    _module.args.pkgs = let
      overlays = lib.attrValues self.overlays ++ [
        inputs.nix-topology.overlays.default

        (_: _: inputs.tixpkgs.packages.${system})

        # Pseudo-overlay to add our own packages everywhere
        (_: _: self.packages.${system})
      ];
    in import inputs.nixpkgs {
      inherit system;
      overlays = overlays ++ [
        # NOTE: `nixpkgs-stable` -> `pkgs.stable.*`
        # NOTE: `nixpkgs-master` -> `pkgs.master.*`
        # NOTE: `nixpkgs` -> `pkgs.*` 
        (_: _: lib.pipe inputs [
          (lib.concatMapAttrs
            (name: input:
              if lib.hasPrefix "nixpkgs-" name then {
                ${lib.removePrefix "nixpkgs-" name} = import input {
                  inherit system;
                  inherit overlays;
                };
              } else {
              }))
        ])
        # NOTE: `tixpkgs` -> `pkgs.tix.*`
        (_: _: {
          tix = inputs.tixpkgs.packages.${system};
        })
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
