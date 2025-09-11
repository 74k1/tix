{
  inputs,
  self,
  lib,
  config,
  ...
}:

{
  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs =
        let
          overlays = lib.attrValues self.overlays ++ [
            inputs.nix-topology.overlays.default

            # NOTE: `tixpkgs` -> `pkgs.tix.*`
            # NOTE: `tixpkgs-unfree` -> `pkgs.tix-unfree.*`

            # (_: _: inputs.tixpkgs.packages.${system})
            # (_: _: inputs.tixpkgs-unfree.packages.${system})

            # (_: _: {
            #   tix = inputs.tixpkgs.packages.${system};
            #   tix-unfree = inputs.tixpkgs-unfree.packages.${system};
            # })

            inputs.tixpkgs.overlays.default
            inputs.tixpkgs-unfree.overlays.default

            (final: prev: {
              tix = inputs.tixpkgs.overlays.default final prev;
              tix-unfree = inputs.tixpkgs-unfree.overlays.default final prev;
            })

            # Pseudo-overlay to add our own packages everywhere
            (_: _: self.packages.${system})

            # NOTE: `nixpkgs-stable` -> `pkgs.stable.*`
            # NOTE: `nixpkgs-master` -> `pkgs.master.*`
            # NOTE: `nixpkgs` -> `pkgs.*`
            (
              _: _:
              lib.pipe inputs [
                (lib.concatMapAttrs (
                  name: input:
                  lib.optionalAttrs (lib.hasPrefix "nixpkgs-" name) {
                    ${lib.removePrefix "nixpkgs-" name} = import input {
                      inherit system;
                      inherit overlays;
                      inherit config;
                    };
                  }
                ))
              ]
            )
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
        in
        import inputs.nixpkgs {
          inherit system;
          inherit overlays;
          inherit config;
        };
    };
}
