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
      -- options = {
      --   nixos = {
      --     expr = '(builtins.getFlake "git+ssh://git@github.com/74k1/tix").nixosConfigurations.${system}.options',
      --   },
      --   home_manager = {
      --     expr = '(builtins.getFlake "git+ssh://git@github.com/74k1/tix").homeConfigurations.${system}.options',
      --   },
      -- },
    },
  },
})
require("lspconfig").bashls.setup({})
