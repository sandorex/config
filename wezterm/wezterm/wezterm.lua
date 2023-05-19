-- wezterm configuration
local wezterm = require('wezterm')

local config = {}
if wezterm.config_builder then
    -- makes nicer error messages for config errors
    config = wezterm.config_builder()
end

--- GLOBALS ---
local windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'

local TILING = false

-- detect a tiling window manager
local CUR_DE = os.getenv('XDG_CURRENT_DESKTOP')
if CUR_DE == 'qtile' then
    TILING = true
end

config.check_for_updates = true

-- NOTE: do not use login shells as they make it load profile each time and
-- when there is no need to do that, except in containers
if windows then
    -- TODO:
    -- default_domain = "WSL:Ubuntu"
else
    -- detect user shell
    local shell = os.getenv('SHELL')
    if os.getenv('container') ~= nil then
        -- shell var in flatpak is always /bin/sh so default to zsh
        shell = '/usr/bin/zsh'
    end

    config.launch_menu = {
        {
            label = 'Daily Container',
            args = { 'distrobox', 'enter', 'daily' },
        },
        {
            label = 'Toolbox Default',
            args = { 'toolbox-enter-wrapper' },
        },
        {
            label = 'System Shell',
            args = { shell },
        },
    }

    -- default to first menu item
    config.default_prog = config.launch_menu[1].args
end

--- THEMING ---
config.color_scheme = 'carbonfox'
config.font = wezterm.font_with_fallback({
    'FiraCode Nerd Font',
    'FiraCode NFM', -- on windows it's named different
    'Hack',
    'Noto Sans Mono',
})
config.font_size = 16

config.colors = {
    tab_bar = {
        -- highlight the focused tab
        active_tab = {
            fg_color = '#FFFFFF',
            bg_color = '#444444',
        },
    },
}

-- makes the tabbar look more like TUI
config.use_fancy_tab_bar = false;
config.hide_tab_bar_if_only_one_tab = true

--- BEHAVIOUR ---
config.hide_mouse_cursor_when_typing = false

-- remove all link parsing
config.hyperlink_rules = {}

-- makes alt act as regular alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

--- ENVIRONMENTAL ADAPTATION ---
-- remove title bar in a tiling window managers
if TILING then config.window_decorations = "RESIZE" end

--- EXTRA FILES ---
-- merge keybindings onto the config
require('keybindings').apply(config)

return config
