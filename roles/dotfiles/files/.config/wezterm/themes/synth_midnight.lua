local wezterm = require 'wezterm'

local M = {}
M.LIGHT = 'Synth Midnight Light Custom'
M.DARK = 'Synth Midnight Dark Custom'

function M.apply(config)
    local light = wezterm.get_builtin_color_schemes()['Synth Midnight Terminal Light (base16)']
    local dark = wezterm.get_builtin_color_schemes()['Synth Midnight Terminal Dark (base16)']

    config.color_schemes = config.color_schemes or {}
    config.color_schemes[M.LIGHT] = light
    config.color_schemes[M.DARK] = dark
end

return M

