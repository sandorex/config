-- separate vim plugins just in case
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set default themes (overriden when theme loads)
vim.g.colorscheme_dark = 'habamax'
vim.g.colorscheme_light = 'shine'

require('core.languages')
require('core.functions')
require('core.keybindings')
require('core.editor')
require('core.right_click_menu')
require('core.netrw')
require('core.auto')
require('core.lazy')
require('core.themesync')

