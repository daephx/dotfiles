local wezterm = require("wezterm")

local M = {
  adjust_window_size_when_changing_font_size = false,
  allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
  cell_width = 1,
  font_size = 12,
  freetype_load_flags = "NO_HINTING",
  line_height = 1,
  warn_about_missing_glyphs = false,
  font = wezterm.font_with_fallback({
    { family = "FiraCode Nerd Font Mono" },
    { family = "Terminus" },
    { family = "Consolas" },
    { family = "Symbols Nerd Font Mono", scale = 0.85 },
  }),
}

return M
