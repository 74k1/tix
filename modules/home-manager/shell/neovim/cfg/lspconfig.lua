local default_capabilities = vim.lsp.protocol.make_client_capabilities()
local lsp_capabilities = vim.tbl_deep_extend(
  "force",
  default_capabilities,
  {
    textDocument = {
      completion = {
        completionItem = {
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
          documentationFormat = {
            "markdown",
          },
          deprecatedSupport = true,
          snippetSupport = true,
          commitCharactersSupport = true,
          labelDetailsSupport = true,
          insertReplaceSupport = true,
          preselectSupport = true,
          tagSupport = {
            valueSet = {
              1,
            },
          },
        },
      },
      foldingRange = {
        lineFoldingOnly = true,
        dynamicRegistration = false,
      },
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
          relative_pattern_support = true,
        },
      },
    },
  }
)

vim.lsp.config('html', {
  capabilities = lsp_capabilities,
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
vim.lsp.enable('html')

vim.lsp.config('bashls',{})
vim.lsp.enable('bashls')

vim.lsp.config('nil_ls',{
  cmd = { "nil" },
  filetypes = { "nix" },
  single_file_support = true,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt" },
      },
      nix = {
        flake = {
          autoArchive = true,
          -- autoEvalInputs = true,
        },
      },
    },
  },
})
vim.lsp.enable('nil_ls')

vim.lsp.config('rust_analyzer',{
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
vim.lsp.enable('rust_analyzer')

vim.lsp.config('tinymist', {
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onType",
    semanticTokens = "disable"
  }
})
vim.lsp.enable('tinymist')
