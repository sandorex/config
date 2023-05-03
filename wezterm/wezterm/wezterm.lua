-- wezterm configuration

local wezterm = require('wezterm')

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'carbonfox'
config.font = wezterm.font 'FiraCode Nerd Font' -- called 'FiraCode NFM' on windows for some reason
config.font_size = 16

config.hide_tab_bar_if_only_one_tab = true

-- NOTE: this is disabled cause it causes issues on wayland
config.hide_mouse_cursor_when_typing = false

return config
