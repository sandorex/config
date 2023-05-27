-- wezterm configuration
local wezterm = require('wezterm')

local config = {}
if wezterm.config_builder then
    -- makes nicer error messages for config errors
    config = wezterm.config_builder()
end

local FLATPAK = os.getenv('container') == 'flatpak'
local shell = os.getenv('SHELL')
if FLATPAK or not shell then
    -- shell var in flatpak is always /bin/sh so default to zsh
    shell = '/usr/bin/zsh'
end

-- NOTE: do not use login shells as they make it load profile each time and
-- when there is no need to do that, except in containers
config.launch_menu = {
    --- DO NOT CHANGE THE LABELS ---
    {
        label = 'Daily',
        -- it wont start distrobox properly for some reason, it probably
        -- has something to do with it being a flatpak and running using
        -- flatpak-spawn..
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

-- default thing that runs when wezterm is started with 'wezterm start'
-- default to first item aka daily container
local DEFAULT_LAUNCH = config.launch_menu[1]

-- add menu subcommand `wezterm start menu <index|label>`
-- adds menu subcommand `wezterm start menu <index|label>` and launches
-- DEFAULT_LAUNCH by default to avoid config.default_prog
wezterm.on('gui-startup', function(cmd_obj)
    -- 'wezterm start' does not cound as a command or argument so it is nil
    if cmd_obj and cmd_obj.args then
        local args = cmd_obj.args

        local command = args[1]
        if command == 'menu' and args[2] then
            local arg = args[2]
            local index = tonumber(arg)

            if index ~= nil then
                -- try to spawn the launch menu with the specific index
                wezterm.mux.spawn_window(config.launch_menu[index] or DEFAULT_LAUNCH)
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
                wezterm.mux.spawn_window(DEFAULT_LAUNCH)
                return
            end
        end

        -- any non menu arguments passed
        wezterm.mux.spawn_window(cmd_obj)
        return
    end

    -- override config.default_prog as its broken in flatpak and does not run
    -- the program properly but inside its own sandboxed container...
    wezterm.mux.spawn_window(DEFAULT_LAUNCH)
end)

-- NOTE: buggy on wayland, causes flickering
config.hide_mouse_cursor_when_typing = false

config.check_for_updates = false

-- makes alt act as regular alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

--- EXTRA FILES ---
-- merge keybindings onto the config
require('theming').apply(config)
require('keybindings').apply(config)

return config
