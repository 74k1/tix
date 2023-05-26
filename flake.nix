{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    rix101 = {
      url = "github:reo101/rix101";
    };
  };

  outputs =
    { self
    , nixpkgs
    , rix101
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        taki = lib.nixosSystem {
          inherit system;

          modules = [ ./configuration.nix ];

          specialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
