require("ibl").setup({
  viewport_buffer = {
    min = 50,
    max = 600,
  },
  
  indent = {
    char = "│"
  },
  
  whitespace = {
    highlight = { "Whitespace", "NonText" },
  },

  scope = {
    enabled = false,
    show_start = true,
    show_end = false,
  },

  exclude = {
    filetypes = {
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
    buftypes = {
      "terminal",
    },
  },

  --v2 space_char_blankline = " ",
  --v2 max_indent_increase = 1,
  --v2 show_current_context = false,
  --show_current_context_start = true,
  --context_patterns = {
  --  "class",
  --  "function",
  --  "method",
  --  "while",
  --  "do_statement",
  --  "closure",
  --  "for",
  --},
})
