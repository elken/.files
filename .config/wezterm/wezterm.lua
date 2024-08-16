-- Borrowed mostly from  https://github.com/Tudyx/config/blob/a082ed3061c761c582c388ea19ce4746ea122a09/.config/wezterm/wezterm.lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local io = require("io")
local os = require("os")
local act = wezterm.action

local fh, _ = assert(io.popen("uname -o 2>/dev/null", "r"))
local os_name = "Windows"
if fh then
  os_name = fh:read()
end

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
      args = { "nvim", string.format("+%s", config.scrollback_lines or 3500), name },
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

config.colors = wezterm.color.load_scheme(wezterm.home_dir .. "/.config/wezterm/colors/nordfox.toml")

-- Terminal hyperlinks
-- https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
-- printf '\e]8;;http://example.com\e\\This is a link\e]8;;\e\\\n'

-- Use the defaults as a base.  https://wezfurlong.org/wezterm/config/lua/config/hyperlink_rules.html
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)

-- Regex syntax:  https://docs.rs/regex/latest/regex/#syntax and https://docs.rs/fancy-regex/latest/fancy_regex/#syntax
-- Lua's [[ ]] literal strings prevent character [[:classes:]] :(
-- To avoid "]]] at end, use "[a-z].{0}]]"
-- https://www.lua.org/pil/2.4.html#:~:text=bracketed%20form%20may%20run%20for%20several%20lines%2C%20may%20nest

table.insert(config.hyperlink_rules, {
  -- https://github.com/shinnn/github-username-regex  https://stackoverflow.com/a/64147124/5353461
  regex = [[(^|(?<=[\[(\s'"]))([0-9A-Za-z][-0-9A-Za-z]{0,38})/([A-Za-z0-9_.-]{1,100})((?=[])\s'".!?])|$)]],
  --  is/good  0valid0/-_.reponname  /bad/start  -bad/username  bad/end!  too/many/parts -bad/username
  --  [wraped/name] (aa/bb) 'aa/bb' "aa/bb"  end/punct!  end/punct.
  format = "https://www.github.com/$2/$3/",
  -- highlight = 0,  -- highlight this regex match group, use 0 for all
})

config.font = wezterm.font_with_fallback({
  {
    family = "Monaspace Neon",
    harfbuzz_features = { "calt", "dlig", "liga", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "ss09" },
  },
  "Nerd Font Symbols",
  "Noto Color Emoji",
})

if os_name == "GNU/Linux" then
  config.font_size = 14
else
  config.font_size = 16
end

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

if os_name == "OSX" then
  config.window_background_opacity = 0.8
  config.macos_window_background_blur = 20
  config.window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW"
end

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

config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("PrimarySelection"),
  },

  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },

  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.Nop,
  },
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

if os_name == "GNU/Linux" then
  local success, stdout, _ = wezterm.run_child_process({ "gsettings", "get", "org.gnome.desktop.interface", "cursor-theme" })
  if success then
    config.xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
  end

  local success, stdout, _ = wezterm.run_child_process({ "gsettings", "get", "org.gnome.desktop.interface", "cursor-size" })
  if success then
    config.xcursor_size = tonumber(stdout)
  end
end

return config
