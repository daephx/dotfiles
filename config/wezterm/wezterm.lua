local bindings = require("bindings")
local utils = require("utils")
local wezterm = require("wezterm")
require("events")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide good defaults and clearer error messages.
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Define wezterm configuration options
config.animation_fps = 200
config.audible_bell = "Disabled"
config.check_for_updates = false
config.color_scheme = "vscode"
config.color_scheme_dirs = { wezterm.config_dir .. "/colors/" }
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.force_reverse_video_cursor = false
config.disable_default_key_bindings = true
config.enable_kitty_graphics = false
config.enable_wayland = utils.enable_wayland()
config.scrollback_lines = 10000
config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
config.cell_width = 1
config.line_height = 1
config.font_size = 10
config.font = wezterm.font_with_fallback({
  { family = "FiraCode Nerd Font" },
  { family = "Terminus" },
  { family = "Consolas" },
  { family = "Symbols Nerd Font" },
})
config.warn_about_missing_glyphs = false
config.hide_tab_bar_if_only_one_tab = true
config.key_tables = bindings.key_tables
config.keys = bindings.create_keybinds()
config.leader = bindings.leader
config.mouse_bindings = bindings.mouse_bindings
config.selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%"
config.tab_bar_at_bottom = false
config.use_dead_keys = false
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}
config.window_background_opacity = 0.85
config.window_close_confirmation = "AlwaysPrompt"
config.window_decorations = "NONE"
config.window_padding = {
  bottom = 0,
  left = 0,
  right = 0,
  top = 0,
}

config.launch_menu = {}

return config
