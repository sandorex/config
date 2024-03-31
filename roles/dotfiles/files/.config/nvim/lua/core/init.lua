-- separate vim plugins just in case
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set default themes (overriden when theme loads)
vim.g.colorscheme_dark = 'habamax'
vim.g.colorscheme_light = 'shine'

require('core.languages')
require('core.keybindings')
require('core.editor')
require('core.right_click_menu').apply()
require('core.netrw')
require('core.auto')
require('core.lazy')

-- gets colorscheme from xdg desktop portal
-- requires gdbus
local function get_colorscheme()
    local handle = io.popen('gdbus call --session'
                         .. ' --dest=org.freedesktop.portal.Desktop'
                         .. ' --object-path=/org/freedesktop/portal/desktop'
                         .. ' --method=org.freedesktop.portal.Settings.Read'
                         .. ' org.freedesktop.appearance color-scheme')

    local result = handle:read('*a')
    handle:close()

    if result and string.match(result, ' %d') == ' 2' then
        return 'light'
    else
        -- dark mode is default
        return 'dark'
    end
end

function SetTheme(variant)
    -- TODO Sometime in future use OSC 11 ANSI, cannot get it to work currently
    if variant == nil then
        variant = get_colorscheme()
    end

    -- NOTE if you set the same colorscheme again it flickers
    if variant == 'light' then
        if vim.g.colors_name ~= vim.g.colorscheme_light then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_light)
        end
    else -- default to dark mode if invalid variant is passed
        if vim.g.colors_name ~= vim.g.colorscheme_dark then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_dark)
        end
    end
end

-- set the theme on SIGUSR1 signal
vim.api.nvim_create_autocmd({ 'Signal' }, {
    pattern = { 'SIGUSR1' },
    callback = function()
        SetTheme()
    end,
})

-- set theme when resuming
vim.api.nvim_create_autocmd({ 'VimResume' }, {
    callback = function()
        -- set theme (without delay modeline plugin does not update colors properly)
        vim.fn.timer_start(100, function()
            SetTheme()
        end)
    end,
})

-- set the theme initially
SetTheme()

