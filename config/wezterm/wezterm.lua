local keybinds = require("keybinds")
local utils = require("utils")
local wezterm = require("wezterm")
local scheme = wezterm.get_builtin_color_schemes()["Dark Pastel"]
local gpus = wezterm.gui.enumerate_gpus()
require("on")

-- /etc/ssh/sshd_config
-- AcceptEnv TERM_PROGRAM_VERSION COLORTERM TERM TERM_PROGRAM WEZTERM_REMOTE_PANE
-- sudo systemctl reload sshd

-- selene: allow(unused_variable)
---@diagnostic disable-next-line: unused-function, unused-local
local function enable_wayland()
  local session = os.getenv("DESKTOP_SESSION")
  local wayland = os.getenv("XDG_SESSION_TYPE")
  if wayland == "wayland" or session == "hyprland" then
    return true
  end
  return false
end

-- Merge Config
local function create_ssh_domain_from_ssh_config(ssh_domains)
  if ssh_domains == nil then
    ssh_domains = {}
  end
  for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
    table.insert(ssh_domains, {
      name = host,
      remote_address = config.hostname .. ":" .. config.port,
      username = config.user,
      multiplexing = "None",
      assume_shell = "Posix",
    })
  end
  return { ssh_domains = ssh_domains }
end

-- load local_config
-- Write settings you don't want to make public, such as ssh_domains
package.path = os.getenv("HOME") .. "/.local/share/wezterm/?.lua;" .. package.path
local function load_local_config(module)
  local m = package.searchpath(module, package.path)
  if m == nil then
    return {}
  end
  return dofile(m)
end

-- Define wezterm configuration options
local config = {
  font = wezterm.font("FiraCode Nerd Font Mono"),
  font_size = 10,
  cell_width = 1,
  line_height = 1,
  check_for_updates = false,
  use_ime = true,
  ime_preedit_rendering = "Builtin",
  use_dead_keys = false,
  warn_about_missing_glyphs = false,
  enable_kitty_graphics = false,
  animation_fps = 1,
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",
  cursor_blink_rate = 0,
  enable_wayland = enable_wayland(),
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  color_scheme = "Dark+",
  color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" },
  window_background_opacity = 0.85,
  colors = {
    background = "#000000",
    cursor_bg = scheme.ansi[8],
    cursor_fg = scheme.ansi[8],
    tab_bar = {
      background = scheme.background,
      new_tab = { bg_color = scheme.background, fg_color = scheme.ansi[8], intensity = "Bold" },
      new_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.brights[8], intensity = "Bold" },
    },
  },
  disable_default_key_bindings = true,
  exit_behavior = "CloseOnCleanExit",
  key_tables = keybinds.key_tables,
  keys = keybinds.create_keybinds(),
  leader = { key = "Space", mods = "CTRL|SHIFT" },
  mouse_bindings = keybinds.mouse_bindings,
  tab_bar_at_bottom = false,
  use_fancy_tab_bar = false,
  window_close_confirmation = "AlwaysPrompt",
  -- https://github.com/wez/wezterm/issues/2756
  webgpu_preferred_adapter = gpus[1],
  front_end = "OpenGL",
  -- visual_bell = {
  --  fade_in_function = "EaseIn",
  --  fade_in_duration_ms = 150,
  --  fade_out_function = "EaseOut",
  --  fade_out_duration_ms = 150,
  -- },
}

-- Solid angle bracket symbols
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- config.tab_bar_style = {
--   active_tab_left = wezterm.format({
--     { Background = { Color = scheme.ansi[1] } },
--     { Foreground = { Color = scheme.ansi[4] } },
--     { Text = SOLID_LEFT_ARROW },
--   }),
--   active_tab_right = wezterm.format({
--     { Background = { Color = scheme.ansi[1] } },
--     { Foreground = { Color = scheme.ansi[4] } },
--     { Text = SOLID_RIGHT_ARROW },
--   }),
--   inactive_tab_left = wezterm.format({
--     { Background = { Color = scheme.ansi[1] } },
--     { Foreground = { Color = scheme.ansi[4] } },
--     { Text = SOLID_LEFT_ARROW },
--   }),
--   inactive_tab_right = wezterm.format({
--     { Background = { Color = scheme.ansi[1] } },
--     { Foreground = { Color = scheme.ansi[4] } },
--     { Text = SOLID_RIGHT_ARROW },
--   }),
-- }

for _, gpu in ipairs(gpus) do
  if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" then
    config.webgpu_preferred_adapter = gpu
    config.front_end = "WebGpu"
    break
  end
end

config.hyperlink_rules = {
  -- Matches: a URL in parens: (URL)
  {
    regex = "\\((\\w+://\\S+)\\)",
    format = "$1",
    highlight = 1,
  },
  -- Matches: a URL in brackets: [URL]
  {
    regex = "\\[(\\w+://\\S+)\\]",
    format = "$1",
    highlight = 1,
  },
  -- Matches: a URL in curly braces: {URL}
  {
    regex = "\\{(\\w+://\\S+)\\}",
    format = "$1",
    highlight = 1,
  },
  -- Matches: a URL in angle brackets: <URL>
  {
    regex = "<(\\w+://\\S+)>",
    format = "$1",
    highlight = 1,
  },
  -- Then handle URLs not wrapped in brackets
  {
    regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
    format = "$1",
    highlight = 1,
  },
  -- implicit mailto:email link
  {
    regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
    format = "mailto:$0",
  },
  -- Github repository github.com/org/repo
  {
    regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
    format = "https://github.com/$1/$3",
  },
}

local local_config = load_local_config("local")
local merged_config = utils.merge_tables(config, local_config)
return utils.merge_tables(merged_config, create_ssh_domain_from_ssh_config(merged_config.ssh_domains))

