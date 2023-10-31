require("clipboard-image").setup {
  -- Def config for all filetypes
  default = {
    img_dir = {"%:p:h", "_assets", "%:t:r"},
    img_name = function() return os.time(os.date("!*t")) end,
  }
}
