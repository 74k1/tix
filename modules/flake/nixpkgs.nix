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

            # NOTE: `tixpkgs` -> `pkgs.tix.*`
            # NOTE: `tixpkgs-unfree` -> `pkgs.tix-unfree.*`
            # NOTE: `tixpkgs-<suffix>` -> `pkgs.tix-<suffix>.*`
            (final: prev:
              lib.pipe inputs [
                (lib.concatMapAttrs (
                  name: input:
                  lib.optionalAttrs (lib.hasPrefix "tixpkgs" name) {
                    ${("tix" + lib.removePrefix "tixpkgs" name)} = input.overlays.default final prev;
                  }
                ))
              ])

            # DGX Spark (lain): NVIDIA kernel needs linux_6_17 which upstream
            # throws on post-EOL; alias to linux_latest — dgx-spark.nix fully
            # overrides src/version/config anyway.
            # CUDA settings likewise live here because the dgx-spark module
            # cannot set nixpkgs.config under lain's external pkgs instance.
            ]
            ++ lib.optionals (system == "aarch64-linux") [
              (final: prev: {
                linux_6_17 = prev.linux_latest;
                linuxPackages_6_17 = prev.linuxPackagesFor final.linux_6_17;
              })
            ] ++ [
            # NOTE: `multiverse` -> `pkgs.multiverse.*` — NOT an importable
            # nixpkgs (so it must NOT be named `nixpkgs-*`); version-index
            # API: `tip`/`at`/`version`/`solvePins`. Each distinct revision
            # costs a nixpkgs fetch + eval the first time it is forced.
            (_: _: { multiverse = inputs.multiverse.multiverse.${system}; })

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

            permittedInsecurePackages = [
              "pnpm-9.15.9" # bluesky-pds
            ];
          } // lib.optionalAttrs (system == "aarch64-linux") {
            # DGX Spark GB10 (Blackwell sm_120)
            cudaSupport = true;
            cudaCapabilities = [ "12.0" "12.1" ];
          };
        in
        import inputs.nixpkgs {
          inherit system;
          inherit overlays;
          inherit config;
        };
    };
}
