require("lspconfig").html.setup({
  cmd = { "vscode-html-language-server", "--stdio" },
  init_options = {
    embeddedLanguages = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true
      },
      provideFormatter = true
    }
  },
})
require("lspconfig").bashls.setup({})
require("lspconfig").nixd.setup({
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "alejandra" },
      },
      options = {
        nixos = {
          expr = 'let flake = builtins.getFlake "git+ssh://git@github.com/74k1/tix"; in (flake.inputs..nixpkgs.lib.nixosSystem {system = "x86_64-linux"; modules = []; }).options',
        },
        -- home_manager = {
        --   expr = '(builtins.getFlake "git+ssh://git@github.com/74k1/tix").homeConfigurations.idk.options',
        -- },
        ["flake-parts"] = {
          expr = 'let flake = builtins.getFlake "git+ssh://git@github.com/74k1/tix"; in flake.debug.options // flake.currentSystem.options',
        },
      },
    },
  },
})
require("lspconfig").rust_analyzer.setup({
  on_attach = function(client, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true
      },
    }
  }
})
