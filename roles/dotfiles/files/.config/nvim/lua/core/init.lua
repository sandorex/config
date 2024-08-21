-- the main initialization point of the configuration

-- separate vim plugins just in case
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set default themes (overriden when theme loads)
vim.g.colorscheme_dark = 'slate'
vim.g.colorscheme_light = 'delek'

require('core.languages')
require('core.functions')
require('core.keybindings')
require('core.editor')
require('core.right_click_menu')
require('core.netrw')
require('core.auto')
require('core.lazy')
require('core.themesync')

-- open netrw by default if no args
if vim.fn.argc() == 0 then
    vim.g.root_dir = vim.fn.getcwd()
    vim.api.nvim_create_autocmd({"VimEnter"}, {
        pattern = {"*"},
        command  = ":silent! Explore",
        group = vim.api.nvim_create_augroup("netrw", {clear = true})
    })
end

