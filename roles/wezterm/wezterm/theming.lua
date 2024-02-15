local wezterm = require('wezterm')
local util = require('util')

local COLORS = {}
COLORS.TEXT = '#FFFFFF'
COLORS.BG = '#4A4A4A'
COLORS.BG_DIM = '#333333'

local M = {}

-- load the theme
M.THEME = require('themes.darklight')

function M.set_light_theme(config)
    config.color_scheme = M.THEME.LIGHT
end

function M.set_dark_theme(config)
    config.color_scheme = M.THEME.DARK
end

function M.set_auto_theme(config)
    if util.get_appearance() == 'Dark' then
        M.set_dark_theme(config)
    else
        M.set_light_theme(config)
    end
end

-- simple tab format with just the tab number
function M.tab_format(tab, _, _, _, _)
    -- i could forget i've zoomed in and forget about a pane in a tab
    local is_zoomed = ' '
    if tab.active_pane.is_zoomed then
        is_zoomed = 'z'
    end

    -- colors are set in config.colors.tab_bar
    return '  ' .. tab.tab_index + 1 .. is_zoomed .. ' '
end

function M.window_resize(window, _)
    local window_dims = window:get_dimensions()
    local overrides = window:get_config_overrides() or {}

    if window_dims.is_full_screen then
        if not overrides.window_frame then
            -- override the border
            overrides.window_frame = {}
        else
            return
        end
    else
        if overrides.window_frame then
            -- remove border override
            overrides.window_frame = nil
        else
            return
        end
    end

    window:set_config_overrides(overrides)
end

function M.apply(config)
    -- load theme
    M.THEME.apply(config)

    M.set_auto_theme(config)

    config.font = wezterm.font_with_fallback({
        'FiraCode Nerd Font',
        'Noto Sans Mono',
    })

    config.font_size = 15
    config.line_height = 0.9

    config.window_padding = {
        left = '6px',
        right = '6px',
        top = '2px',
        bottom = 0,
    }

    config.colors = {
        tab_bar = {
            background = COLORS.BG,

            active_tab = {
                fg_color = COLORS.BG,
                bg_color = COLORS.TEXT,
            },

            inactive_tab = {
                fg_color = COLORS.TEXT,
                bg_color = COLORS.BG_DIM,
            },

            inactive_tab_hover = {
                fg_color = COLORS.BG,
                bg_color = COLORS.TEXT,
            },

            -- these are for new tab button and integrated buttons
            -- 06/07/23: i removed the hover so its colored properly
            new_tab = {
                bg_color = COLORS.TEXT,
                fg_color = COLORS.BG,
            },

            new_tab_hover = {
                bg_color = COLORS.TEXT,
                fg_color = COLORS.BG,
            },
        },
    }

    config.inactive_pane_hsb = { saturation = 1.0, brightness = 0.5 }

    local window_min = ' 󰖰 '
    local window_max = ' 󰖯 '
    local window_close = ' 󰅖 '

    -- config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
    config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }
    config.tab_bar_style = {
        window_hide = window_min,
        window_hide_hover = window_min,
        window_maximize = window_max,
        window_maximize_hover = window_max,
        window_close = window_close,
        window_close_hover = window_close,
        -- block character to separate it from tabs
        new_tab = '█ + ',
        new_tab_hover = '█ + ',
    }

    -- makes the tabbar look more like TUI
    config.use_fancy_tab_bar = false;

    config.hide_tab_bar_if_only_one_tab = true;

    config.window_frame = {
        border_top_height = '4px',
        border_bottom_height = '4px',
        border_left_width = '4px',
        border_right_width = '4px',
        border_left_color = COLORS.BG,
        border_right_color = COLORS.BG,
        border_bottom_color = COLORS.BG,
        border_top_color = COLORS.BG,
    }

    -- wezterm.on('window-config-reloaded', M.config_reload)
    wezterm.on('window-resized', M.window_resize)
    wezterm.on('format-tab-title', M.tab_format)
end

return M
