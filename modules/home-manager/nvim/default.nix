{ lib, pkgs, config, ... }:

let
  nix-update-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nix-update-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "reo101";
      repo = "nix-update.nvim";
      rev = "dd6f1d3ac74fd6b33e4f2d35274400cd27b48c2f";
      sha256 = "sha256-4wEVHSBrKkZvpfidyrgRn0idcINbK0jyDvSEiTDFCus=";
    };
  };
  hmts-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "hmts-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "calops";
      repo = "hmts.nvim";
      rev = "v1.0.0";
      sha256 = "sha256-NNiaHlE02XZyfRj8kXPLOAXlMs2BH1z7Q1AwHS/JTHo=";
    };
  };
  image-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "image-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "samodostal";
      repo = "image.nvim";
      rev = "dcabdf47b0b974b61d08eeafa2c519927e37cf27";
      sha256 = "sha256-NY0jPUTlT70afUU9lz2rEphNlYZpGfn3rjHwb4EhGrA=";
    };
  };
in
{
  imports = [];

  home.packages = with pkgs; [
    ripgrep # For Telescope live-grep
  ];
  
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraConfig = ''
      set shiftwidth=2 softtabstop=2 expandtab
      set number relativenumber
      set clipboard=unnamedplus
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      comment-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      hmts-nvim
      vim-dadbod
      vim-dadbod-ui
      vim-dadbod-completion
      {
        plugin = nix-update-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/nix-update.lua;
      }
      {
        plugin = clipboard-image-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/clipboard-image.lua;
      }
      {
        plugin = image-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/image.lua;
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = builtins.readFile ./cfg/autopairs.lua;
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = builtins.readFile ./cfg/colorizer.lua;
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/indent-blankline.lua;
      }
      {
        plugin = alpha-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/alpha.lua;
      }
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/catppuccin.lua;
      }
    ];
  };
}
