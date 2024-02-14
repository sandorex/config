-- contains all globally accessed things

local wezterm = require('wezterm')

local M = {}

M.FLATPAK = os.getenv('container') == 'flatpak'

M.DESKTOP = os.getenv('XDG_SESSION_DESKTOP')
M.IS_KDE = M.DESKTOP == 'KDE'

M.SHELL = os.getenv('SHELL')
if M.FLATPAK or not M.SHELL then
    -- shell var in flatpak is always /bin/sh so default to zsh
    M.SHELL = '/usr/bin/zsh'
end

-- runs system shell, overrides so no unecessary login shells
M.MENU_SYSTEM_SHELL = {
    label = 'System Shell',
    args = { M.SHELL },
}

M.MENU_DEFAULT = M.MENU_SYSTEM_SHELL

function M.set_window_global(window, key, value)
    if not wezterm.GLOBAL.windows then
        wezterm.GLOBAL.windows = {}
    end

    local id = tostring(window:window_id())
    if not wezterm.GLOBAL.windows[id] then
        wezterm.GLOBAL.windows[id] = {}
    end

    wezterm.GLOBAL.windows[id][key] = value
end

function M.get_window_global(window, key)
    local success, value = pcall(function ()
        return wezterm.GLOBAL.windows[tostring(window:window_id())][key]
    end)
    if not success then
        return nil
    end

    return value
end

return M

