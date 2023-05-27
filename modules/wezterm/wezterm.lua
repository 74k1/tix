local wezterm = require 'wezterm'
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- font
config.font = wezterm.font("FiraCode Nerd Font Mono")

-- font options
config.harfbuzz_features = {
  'calt=0',
  'clig=0',
  'liga=0'
}

-- font rendering
config.freetype_render_target = "Light"

-- tab bar
config.enable_tab_bar = false

-- links
config.hyperlink_rules = {
  -- make urls clickable
  -- This is default if no hyperlink_rules
  {
    regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
    format = "$0"
  },

  -- linkify email addresses
  {
    regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
    format = "mailto:$0"
  },

  -- linkify file:// URIs
  {
    regex = "\\bfile://\\S*\\b",
    format = "$0"
  }
}

return config
