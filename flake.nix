{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    # NOTE: update every 6 months
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };
    # "nixpkgs-24.11" = {
    #   # fprintd
    #   url = "github:NixOS/nixpkgs/nixos-24.11";
    # };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs/master";
    };
    # nixpkgs-local = {
    #   url = "git+file:///home/taki/dev/nixpkgs";
    # };
    # --- my own flakes
    tixpkgs = {
      url = "github:74k1/tixpkgs/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    tixpkgs-unfree = {
      url = "git+ssh://forge@git.yukume.com/74k1/tixpkgs-unfree.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blog = {
      url = "git+ssh://git@github.com/74k1/blog.git";
    };
    snqn-nvim = {
      url = "github:snqn/nvim";
    };
    ukiyo = {
      url = "github:74k1/ukiyo";
    };
    bumpkin = {
      url = "git+ssh://forge@git.yukume.com/74k1/bumpkin.git";
    };
    ouro = {
      url = "github:reo101/ouro";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    aurora = {
      url = "git+ssh://forge@git.yukume.com/74k1/aurora.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vesper = {
      url = "git+ssh://forge@git.yukume.com/74k1/vesper.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    braindump = {
      url = "git+ssh://forge@git.yukume.com/74k1/braindump.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # --- TESTS / FIXES
    hythera-waterfox = {
      url = "github:hythera/nixpkgs/pkgs/waterfox/init";
    };
    pjrm-sure = {
      url = "github:pjrm/nixpkgs/nixossure";
    };
    # --- HIGH IMPORTANCE ---
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
    # ---
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
    sherlock-gpui = {
      url = "github:skxxtz/sherlock-gpui";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:epireyn/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-unstable = {
        url = "github:niri-wm/niri/main";
        flake = false;
      };
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
    vpnconfinement.url = "github:Maroka-chan/VPN-Confinement";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix/push-orwvsztwlunu";
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "github:74k1/affinity-nix/patch";
    };
    dgx-spark.url = "github:graham33/nixos-dgx-spark";
    glm53-flash = {
      url = "github:MiaAI-Lab/GLM-5.3-Flash-EXL3-2x-DGX-Sparks";
      flake = false;
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zeroclaw = {
      # pinned to v0.8.5 — master's hashes.json is out of sync with its
      # Cargo.lock, which breaks eval of the package. Re-pin to master once
      # upstream fixes it. NOTE: keep schema_version = 3 in the instance
      # settings — without it the config loader runs the legacy migration
      # and silently drops [channels.*] + [providers.models.*].
      url = "github:zeroclaw-labs/zeroclaw/v0.8.5";
      inputs.nixpkgs.follows = "nixpkgs";
      # upstream's committed lock pins a fenix whose stable toolchain is
      # below zeroclaw's MSRV — redirect so the toolchain tracks current
      # stable.
      inputs.fenix.follows = "fenix";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
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
          { ... }:
          {
            # Stuff with auto-inserted ${system}, like `packages` and `devShells`
          };

        flake = {
          # Stuff that gets directly exported, like `nixosConfigurations`
        };
      }
    );
}
