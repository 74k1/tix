local nix_update = require("nix-update")

local opt = {}

nix_update.setup(opt)

vim.api.nvim_create_user_command(
  "NixUpdate",
  nix_update.prefetch_fetch,
  {}
)
