{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    # NOTE: update every 6 months
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    "nixpkgs-24.11" = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs/master";
    };
    tixpkgs = {
      url = "github:74k1/tixpkgs/main";
      # url = "git+file:///home/taki/dev/tixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs-local = {
    #   url = "git+file:///home/taki/dev/nixpkgs";
    # };
    unfree-fonts = {
      url = "git+ssh://git@github.com/74k1/unfree-fonts-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # -- TESTS / FIXES
    jvanbruegge-linkwarden = {
      url = "github:jvanbruegge/nixpkgs/linkwarden";
    };
    diogotcorreira-umami = {
      url = "github:diogotcorreia/nixpkgs/umami-init";
    };
    nixpkgs-akotro-it-tools = {
      url = "github:akotro/nixpkgs/add-it-tools-service";
    };
    jf-uu-overseerr = {
      url = "github:jf-uu/nixpkgs/overseerr";
    };
    # --
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
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
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      # NOTE: not overriding since NixOS-WSL is flaky (relies on stable)
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry-pi-nix = {
      url = "github:nix-community/raspberry-pi-nix";
    };
    # arion = {
    #   url = "github:hercules-ci/arion";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.darwin.follows = "";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
    };
    blog = {
      url = "git+ssh://git@github.com/74k1/blog.git";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crowdsec = {
      url = "git+https://codeberg.org/kampka/nix-flake-crowdsec.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
      # url = "github:AndyFilter/YeetMouse/driver/experimental?dir=nix";
      url = "github:kitten/YeetMouse/@kitten/feat/update-nix-module-options?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # url = "github:hyprwm/Hyprland";
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
    ukiyo = {
      url = "github:74k1/ukiyo";
    };
    ChessSet = {
      url = "github:74k1/ChessSet";
    };
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ironbar = {
      url = "github:JakeStanger/ironbar";
      # url = "git+file:///home/taki/dev/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vpnconfinement = {
      url = "github:Maroka-chan/VPN-Confinement";
      # url = "github:74k1/VPN-Confinement";
    };
    ouro = {
      # url = "git+file:///home/taki/dev/ouro";
      url = "github:reo101/ouro";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };
    filestash-nix = {
      url = "github:MatthewCroughan/filestash-nix";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "github:74k1/affinity-nix/patch";
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
        ./modules/flake/modules.nix
        ./modules/flake/agenix.nix
        ./modules/flake/topology.nix
        ./modules/flake/nixpkgs.nix
        inputs.rix101.flakeModules.agenix
      ];

      debug = true;

      perSystem = { self, lib, pkgs, system, inputs', ... }: {
        # Stuff with auto-inserted ${system}, like `packages` and `devShells`
      };

      flake = {
        # Stuff that gets directly exported, like `nixosConfigurations`
      };
    });
}
