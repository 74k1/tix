{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    # NOTE: update every 6 months
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };
    "nixpkgs-24.11" = {
      # fprintd
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs/master";
    };
    tixpkgs = {
      url = "github:74k1/tixpkgs/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixpkgs-local = {
      url = "git+file:///home/taki/dev/nixpkgs";
    };
    tixpkgs-unfree = {
      url = "git+ssh://forge@git.yukume.com/74k1/tixpkgs-unfree.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # --- my own flakes
    blog = {
      url = "git+ssh://git@github.com/74k1/blog.git";
    };
    snqn-nvim = {
      url = "github:snqn/nvim";
    };
    ukiyo = {
      url = "github:74k1/ukiyo";
    };
    ChessSet = {
      url = "github:74k1/ChessSet";
    };
    ouro = {
      url = "github:reo101/ouro";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    # --- TESTS / FIXES
    nixpkgs-akotro-it-tools = {
      url = "github:akotro/nixpkgs/add-it-tools-service";
    };
    the-argus-emptty = {
      url = "github:the-argus/nixpkgs/emptty/module";
    };
    hythera-waterfox = {
      url = "github:hythera/nixpkgs/pkgs/waterfox/init";
    };
    # ---
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "git+file:///home/taki/dev/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quadlet = {
      url = "github:SEIAROTg/quadlet-nix";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elephant = {
      url = "github:abenz1267/elephant";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      # NOTE: not overriding since NixOS-WSL is flaky (relies on stable)
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry-pi-nix = {
      url = "github:nix-community/raspberry-pi-nix";
    };
    sherlock-gpui = {
      url = "github:skxxtz/sherlock-gpui";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:AndyFilter/YeetMouse?dir=nix";
      # url = "github:kitten/YeetMouse/@kitten/feat/update-nix-module-options?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    rix101 = {
      url = "github:reo101/rix101";
      # NOTE: to reduce duplication of transitive inputs
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.agenix.follows = "agenix";
      inputs.agenix-rekey.follows = "agenix-rekey";
    };
    vpnconfinement = {
      url = "github:Maroka-chan/VPN-Confinement";
      # url = "github:74k1/VPN-Confinement";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix/push-orwvsztwlunu";
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "github:74k1/affinity-nix/patch";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, flake-parts-lib, ... }:
      {
        systems = [
          "aarch64-linux"
          "x86_64-linux"
          "aarch64-darwin"
        ];

        imports = [
          ./modules/flake/configurations.nix
          ./modules/flake/devshells.nix
          ./modules/flake/modules.nix
          ./modules/flake/agenix.nix
          ./modules/flake/topology.nix
          ./modules/flake/nixpkgs.nix
          inputs.rix101.inputs.flake-file.flakeModules.default
          inputs.rix101.flakeModules.agenix
        ];

        debug = true;

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
            # Stuff with auto-inserted ${system}, like `packages` and `devShells`
          };

        flake = {
          # Stuff that gets directly exported, like `nixosConfigurations`
        };
      }
    );
}
