{ transparency, ... }:
/* lua */
''
local wezterm = require 'wezterm'
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- font
-- TODO
config.font = wezterm.font_with_fallback {
  "TX02 Nerd Font",
  -- "BerkeleyMono Nerd Font Mono",
  -- "Berkeley Mono",
  "FiraCode Nerd Font Mono",
  "FiraMono Nerd Font",
  "JetBrains Mono"
}

-- temp fix. (NixOS/nixpkgs/issues/336069)
config.front_end = "WebGpu"

-- wayland
config.enable_wayland = false

-- font options
config.harfbuzz_features = {
  'calt=0',
  'clig=0',
  'liga=0'
}

-- font rendering
config.freetype_render_target = "Light"

-- window opacity
config.window_background_opacity = ${
  if transparency
  then "0.75"
  else "1"
}

-- color
config.colors = {
  foreground = '#EEF2EE',
  --background = 'rgba(50% 50% 50% 50%)',
  background = '#06040C',

  -- Override cursor:
  --cursor_bg = 'xy',
  --cursor_fg = 'xy',
  --cursor_border = 'xy',

  --selection_fg = '#FAFBFA',
  selection_bg = '#221754',--'#0e0c36',

  scrollbar_thumb = '#110b22',

  split = '#110b22',

  ansi = {
    '#000000',
    '#FC4A5C',
    '#1AE981',
    '#FCDF6D',
    '#5665FB',
    '#E068FB',
    '#46D0F8',
    '#EEF2EE',
  },

  brights = {
    '#404040',
    '#FF5A74',
    '#40FE9F',
    '#FFECA1',
    '#6D7CFF',
    '#ED77FF',
    '#6BDAFD',
    '#EEF2EE',
  }
}

--------------
-- Keybinds --
--------------
local function keybind(mods, key, action)
	if type(action) == "table" then
		action = wezterm.action(action)
	end

	return {
		mods = mods,
		key = key,
		action = action,
	}
end

config.disable_default_key_bindings = true
config.keys = {
	---------------
	-- Clipboard --
	---------------
	keybind("CTRL|SHIFT", "c", { CopyTo = "Clipboard" }),
	keybind("CTRL|SHIFT", "v", { PasteFrom = "Clipboard" }),

	---------------
	-- Font size --
	---------------
	keybind("CTRL|SHIFT", "UpArrow", "IncreaseFontSize"),
	keybind("CTRL|SHIFT", "DownArrow", "DecreaseFontSize"),

	------------
	-- Scroll --
	------------
	keybind("ALT", "u", { ScrollByPage = -1 }),
	keybind("ALT", "d", { ScrollByPage = 1 }),

	------------
	-- Reload --
	------------
	keybind("CTRL|SHIFT", "r", "ReloadConfiguration"),
}

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

-- disable bell
config.audible_bell = "Disabled";

return config
''
