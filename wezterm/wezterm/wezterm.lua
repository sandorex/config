-- wezterm configuration
local wezterm = require('wezterm')

local config = {}
if wezterm.config_builder then
    -- makes nicer error messages for config errors
    config = wezterm.config_builder()
end

--- GLOBALS ---
local WINDOWS = wezterm.target_triple == 'x86_64-pc-windows-msvc'
local FLATPAK = os.getenv('container') == 'flatpak'

config.check_for_updates = true

-- NOTE: do not use login shells as they make it load profile each time and
-- when there is no need to do that, except in containers
if WINDOWS then
    -- TODO:
    -- default_domain = "WSL:Ubuntu"
else
    local shell = os.getenv('SHELL')
    if FLATPAK or not shell then
        -- shell var in flatpak is always /bin/sh so default to zsh
        shell = '/usr/bin/zsh'
    end

    config.launch_menu = {
        -- TAKE CARE NOT TO CHANGE LABELS AS IT IS USED TO START SPECIFIC
        -- SHELL FROM DESKTOP
        {
            label = 'Daily',
            args = { 'distrobox', 'enter', 'daily' },
        },
        {
            label = 'Toolbox',
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

-- add menu subcommand `wezterm start menu <index|label>`
wezterm.on('gui-startup', function(cmd_obj)
    if cmd_obj then
        local args = cmd_obj.args

        local command = args[1]
        if command == 'menu' then
            local arg = args[2]
            local index = tonumber(arg)

            if index ~= nil then
                -- try to spawn the launch menu with the specific index
                wezterm.mux.spawn_window(config.launch_menu[index] or {})
                return
            else
                -- the argument is not a number so try to match it with a label
                for _, menu_item in ipairs(config.launch_menu) do
                    if arg and string.lower(menu_item.label) == string.lower(arg) then
                        wezterm.mux.spawn_window(menu_item)
                        return
                    end
                end

                -- no matches found, spawn the default
                wezterm.mux.spawn_window({})
            end
        end
    end

    -- fallback to default way it works so i dont break anything
    wezterm.mux.spawn_window(cmd_obj or {})
end)

--- THEMING ---
config.color_scheme = 'carbonfox'
config.font = wezterm.font_with_fallback({
    'FiraCode Nerd Font',
    'FiraCode NFM', -- on windows it's named different
    'Hack',
    'Noto Sans Mono',
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

-- makes the tabbar look more like TUI
config.use_fancy_tab_bar = false;
-- config.hide_tab_bar_if_only_one_tab = true -- you can drag using the tab bar

--- BEHAVIOUR ---
config.hide_mouse_cursor_when_typing = false

-- remove all link parsing
config.hyperlink_rules = {}

-- makes alt act as regular alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.window_decorations = 'RESIZE'

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

    local title = wezterm.truncate_right(pane:get_title(), 50)
    local date = ' ' .. wezterm.strftime('%H:%M %d-%m-%Y') .. ' '

    -- figure out a way to center it
    window:set_right_status(wezterm.format {
        { Background = { Color = '#555555' } },
        { Text = ' ' .. title .. ' ' },
        { Background = { Color = '#333333' } },
        { Text = date },
    })
end)

wezterm.on('format-tab-title', function (tab, tabs, panes, config, hover)
    -- i do not like how i can basically hide tabs if i zoom in
    local is_zoomed = ''
    if tab.active_pane.is_zoomed then
        is_zoomed = 'z'
    end

    return {
        { Text = ' ' .. tab.tab_index + 1 .. is_zoomed .. ' ' },
    }
end)

--- EXTRA FILES ---
-- merge keybindings onto the config
require('keybindings').apply(config)

return config
