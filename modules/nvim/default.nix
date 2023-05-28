{ lib, pkgs, config, ... }:

{
  imports = [];

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
      set clipboard+=unnamedplus
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      comment-nvim
      telescope-nvim
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = ''
          require("colorizer").setup()
        '';
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require("indent-blankline").setup({
            char = "|", -- "│",
            char_list_blankline = { "|", "┊", "┆", "¦"},
            space_char_blankline = " ",
            max_indent_increase = 1,
            use_treesitter = true,
            show_end_of_line = false,
            show_current_context = true,
            show_trailing_blankline_indent = false,
            context_patterns = {
                "class",
                "function",
                "method",
                "while",
                "do_statement",
                "closure",
                "for",
            },
            viewport_buffer = 50,
            filetype_exclude = {
                "help",
                "terminal",
                "dashboard",
                "startify",
                "alpha",
                "packer",
                "neogitstatus",
                "tsplayground",
                "aerial",
            },
            buftype_exclude = { "terminal" },
          })
        '';
      }
      {
        plugin = dashboard-nvim;
        type = "lua";
        config = ''
          require("dashboard").setup({
            theme = 'hyper',
            config = {
              week_header = {
                enable = true,
              },
              shortcut = {
                { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                {
                  icon = ' ',
                  icon_hl = '@variable',
                  desc = 'Files',
                  group = 'Label',
                  action = 'Telescope find_files',
                  key = 'f',
                },
                {
                  desc = ' Apps',
                  group = 'DiagnosticHint',
                  action = 'Telescope app',
                  key = 'a',
                },
                {
                  desc = ' dotfiles',
                  group = 'Number',
                  action = 'Telescope dotfiles',
                  key = 'd',
                },
              },
            },
          })
        '';
      }
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = ''
          require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = { -- :h background
              light = "latte",
              dark = "mocha",
            },
            transparent_background = true,
            show_end_of_buffer = false, -- show the '~' characters after the end of buffers
            term_colors = false,
            dim_inactive = {
              enabled = false,
              shade = "dark",
              percentage = 0.15,
            },
            no_italic = false, -- Force no italic
            no_bold = false, -- Force no bold
            no_underline = false, -- Force no underline
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {},
            custom_highlights = {},
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                notify = false,
                mini = false,
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
          })

          -- setup must be called before loading
          vim.cmd.colorscheme "catppuccin"
        '';
      }
    ];
  };
}
