-- wezterm configuration
local wezterm = require('wezterm')
local act = wezterm.action

local globals = require('globals')
local util = require('util')

local config = {}
if wezterm.config_builder then
    -- makes nicer error messages for config errors
    config = wezterm.config_builder()
end

config.check_for_updates = true
-- config.window_close_confirmation = 'NeverPrompt'

-- NOTE: do not use login shells as they make it load profile each time and
-- when there is no need to do that, except in containers
config.default_prog = globals.MENU_SYSTEM_SHELL.args
config.launch_menu = {
    globals.MENU_SYSTEM_SHELL,
}

-- default hyperlink rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
    regex = [[(SC\d+)]],
    format = 'https://www.shellcheck.net/wiki/$1',
})

-- -- override + button so it uses globals.MENU_DEFAULT instead of default_prog
-- wezterm.on('new-tab-button-click', function(window, pane, button, _)
--     if button == 'Left' then
--         -- show launcher
--         window:perform_action(act.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' }, pane)
--     elseif button == 'Middle' then
--         -- spawn system shell on middle click
--         window:perform_action(act.SpawnCommandInNewTab(globals.MENU_SYSTEM_SHELL), pane)
--     elseif button == 'Right' then
--         -- show launcher
--         window:perform_action(act.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' }, pane)
--     end
--
--     -- prevent default action
--     return false
-- end)

-- wezterm.on('gui-startup', function(cmd_obj)
--     -- if wezterm has no subcommand then cmd_obj is nil
--     if not cmd_obj then
--         wezterm.log_info('cmd_obj is nil')
--         wezterm.mux.spawn_window(globals.MENU_DEFAULT)
--         return
--     end
--
--     local args = cmd_obj.args or {}
--     -- for debugging uncomment this
--     -- wezterm.log_info('start args: ' .. util.dump(args))
--
--     -- override the default prog as its broken in flatpak
--     if args == nil or next(args) == nil then
--         wezterm.mux.spawn_window(globals.MENU_DEFAULT)
--         return
--     end
--
--     -- all custom commands need to be prefixed by @
--     if args[1] ~= '@' then
--         -- if no windows are spawned then wezterm will do it
--         return
--     end
--
--     -- custom commands --
--     -- wezterm start -- @ launch_menu <index|label> - runs launch_menu item by index or label
--     if args[2] == 'launch_menu' and args[3] then
--         local arg = args[3]
--         local index = tonumber(arg)
--
--         -- the arg is a number so use it as an index
--         if index ~= nil then
--             local menu_item = config.launch_menu[index]
--             if menu_item == nil then
--                 wezterm.log_error('menu item not found by index ' .. arg)
--             end
--
--             -- try to spawn the launch menu with the specific index or default
--             wezterm.mux.spawn_window(menu_item or globals.MENU_DEFAULT)
--             return
--         else
--             -- the argument is not a number so try to match it with a label
--             for _, menu_item in ipairs(config.launch_menu) do
--                 if arg and string.lower(menu_item.label) == string.lower(arg) then
--                     wezterm.mux.spawn_window(menu_item)
--                     return
--                 end
--             end
--
--             wezterm.log_error('menu item not found by label "' .. arg .. '"')
--
--             -- spawn the default
--             wezterm.mux.spawn_window(globals.MENU_DEFAULT)
--             return
--         end
--     end
-- end)

-- NOTE: buggy on wayland kde plasma, causes flickering
config.hide_mouse_cursor_when_typing = false

-- disable the password fancy icons
config.detect_password_input = false

--- EXTRA FILES ---
-- merge keybindings onto the config
require('theming').apply(config)
require('keybindings').apply(config)

return config
