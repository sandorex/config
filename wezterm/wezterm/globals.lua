-- contains all globally accessed things

local M = {}

M.FLATPAK = os.getenv('container') == 'flatpak'

M.DESKTOP = os.getenv('XDG_SESSION_DESKTOP')
M.IS_KDE = M.DESKTOP == 'KDE'

M.SHELL = os.getenv('SHELL')
if M.FLATPAK or not M.SHELL then
    -- shell var in flatpak is always /bin/sh so default to zsh
    M.shell = '/usr/bin/zsh'
end

-- default that overrides config.default_prog
M.MENU_DEFAULT = {
    label = 'Daily',
    args = { 'distrobox-enter-wrapper', 'daily' },
}

-- runs system shell, overrides so no unecessary login shells
M.MENU_SYSTEM_SHELL = {
    label = 'System Shell',
    args = { M.shell },
}

return M

