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
      rev = "v1.2.3";
      sha256 = "sha256-kw3YJ21nhs/x9Jp7kvnL+9FuiSgLB1hO/ON3QeeZx9g=";
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
      rev = "a432ba5863892f9cf56a9d5a3fac00fdf2280b26";
      sha256 = "sha256-AVurQa359qAJMLOYQBjqnqvuxXtr2ClyfPzIfFI+EaY=";
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
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      comment-nvim
      venn-nvim
      hmts-nvim
      luasnip
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      telescope-nvim
      tfm-nvim
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui
      vim-nix
      vim-table-mode
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
