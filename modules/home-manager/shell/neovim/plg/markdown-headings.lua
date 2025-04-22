local M = {}

-- Define custom highlight groups for different heading levels
local function define_highlight_groups()
  vim.cmd [[
    hi MarkdownHeading1 guifg=#A6E3A1 gui=bold
    hi MarkdownHeading2 guifg=#F9E2AF gui=bold
    hi MarkdownHeading3 guifg=#F9AFD0 gui=bold
    hi MarkdownHeading4 guifg=#89DCEB gui=bold
    hi MarkdownHeading5 guifg=#F28FAD gui=bold
    hi MarkdownHeading6 guifg=#F5C2E7 gui=bold
    hi MarkdownHeadingSymbol gui=italic guifg=#C0CAF5
  ]]
end

-- Function to apply highlighting to a specific heading
local function highlight_heading(line, level, linenr)
  if vim.fn.hlexists("MarkdownHeading" .. level) == 0 then
    return
  end
  -- Apply highlight to the '#' symbols
  vim.fn.matchadd("MarkdownHeadingSymbol", "^\\s*\\#+", 100, -1, {line = linenr})
  -- Apply highlight to the rest of the heading
  vim.fn.matchadd("MarkdownHeading" .. level, "^\\s*\\#+\\s\\zs.*", 100, -1, {line = linenr})
end

-- Function to update heading highlights based on cursor position
local function update_headings_highlight()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "markdown" then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = lines[cursor_pos[1] - 1]

  -- Clear existing matches
  vim.fn.clearmatches()

  -- Check if current line is a heading
  if current_line:match("^#") then
    local level = #current_line:match("^#+")
    highlight_heading(current_line, level, cursor_pos[1] - 1)
  else
    -- Highlight all headings in the buffer
    for i, line in ipairs(lines) do
      if line:match("^#") then
        local level = #line:match("^#+")
        highlight_heading(line, level, i - 1)
      end
    end
  end
end

-- Initialize the module
function M.init()
  define_highlight_groups()
  -- Attach the update function to cursor movements
  vim.cmd [[
    augroup MarkdownDynamicHeadings
      autocmd!
      autocmd CursorMoved,CursorMovedI * lua require('your_module_name').update_headings_highlight()
    augroup END
  ]]
end

M.update_headings_highlight = update_headings_highlight

return M
