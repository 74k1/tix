require("clipboard-image").setup {
  -- Def config for all filetypes
  default = {
    img_dir = {"%:p:h", "_assets_", "%:t:r"},
    img_name = function() return os.time(os.date("!*t")) end,
  },
  markdown = {
    img_handler = function(img)
      vim.cmd("normal! f[") -- go to [
      vim.cmd("normal! a" .. img.name)
    end
  }
}
