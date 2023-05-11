-- wezterm configuration

local wezterm = require('wezterm')
local act = wezterm.action

-- is the current desktop a window manager
local WM = false

-- detect a tiling window manager
-- NOTE: to add a new one just check what 'XDG_CURRENT_DESKTOP' env var is
local CUR_DE = os.getenv('XDG_CURRENT_DESKTOP')
if CUR_DE == 'qtile' then
    WM = true
end

local config = {}

-- makes nicer error messages for config errors
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.check_for_updates = true

config.color_scheme = 'carbonfox'
config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 16

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    -- firacode is named differently on windows for some reason..
    config.font = wezterm.font 'FiraCode NFM'
end

-- makes the tabbar look more like TUI
config.use_fancy_tab_bar = false;
config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true

-- makes alt act as regular alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- remove title bar in a tiling window managers
if WM then
    config.window_decorations = "RESIZE"
end

config.keys = {
    -- allows mapping escape shift
    { key = 'Escape', mods = 'SHIFT', action = act.SendString("\x1b[[") }
}

config.mouse_bindings = {
    -- disable middle click paste
    {
        event = { Down = { streak = 1, button = 'Middle' } },
        mods = 'NONE',
        action = act.DisableDefaultAssignment,
    },
}

return config
