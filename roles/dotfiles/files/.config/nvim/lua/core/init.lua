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

-- automatically set dark / light theme
local variant = vim.env.THEME_VARIANT:lower() or 'dark'
if variant == 'dark' then
    vim.cmd('colorscheme ' .. vim.g.colorscheme_dark)
else
    vim.cmd('colorscheme ' .. vim.g.colorscheme_light)
end

-- TODO add toggle keybinding for the theme
