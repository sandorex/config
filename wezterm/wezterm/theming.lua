local wezterm = require('wezterm')
local globals = require('globals')

local M = {}

wezterm.on('update-right-status', function(window, pane)
    local user_vars = pane:get_user_vars()

    local icon = user_vars.window_prefix
    if not icon or icon == '' then
        -- fallback for the icon,
        icon = ''
    end

    window:set_left_status(wezterm.format {
        { Background = { Color = '#333333' } },
        { Text = ' ' .. wezterm.pad_right(icon, 3) },
    })

    local title = pane:get_title()
    local date = ' ' .. wezterm.strftime('%H:%M %d-%m-%Y') .. ' '

    -- figure out a way to center it
    window:set_right_status(wezterm.format {
        { Background = { Color = '#555555' } },
        { Text = ' ' .. title .. ' ' },
        { Background = { Color = '#333333' } },
        { Text = date },
    })
end)

wezterm.on('format-tab-title', function (tab, _, _, _, _)
    -- i do not like how i can basically hide tabs if i zoom in
    local is_zoomed = ''
    if tab.active_pane.is_zoomed then
        is_zoomed = 'z'
    end

    return {
        { Text = ' ' .. tab.tab_index + 1 .. is_zoomed .. ' ' },
    }
end)

function M.apply(config)
    config.color_scheme = 'carbonfox'
    config.font = wezterm.font_with_fallback({
        'FiraCode Nerd Font',
        'FiraCode NFM', -- on windows it's named different
        'Hack',
        'Noto Sans Mono',
        'Noto Sans',
    })
    config.font_size = 16

    config.window_padding = {
        left = '6px',
        right = '6px',
        top = '2px',
        bottom = 0,
    }

    config.colors = {
        tab_bar = {
            background = '#333333',

            active_tab = {
                fg_color = '#ffffff',
                bg_color = '#444444',
            },

            new_tab = {
                bg_color = '#333333',
                fg_color = '#ffffff',
            },

            new_tab_hover = {
                bg_color = '#555555',
                fg_color = '#ffffff',
            },
        },
    }

    local window_min = ' 󰖰 '
    local window_max = ' 󰖯 '
    local window_close = ' 󰅖 '

    -- the resize border bugs out on kde plasma, and plasma adds its own anyway
    if globals.IS_KDE then
        config.window_decorations = 'INTEGRATED_BUTTONS'
    else
        config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
    end

    config.integrated_title_buttons = { 'Maximize', 'Close' }
    config.tab_bar_style = {
        window_hide = window_min,
        window_hide_hover = window_min,
        window_maximize = window_max,
        window_maximize_hover = window_max,
        window_close = window_close,
        window_close_hover = window_close,
    }

    -- makes the tabbar look more like TUI
    config.use_fancy_tab_bar = false;

    -- remove all link parsing, i hate it
    config.hyperlink_rules = {}

    -- TODO change frame color depending on the user var
    config.window_frame = {
        border_left_width = '3px',
        border_right_width = '3px',
        border_bottom_height = '3px',
        border_top_height = '3px',
        border_left_color = 'gray',
        border_right_color = 'gray',
        border_bottom_color = 'gray',
        border_top_color = 'gray',
    }
end

return M
