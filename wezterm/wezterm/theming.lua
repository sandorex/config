local wezterm = require('wezterm')

local COLORS = {}
COLORS.TEXT = '#FFFFFF'
COLORS.BG = '#4A4A4A'
COLORS.BG_DIM = '#333333'

local M = {}

wezterm.on('update-right-status', function(window, pane)
    local cols = pane:get_dimensions().cols
    local user_vars = pane:get_user_vars()

    local icon = user_vars.tab_icon
    if not icon or icon == '' then
        -- fallback for the icon,
        icon = ''
    end

    local icon_color = user_vars.tab_color
    if not icon_color then
        icon_color = 'white'
    end

    window:set_left_status(wezterm.format {
        { Background = { Color = icon_color } },
        { Foreground = { Color = COLORS.BG } },
        { Text = '  ' .. wezterm.pad_right(icon, 2) .. ' '  },
    })

    local title = pane:get_title()
    local date = ' ' .. wezterm.strftime('%H:%M %d-%m-%Y') .. ' '

    -- generate padding to center title by adding half of width (cols), half
    -- of title length, length of date string and integrated buttons width
    --
    -- the 1 at the end is cause of extra space after date to separate it from
    -- buttons
    --
    -- if there are any theming in date or title use `wezterm.column.width`
    local padding = wezterm.pad_right('', (cols / 2) - (string.len(title) / 2) - string.len(date) - 3*3 - 3)

    window:set_right_status(wezterm.format {
        { Text = title },
        { Foreground = { Color = COLORS.TEXT } },
        { Background = { Color = COLORS.BG } },
        { Text = padding .. '' },
        { Foreground = { Color = COLORS.BG } },
        { Background = { Color = COLORS.TEXT } },
        { Text = date },
        { Foreground = { Color = COLORS.TEXT } },
        { Background = { Color = COLORS.BG } },
        { Text = ' ' },
    })
end)

wezterm.on('format-tab-title', function (tab, _, _, _, _)
    -- i could forget i've zoomed in and forget about a pane in a tab
    local is_zoomed = ''
    if tab.active_pane.is_zoomed then
        is_zoomed = 'z'
    end

    -- colors are set in config.colors.tab_bar
    return ' ' .. tab.tab_index + 1 .. is_zoomed .. ' '
end)

function M.apply(config)
    config.color_scheme = 'carbonfox'
    config.font = wezterm.font_with_fallback({
        'FiraCode Nerd Font',
        'Hack',
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
            new_tab = {
                bg_color = COLORS.BG,
                fg_color = COLORS.TEXT,
            },

            new_tab_hover = {
                bg_color = COLORS.TEXT,
                fg_color = COLORS.BG,
            },
        },
    }

    local window_min = ' 󰖰 '
    local window_max = ' 󰖯 '
    local window_close = ' 󰅖 '

    config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
    config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }
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

    config.window_frame = {
        border_left_width = '4px',
        border_right_width = '4px',
        border_bottom_height = '4px',
        border_left_color = COLORS.BG,
        border_right_color = COLORS.BG,
        border_bottom_color = COLORS.BG,
        border_top_color = COLORS.BG,
    }
end

return M
