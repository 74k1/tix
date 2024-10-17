{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs/master";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      # NOTE: not overriding since NixOS-WSL is flaky (relies on stable)
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.darwin.follows = "";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yeetmouse = {
      url = "github:74k1/YeetMouse/master?dir=nix";
      # url = "github:AndyFilter/YeetMouse/master?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # url = "github:hyprwm/Hyprland";
    };
    stylix = {
      url = "github:danth/stylix";
    };
    #rix101 = {
    #  url = "github:reo101/rix101";
    #};
    ukiyo = {
      url = "github:74k1/ukiyo";
    };
    ChessSet = {
      url = "github:74k1/ChessSet";
    };
    wired-notify = {
      url = "github:Toqozz/wired-notify";
    };
    vpnconfinement = {
      url = "github:Maroka-chan/VPN-Confinement";
      #url = "github:74k1/VPN-Confinement";
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
    };
    zen-browser = {
      #url = "github:heywoodlh/flakes/main?dir=zen-browser";
      url = "github:ch4og/zen-browser-flake";
    };
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      # url = "git+file:///home/taki/dev/ghostty/";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, flake-parts-lib, ... }: {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      imports = [
        ./modules/flake/configurations.nix
        ./modules/flake/devshells.nix
        ./modules/flake/packages.nix
        ./modules/flake/modules.nix
        ./modules/flake/agenix.nix
        ./modules/flake/topology.nix
        ./modules/flake/pkgs.nix
      ];

      perSystem = { self, lib, pkgs, system, inputs', ... }: {
        # Stuff with auto-inserted ${system}, like `packages` and `devShells`
      };

      flake = {
        # Stuff that gets directly exported, like `nixosConfigurations`
      };
    });
}
