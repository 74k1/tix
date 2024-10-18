{ lib, pkgs, config, ... }:

let
  tsukiyo-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "tsukiyo-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "74k1";
      repo = "tsukiyo.nvim";
      rev = "ec7c45fde8218b602d1e35e06fb925bf28c3a8c5";
      sha256 = "sha256-4CAQSfv/alS+Cie6Eqhpx16OyOoEsTyM766SkO/6cpI=";
    };
  };
  nix-update-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "nix-update-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "reo101";
      repo = "nix-update.nvim";
      rev = "83062fa4197e7971d1a63cac05d6feaf8378062e";
      sha256 = "sha256-9hTApOq0UFu6oBGNd4Pzou55vS3hSxF//wP1eE3hGS8=";
    };
  };
  hmts-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "hmts-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "calops";
      repo = "hmts.nvim";
      rev = "v1.2.4";
      sha256 = "sha256-8FJlLw5LApQs7S8xEh2UE9wdYCAweZTbvgozCGPfQJc=";
    };
  };
  # image-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "image-nvim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "3rd";
  #     repo = "image.nvim";
  #     rev = "2a618c86d9f8fd9f7895d12b55ec2f31fd14fa05";
  #     sha256 = "sha256-6nFzUchDQIvaTOv4lZ10q66m/ntU3dgVnlfBRodW+0Y=";
  #   };
  # };
  indentmini-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "indentmini-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvimdev";
      repo = "indentmini.nvim";
      rev = "8922b7ec3f1d556b0805d025f0122e50da387303";
      sha256 = "sha256-Mqexuzid4LzncqEfl5Q69ZyNBNGDvs5ULoKhZf9io1o=";
    };
  };
  tfm-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "tfm-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Rolv-Apneseth";
      repo = "tfm.nvim";
      rev = "fb0de2c96bf303216ac5d91ce9bdb7f430030f8b";
      sha256 = "sha256-LiIPVNFEbbkCmqTU+fD23xtTVTIkf6Z5zb+E4Xuz9ps=";
    };
  };
in
{
  imports = [];

  home.packages = with pkgs; [
    ripgrep # For Telescope live-grep
    nil # Nix Language Server
    bash-language-server # Bash :-)
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

      " keybinds
      lua vim.api.nvim_create_user_command("E", "Oil", {})
      "lua vim.keymap.set("n", "-", function() vim.cmd.Oil() end, {})

      " set t_Co=0
      " set background=none
      " lua vim.opt.termguicolors = false
      "let g:netrw_liststyle = 3
      
      " Autocommands for vim-table-mode
      "augroup TableModeSetup
      "  autocmd!
      "  autocmd FileType markdown TableModeEnable
      "  autocmd BufEnter * if &ft != 'markdown' | TableModeDisable | endif
      "augroup END
      " lua require'./plg/markdown_headings.lua'.init()
    '';
    plugins = with pkgs.vimPlugins; [
      # neo-tree-nvim
      # oxocarbon-nvim
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      comment-nvim
      hmts-nvim
      luasnip
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      telescope-nvim
      tfm-nvim
      venn-nvim
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui
      vim-nix
      # vim-table-mode
      vim-shellcheck
      {
        plugin = oxocarbon-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/oxocarbon.lua;
      }
      # {
      #   plugin = tsukiyo-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/tsukiyo.lua;
      # }
      {
        plugin = markview-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/markview.lua;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./cfg/lspconfig.lua;
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./cfg/cmp.lua;
      }
      {
        plugin = fidget-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/fidget.lua;
      }
      {
        plugin = indentmini-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/indentmini.lua;
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/oil.lua;
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
      # {
      #   plugin = image-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/image.lua;
      # }
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
      # {
      #   plugin = indent-blankline-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/indent-blankline.lua;
      # }
      # {
      #   plugin = alpha-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/alpha.lua;
      # }
      # {
      #   plugin = catppuccin-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/catppuccin.lua;
      # }
    ];
  };
}
