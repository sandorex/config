local wezterm = require 'wezterm'

local M = {}
M.LIGHT = 'Solarized Light Custom'
M.DARK = 'Solarized Dark Custom'

function M.apply(config)
    local solarized_light = wezterm.get_builtin_color_schemes()['Solarized (light) (terminal.sexy)']

    local solarized_dark = wezterm.get_builtin_color_schemes()['Solarized (dark) (terminal.sexy)']
    solarized_dark.background = '#242424'

    config.color_schemes = config.color_schemes or {}
    config.color_schemes[M.LIGHT] = solarized_light
    config.color_schemes[M.DARK] = solarized_dark
end

return M

