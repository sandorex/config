local wezterm = require('wezterm')

local M = {}

function M.get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end

    -- default to dark
    return 'Dark'
end

return M

