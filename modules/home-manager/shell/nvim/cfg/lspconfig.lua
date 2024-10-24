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
          expr = 'let flake = builtins.getFlake "git+ssh://git@github.com/74k1/tix"; in flake.nixosConfigurations.wired.options',
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
require("lspconfig").bashls.setup({})
