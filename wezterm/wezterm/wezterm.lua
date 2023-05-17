-- wezterm configuration
local wezterm = require('wezterm')

local config = {}
if wezterm.config_builder then
    -- makes nicer error messages for config errors
    config = wezterm.config_builder()
end

--- GLOBALS ---
local windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'
local linux = wezterm.target_triple == 'x86_64-unknown-linux-gnu'

local TILING = false

-- detect a tiling window manager
local CUR_DE = os.getenv('XDG_CURRENT_DESKTOP')
if CUR_DE == 'qtile' then
    TILING = true
end

config.check_for_updates = true

-- NOTE: no login shells!
if linux then
    local shell = os.getenv('SHELL')
    if os.getenv('container') ~= nil then
        -- running in a flatpak so SHELL is /bin/sh
        shell = '/usr/bin/zsh'
    end

    -- toolbox wrapper script
    config.default_prog = { 'box', 'enter' }

    config.launch_menu = {
        {
            label = 'Shell',
            args = { shell },
        },
        {
            label = 'Toolbox',

            -- custom toolbox wrapper
            args = { 'box', 'enter' },
        }
    }
else
    -- TODO:
    -- default_domain = "WSL:Ubuntu"
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
