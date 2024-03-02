-- separate vim plugins just in case
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set default themes
vim.g.colorscheme_dark = 'habamax'
vim.g.colorscheme_light = 'shine'

require('core.languages')
require('core.keybindings')
require('core.editor')
require('core.right_click_menu')
require('core.netrw')
require('core.auto')
require('core.lazy')

local function set_theme()
    -- automatically set dark / light theme
    local hour = tonumber(os.date('%H')) or '20'

    -- set dark theme from 18 00 to 05 59
    if hour < 6 or hour >= 18 then
        if vim.g.colors_name ~= vim.g.colorscheme_dark then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_dark)
        end
    else
        if vim.g.colors_name ~= vim.g.colorscheme_light then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_light)
        end
    end
end

-- set theme every focus gain
vim.api.nvim_create_autocmd('FocusGained', {
    callback = set_theme,
})

-- set the theme initially
set_theme()
