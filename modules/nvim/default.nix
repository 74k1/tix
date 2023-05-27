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
    '';
    plugins = with pkgs.vimPlugins; [
      # {
      #   plugin = tokyonight-nvim;
      #   type = "lua";
      #   config = ''
      #     vim.g.tokyonight_style = "night"                    -- The theme comes in three styles, storm, a darker variant night and day.
      #     vim.g.tokyonight_terminal_colors = true             -- Configure the colors used when opening a :terminal in Neovim
      #     vim.g.tokyonight_italic_comments = true             -- Make comments italic
      #     vim.g.tokyonight_italic_keywords = true             -- Make keywords italic
      #     vim.g.tokyonight_italic_functions = false           -- Make functions italic
      #     vim.g.tokyonight_italic_variables = false           -- Make variables and identifiers italic
      #     vim.g.tokyonight_transparent = false                -- Enable this to disable setting the background color
      #     vim.g.tokyonight_hide_inactive_statusline = false   -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard StatusLine and LuaLine.
      #     vim.g.tokyonight_sidebars = {}                      -- Set a darker background on sidebar-like windows. For example: ["qf", "vista_kind", "terminal", "packer"]
      #     vim.g.tokyonight_transparent_sidebar = false        -- Sidebar like windows like NvimTree get a transparent background
      #     vim.g.tokyonight_dark_sidebar = true                -- Sidebar like windows like NvimTree get a darker background
      #     vim.g.tokyonight_dark_float = true                  -- Float windows like the lsp diagnostics windows get a darker background.
      #     vim.g.tokyonight_colors = {}                        -- You can override specific color groups to use other groups or a hex color
      #     vim.g.tokyonight_day_brightness = 0.3               -- Adjusts the brightness of the colors of the Day style. Number between 0 and 1, from dull to vibrant colors
      #     vim.g.tokyonight_lualine_bold = false               -- When true, section headers in the lualine theme will be bold
      # 
      #     vim.cmd("colorscheme tokyonight")
      #   '';
      # }
      nvim-tree-lua
      comment-nvim
      {
        plugin = indent-blankline-nvim;
        type = "lua";
	config = ''
          vim.opt.termguicolors = true
          vim.cmd([[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]])
          vim.cmd([[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]])
          require("indent_blankline").setup({
            char = "",
            char_highlight_list = {
              "IndentBlanklineIndent1",
              "IndentBlanklineIndent2",
            },
            space_char_highlight_list = {
              "IndentBlanklineIndent1",
              "IndentBlanklineIndent2",
            },
            show_trailing_blankline_indent = false,
          })
        '';
      }
      telescope-nvim
    ];
  };
}
