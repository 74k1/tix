require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TS_AUTO_START", { clear = true }),
  pattern = "*",
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if not ft or ft == "" then return end

    local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
    if not ok_lang or not lang then return end

    local ok_info, info = pcall(vim.treesitter.language.inspect, lang)
    if not ok_info or not info then
      return
    end

    pcall(vim.treesitter.start, ev.buf, lang)
  end,
})
