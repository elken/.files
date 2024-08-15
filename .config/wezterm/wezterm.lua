-- Borrowed mostly from  https://github.com/Tudyx/config/blob/a082ed3061c761c582c388ea19ce4746ea122a09/.config/wezterm/wezterm.lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local io = require("io")
local os = require("os")
local act = wezterm.action

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on("trigger-helix-with-scrollback", function(window, pane)
  -- Retrieve the text from the pane
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

  -- Create a temporary file to pass to helix
  local name = os.tmpname()
  local f = io.open(name, "w+")

  if f then
    f:write(text)
    f:flush()
    f:close()
  end

  -- Open a new window running helix and tell it to open the file
  window:perform_action(
    act.SpawnCommandInNewTab({
      args = { "hx ", string.format("+%s", config.scrollback_lines or 3500), name },
    }),
    pane
  )

  -- Wait "enough" time for helix to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  --
  -- Note: We don't strictly need to remove this file, but it is nice
  -- to avoid cluttering up the temporary directory.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

config.enable_kitty_keyboard = true

config.debug_key_events = true

config.color_scheme = "nord"

config.font = wezterm.font_with_fallback({
  {
    family = "Monaspace Neon",
    harfbuzz_features = { "calt", "dlig", "liga", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "ss09" },
  },
  "Nerd Font Symbols",
  "Noto Color Emoji",
})

config.font_size = 16

config.font_rules = {
  { -- Italic
    intensity = "Normal",
    italic = true,
    font = wezterm.font({
      family = "Monaspace Xenon", -- courier-like
      style = "Italic",
    }),
  },

  { -- Bold
    intensity = "Bold",
    italic = false,
    font = wezterm.font({
      family = "Monaspace Krypton",
      weight = "Bold",
    }),
  },

  { -- Bold Italic
    intensity = "Bold",
    italic = true,
    font = wezterm.font({
      family = "Monaspace Xenon",
      style = "Italic",
      weight = "Bold",
    }),
  },
}

config.window_frame = {
  font = wezterm.font({ family = "Montserrat", weight = "Bold" }),
  font_size = 11.0,
  active_titlebar_bg = "2E3440",
  inactive_titlebar_bg = "#2E3440",
}

config.colors = {
  tab_bar = {
    inactive_tab_edge = "#2E3440",
  },
}
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW"

config.hide_tab_bar_if_only_one_tab = true
config.hide_mouse_cursor_when_typing = false
-- config.default_prog = { 'zsh', '-ic', 'zellij', 'attach', '-c'}

-- config.disable_default_key_bindings = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.leader = { key = "t", mods = "ALT", timeout_milliseconds = 1000 }

config.keys = {
  {
    key = "e",
    mods = "LEADER",
    action = wezterm.action.EmitEvent("trigger-helix-with-scrollback"),
  },
  {
    key = "p",
    mods = "LEADER",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = "n",
    mods = "LEADER",
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = "v",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  {
    key = "q",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentTab({ confirm = true }),
  },
  { key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
  { key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
  { key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
  { key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
}

config.ssh_domains = {
  {
    name = "nas",
    remote_address = "192.168.50.10",
    username = "lkn",
    -- assume_shell = 'Posix',
    -- remote_wezterm_path = "/home/lkn/wezterm"
  },
}

config.underline_thickness = "3.0"
config.underline_position = "-3"
config.warn_about_missing_glyphs = false
config.enable_kitty_graphics = true

--local success, stdout, _ = wezterm.run_child_process({ "gsettings", "get", "org.gnome.desktop.interface", "cursor-theme" })
--if success then
--    config.xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
--end
--
--local success, stdout, _ = wezterm.run_child_process({ "gsettings", "get", "org.gnome.desktop.interface", "cursor-size" })
--if success then
--    config.xcursor_size = tonumber(stdout)
--end

return config
