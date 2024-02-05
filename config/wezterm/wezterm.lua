local wezterm = require("wezterm")
local gpus = wezterm.gui.enumerate_gpus()
local bindings = require("bindings")
local utils = require("utils")
require("events")

wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/modules")

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

-- /etc/ssh/sshd_config
-- AcceptEnv TERM_PROGRAM_VERSION COLORTERM TERM TERM_PROGRAM WEZTERM_REMOTE_PANE
-- sudo systemctl reload sshd

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

-- Define wezterm configuration options
local config = {
  audible_bell = "Disabled",
  animation_fps = 1,
  launch_menu = {},
  check_for_updates = false,
  color_scheme = "vscode",
  color_scheme_dirs = { wezterm.config_dir .. "/colors/" },
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",
  cursor_blink_rate = 0,
  disable_default_key_bindings = true,
  enable_csi_u_key_encoding = true, -- Separate <Tab> <C-i>
  enable_kitty_graphics = false,
  enable_wayland = utils.enable_wayland(),
  exit_behavior = "CloseOnCleanExit",
  front_end = "OpenGL",
  hide_tab_bar_if_only_one_tab = true,
  ime_preedit_rendering = "Builtin",
  key_tables = bindings.key_tables,
  keys = bindings.create_keybinds(),
  leader = bindings.leader,
  mouse_bindings = bindings.mouse_bindings,
  selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
  tab_bar_at_bottom = false,
  use_dead_keys = false,
  use_fancy_tab_bar = false,
  use_ime = true,
  -- https://github.com/wez/wezterm/issues/2756
  webgpu_preferred_adapter = gpus[1],
  window_background_opacity = 0.90,
  window_close_confirmation = "AlwaysPrompt",
  window_decorations = "NONE",
  window_padding = {
    bottom = 0,
    left = 0,
    right = 0,
    top = 0,
  },
}

for _, gpu in ipairs(gpus) do
  if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" then
    config.webgpu_preferred_adapter = gpu
    config.front_end = "WebGpu"
    break
  end
end

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- config.front_end = "Software" -- OpenGL doesn't work quite well with RDP.
  -- config.term = "" -- Set to empty so FZF works on windows
  table.insert(config.launch_menu, { label = "PowerShell", args = { "powershell.exe", "-NoLogo" } })

  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
    local year = vsvers:gsub("Microsoft Visual Studio/", "")
    table.insert(config.launch_menu, {
      label = "x64 Native Tools VS " .. year,
      args = {
        "cmd.exe",
        "/k",
        "C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
      },
    })
  end
else
  config.default_prog = { "/bin/bash" }
  table.insert(config.launch_menu, { label = "bash", args = { "bash" } })
  table.insert(config.launch_menu, { label = "fish", args = { "fish" } })
  table.insert(config.launch_menu, { label = "zsh", args = { "zsh" } })
end

config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "BackgroundColor",
}

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

-- local config = {
--   bindings,
--   colors,
--   fonts,
--   hyperlinks,
--   local,
--   options,
--   render,
--   style,
--   window,
-- }

local local_config = load_local_config("local")
local ssh_config = create_ssh_domain_from_ssh_config(local_config.ssh_domains)
local font_config = require("fonts")

config = utils.merge_tables(config, font_config)
config = utils.merge_tables(config, local_config)
config = utils.merge_tables(config, ssh_config)

return config
