require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt" },
  disable_in_macro = false,
  disable_in_visualblock = false,
  disable_in_replace_mode = true,
  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
  enable_moveright = true,
  enable_afterquote = true,
  enable_check_bracket_line = true,
  enable_bracket_in_quote = true,
  enable_abbr = false,              -- trigger abbreviation
  break_undo = true,                -- switch for basic rule break undo sequence
  check_ts = true,
  ts_config = {
      lua = { "string" }, -- it will not add pair on that treesitter node
      javascript = { "template_string" },
      java = false,       -- don't check treesitter on java
  },
  map_cr = true,
  map_bs = true,
  map_c_h = false,
  map_c_w = false,
})
