-- wezterm configuration
local wezterm = require('wezterm')
local act = wezterm.action

local globals = require('globals')

local config = {}
if wezterm.config_builder then
    -- makes nicer error messages for config errors
    config = wezterm.config_builder()
end

config.check_for_updates = false

-- NOTE: do not use login shells as they make it load profile each time and
-- when there is no need to do that, except in containers
config.launch_menu = {
    globals.MENU_DEFAULT,
    {
        label = 'Toolbox',
        args = { 'toolbox-enter-wrapper' },
    },
    globals.MENU_SYSTEM_SHELL,
}

-- override + button so it uses globals.MENU_DEFAULT instead of default_prog
wezterm.on('new-tab-button-click', function(window, pane, button, _)
    if button == 'Left' then
        -- spawn the default launch_menu item
        window:perform_action(act.SpawnCommandInNewTab(globals.MENU_DEFAULT), pane)
    elseif button == 'Middle' then
        -- spawn system shell on middle click
        window:perform_action(act.SpawnCommandInNewTab(globals.MENU_SYSTEM_SHELL), pane)
    elseif button == 'Right' then
        -- show launcher
        window:perform_action(act.ShowLauncher, pane)
    end

    -- prevent default action
    return false
end)

-- TODO FIXME: when opening a second terminal window it opens the shell for some reason
-- adds menu subcommand `wezterm start menu <index|label>` and launches
-- globals.MENU_DEFAULT by default to avoid config.default_prog
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
                wezterm.mux.spawn_window(config.launch_menu[index] or globals.MENU_DEFAULT)
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
                wezterm.mux.spawn_window(globals.MENU_DEFAULT)
                return
            end
        end

        -- any non menu arguments passed
        wezterm.mux.spawn_window(cmd_obj)
        return
    end

    -- override config.default_prog as its broken in flatpak and does not run
    -- the program properly but inside its own sandboxed container...
    wezterm.mux.spawn_window(globals.MENU_DEFAULT)
end)

-- NOTE: buggy on wayland, causes flickering
config.hide_mouse_cursor_when_typing = false

--- EXTRA FILES ---
-- merge keybindings onto the config
require('theming').apply(config)
require('keybindings').apply(config)

return config
