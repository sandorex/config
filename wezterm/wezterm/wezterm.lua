-- wezterm configuration

local wezterm = require('wezterm')
local act = wezterm.action

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

config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true

-- makes alt act as regular alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- there is already enough garbage on the top
config.tab_bar_at_bottom = true

if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
    -- disable close confirmation, this should only be needed on flatpak as the
    -- native version has skip_close_confirmation_for_processes_named
    config.window_close_confirmation = 'NeverPrompt'

    -- remove title bar
    -- config.window_decorations = "RESIZE"
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
