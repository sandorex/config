-- wezterm configuration
local wezterm = require('wezterm')
local util = require('util')

local config = {}
if wezterm.config_builder then
    -- makes nicer error messages for config errors
    config = wezterm.config_builder()
end

-- config.check_for_updates = true
-- config.window_close_confirmation = 'NeverPrompt'

local appearance = util.get_appearance()

local function get_shell()
    if os.getenv("container") ~= nil then
        return '/bin/zsh'
    end

    return os.getenv("SHELL") or '/bin/zsh'
end

-- let apps know which theme to use
config.set_environment_variables = {}
config.set_environment_variables['THEME_VARIANT'] = appearance:lower()

config.launch_menu = {
    {
        label = 'System Shell',
        args = { get_shell() }
    },
}

-- do not use login shell as there is no need to read .profile multiple times
config.default_prog = config.launch_menu[1].args

-- default hyperlink rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
    regex = [[(SC\d+)]],
    format = 'https://www.shellcheck.net/wiki/$1',
})

-- NOTE: buggy on wayland kde plasma, causes flickering
config.hide_mouse_cursor_when_typing = false

-- disable the password fancy icons
config.detect_password_input = false

-- apply other modules
require('theming').apply(config)
require('keybindings').apply(config)

return config
