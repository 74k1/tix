{ inputs, pkgs, ... }:
let
  # yueye-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "yueye-nvim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "74k1";
  #     repo = "yueye.nvim";
  #     rev = "48c1f7db1f8b5b52c3bf458a94ecc6adcc8061b3";
  #     hash = "sha256-6U9JD9G+4WicTdOIq5J8lc0DDH2jZf5h87m3EPswn5w=";
  #   };
  # };
  nix-update-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "nix-update-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "reo101";
      repo = "nix-update.nvim";
      rev = "d9224e2c5f5a44cbab6d017211a88fdf9674063b";
      hash = "sha256-li3febSwIFL6JZPUFdm3pmRFu2TUv7h3NmyjvrJR5QE=";
    };
  };
  vim-log-highlighting = pkgs.vimUtils.buildVimPlugin {
    name = "vim-log-highlighting";
    src = pkgs.fetchFromGitHub {
      owner = "mtdl9";
      repo = "vim-log-highlighting";
      rev = "v1.0.0";
      hash = "sha256-OtPNGa73CLKXJQJgDJNHiGZc7/nQUnZSpZXsBr1KRts=";
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
in
{
  imports = [ ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
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
      pkgs.nil # Nix Language Server
      pkgs.nixfmt # Nix Formatter
      pkgs.rust-analyzer # Rust Language Server
      pkgs.vscode-langservers-extracted # HTML, CSS, JSON, ESLINT Language Server
      # pkgs.superhtml # HTML Language Server
      pkgs.tinymist # Typst Language Server
      pkgs.emmet-ls # Emmet Language Server (cool snippets)
      pkgs.imagemagick # for image.nvim
      pkgs.curl # for image.nvim remote images
    ];
    extraConfig =
      # vim
      ''
        set shiftwidth=2 softtabstop=2 expandtab
        set number relativenumber
        set clipboard=unnamedplus
        set termguicolors

        lua vim.g.mapleader = " "

        " Oil
        lua vim.keymap.set("n", "-", "<cmd>Oil<CR>")
        lua vim.api.nvim_create_user_command("E", "Oil", {})

        " Find Files
        lua vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
        lua vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
        lua vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

        " img-clip (paste image)
        lua vim.keymap.set("n", "<leader>p", "<cmd>PasteImage<CR>")

        lua vim.opt.iskeyword:append("-")
        lua vim.opt.iskeyword:remove(":")

        " terminal escape
        lua vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")
      '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = inputs.snqn-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
        type = "lua";
        config =
        # lua
        ''
          require("snqn").setup({
            transparent = true,
          })

          vim.cmd('colorscheme snqn')
        '';
      }
      # neo-tree-nvim
      # vim-table-mode
      vim-log-highlighting
      # hmts-nvim
      cmp-buffer
      cmp-cmdline
      cmp-emoji
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      comment-nvim
      hotpot-nvim
      luasnip
      nvim-tree-lua
      nvzone-typr
      oxocarbon-nvim
      parinfer-rust
      plenary-nvim
      telescope-nvim
      typst-preview-nvim
      venn-nvim
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui
      vim-nix
      vim-shellcheck
      {
        plugin = mini-ai;
        type = "lua";
        config =
          # lua
          ''
            require("mini.ai").setup()
          '';
      }
      {
        plugin = mini-map;
        type = "lua";
        config =
          # lua
          ''
            require("mini.map").setup()
          '';
      }
      {
        plugin = mini-indentscope;
        type = "lua";
        config =
          # lua
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
          # lua
          ''
            require("mini.fuzzy").setup()
          '';
      }
      {
        plugin = mini-diff;
        type = "lua";
        config =
          # lua
          ''
            require("mini.diff").setup()
          '';
      }
      {
        plugin = nix-update-nvim;
        type = "lua";
        config =
          # lua
          ''
            local nix_update = require("nix-update")

            local opt = {}

            nix_update.setup(opt)

            vim.api.nvim_create_user_command(
              "NixUpdate",
              nix_update.prefetch_fetch,
              {}
            )
          '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./cfg/TSconfig.lua;
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
      {
        plugin = tiny-inline-diagnostic-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/tiny-inline-diagnostics.lua;
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
        config = 
          # lua
          ''
          require("fidget").setup({
            progress = {
              display = {
                progress_style = "FidgetProgress"
              }
            }
          })
          '';
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/oil.lua;
      }
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
        config = 
          # lua
          ''
          require("colorizer").setup({
            mode = 'foreground';
          })
          '';
      }
      {
        plugin = alpha-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/alpha.lua;
      }
    ];
  };
}
