{pkgs, ...}: let
  yueye-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "yueye-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "74k1";
      repo = "yueye.nvim";
      rev = "4c4b63a18daf1efc69244f60af5b8a2ce9ea67bb";
      hash = "sha256-9OO2kUI9lZeTEk2am+nw8CCBL7t3F2J+WItLMKEEMKY=";
    };
  };
  nix-update-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "nix-update-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "reo101";
      repo = "nix-update.nvim";
      rev = "6d21b62b08ae483798855d5bf5cb7b78b78e3bad";
      hash = "sha256-Ld3Tmkc3k8jSY40z+9Em8M1rDSVz7lnll60KMJb22JQ=";
    };
  };
  # hmts-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "hmts-nvim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "calops";
  #     repo = "hmts.nvim";
  #     rev = "v1.2.5";
  #     hash = "sha256-V5dwIJdxBulFVKk1iSlf4H5NRz1UH7uYQeMvwtgkpIs=";
  #   };
  # };
in {
  imports = [];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraLuaPackages = ps: [
      ps.magick # for image.nvim
    ];
    extraPackages = [
      pkgs.ripgrep # For Telescope live-grep
      pkgs.bash-language-server # Bash :-)
      pkgs.nixd # Nix Language Server
      pkgs.alejandra # Nix Formatter
      pkgs.rust-analyzer # Rust Language Server
      pkgs.vscode-langservers-extracted # HTML, CSS, JSON, ESLINT Language Server
      # pkgs.superhtml # HTML Language Server
      pkgs.tinymist # Typst Language Server
      pkgs.emmet-ls # Emmet Language Server (cool snippets)
      pkgs.imagemagick # for image.nvim
      pkgs.curl # for image.nvim remote images
      # pkgs.nodejs # for copilot-lua
    ];
    extraConfig =
      /*
      vim
      */
      ''
        set shiftwidth=2 softtabstop=2 expandtab
        set number relativenumber
        set clipboard=unnamedplus

        lua vim.g.mapleader = " "

        " Oil
        lua vim.keymap.set("n", "-", "<cmd>Oil<CR>")
        lua vim.api.nvim_create_user_command("E", "Oil", {})

        " Find Files
        lua vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
        lua vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
        lua vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

        lua vim.opt.iskeyword:append("-")
        lua vim.opt.iskeyword:remove(":")
        
        " rest
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
      # vim-table-mode
      cmp-buffer
      cmp-cmdline
      cmp-emoji
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      comment-nvim
      nvzone-typr
      # hmts-nvim
      oxocarbon-nvim
      typst-preview-nvim
      luasnip
      nvim-tree-lua
      parinfer-rust
      telescope-nvim
      venn-nvim
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui
      vim-nix
      vim-shellcheck
      {
        plugin = yueye-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/yueye.lua;
      }
      {
        plugin = mini-ai;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("mini.ai").setup()
          '';
      }
      {
        plugin = mini-map;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("mini.map").setup()
          '';
      }
      {
        plugin = mini-indentscope;
        type = "lua";
        config =
          /*
          lua
          */
          ''
          require("mini.indentscope").setup({
            draw = {
              delay = 0,
              animation = require("mini.indentscope").gen_animation.none()
            },
            options = {
              try_as_border = true
            },
            symbol = "│"
          })
          '';
      }
      {
        plugin = mini-fuzzy;
        type = "lua";
        config =
          /*
          lua
          */
          ''
          require("mini.fuzzy").setup()
          '';
      }
      {
        plugin = mini-diff;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("mini.diff").setup()
          '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./cfg/TSconfig.lua;
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/lualine.lua; 
      }
      # {
      #   plugin = let-it-snow-nvim;
      #   type = "lua";
      #   config =
      #     /*
      #     lua
      #     */
      #     ''
      #       require('let-it-snow').setup({delay = 50})
      #     '';
      # }
      # {
      #   plugin = copilot-cmp;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/copilot-cmp.lua;
      # }
      # {
      #   plugin = copilot-lua;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/copilot-lua.lua;
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
      # {
      #   plugin = indentmini-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/indentmini.lua;
      # }
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
      # {
      #   plugin = clipboard-image-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/clipboard-image.lua;
      # }
      {
        plugin = img-clip-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/img-clip.lua;
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
    ];
  };
}
