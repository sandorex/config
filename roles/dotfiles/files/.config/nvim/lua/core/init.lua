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

if vim.fn.argc() == 0 then
    vim.g.root_dir = vim.fn.getcwd()
    vim.cmd.Explore()
end

-- TODO this fails without plugins for some reason
--[[
-- open netrw if no args passed
if vim.fn.argc() == 0 then
    vim.cmd.Explore()
end

require('core.session').autoload_directory_session({
    session_loaded = function(path)
        -- kindof project root directory
        -- TODO move this into sparate var like vim.g.session_dir so it can be included in core.session
        vim.g.root_dir = path

        vim.notify('Loaded directory session automatically')
    end,
    session_load_error = function()
        vim.notify('Error while loading directory session automatically')
    end
})
]]--


