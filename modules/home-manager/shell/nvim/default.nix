{ lib, pkgs, config, ... }:

let
  nix-update-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "nix-update-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "reo101";
      repo = "nix-update.nvim";
      rev = "f548b55b49fffe4f8f26d1773107773e1f65aa6e";
      sha256 = "sha256-yeUHoiFi2Wrr2WUKPGJEKXLGH1F+8QoNWNa8ln+ef1k=";
    };
  };
  hmts-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "hmts-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "calops";
      repo = "hmts.nvim";
      rev = "v1.0.0";
      sha256 = "sha256-NNiaHlE02XZyfRj8kXPLOAXlMs2BH1z7Q1AwHS/JTHo=";
    };
  };
  image-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "image-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "samodostal";
      repo = "image.nvim";
      rev = "dcabdf47b0b974b61d08eeafa2c519927e37cf27";
      sha256 = "sha256-NY0jPUTlT70afUU9lz2rEphNlYZpGfn3rjHwb4EhGrA=";
    };
  };
  indentmini-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "indentmini-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvimdev";
      repo = "indentmini.nvim";
      rev = "a432ba5863892f9cf56a9d5a3fac00fdf2280b26";
      sha256 = "sha256-AVurQa359qAJMLOYQBjqnqvuxXtr2ClyfPzIfFI+EaY=";
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
      let g:netrw_liststyle = 3

      " Autocommands for vim-table-mode
      "augroup TableModeSetup
      "  autocmd!
      "  autocmd FileType markdown TableModeEnable
      "  autocmd BufEnter * if &ft != 'markdown' | TableModeDisable | endif
      "augroup END
      " lua require'./plg/markdown_headings.lua'.init()
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
      vim-table-mode
      neo-tree-nvim
      {
        plugin = indentmini-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/indentmini.lua;
      }
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
      #{
      #  plugin = indent-blankline-nvim;
      #  type = "lua";
      #  config = builtins.readFile ./cfg/indent-blankline.lua;
      #}
      # {
      #   plugin = alpha-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/alpha.lua;
      # }
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/catppuccin.lua;
      }
    ];
  };
}
