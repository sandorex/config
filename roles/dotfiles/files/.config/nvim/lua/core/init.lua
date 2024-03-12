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

-- Set theme to variant (dark or light) or automatically based on time
function SetTheme(variant)
    -- automatically set dark / light theme based on time
    if variant == nil then
        local hour = tonumber(os.date('%H'))

        -- set dark theme from 18 00 to 05 59
        if hour < 6 or hour >= 18 then
            variant = 'dark'
        else
            variant = 'light'
        end
    end

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

-- set theme every focus gain
vim.api.nvim_create_autocmd({ 'VimResume' }, {
    callback = function()
        -- without this delay the theme is not set properly
        vim.fn.timer_start(100, function()
            SetTheme()
        end)
    end,
})

-- set the theme initially
SetTheme()

