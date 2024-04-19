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
require('core.session')

local function restore_session(path)
    -- only care if its a directory
    if vim.fn.isdirectory(path) ~= 1 then
        return
    end

    -- save root dir so other macros and functionality can use it as project dir
    vim.g.root_dir = path

    -- try to load the session, using pcall prevents errors from loading the session
    local success, result = pcall(require('core.session').load_session, path)

    if not success then
        vim.notify('Error while loading directory session automatically')
        -- TODO log somewhere why it failed so it could be debugged
        return
    end

    if result then
        vim.notify('Loaded directory session automatically')
    end
end

-- TODO load session only if no other window is open like lazy
-- TODO close the netrw buffer when restoring session
if vim.fn.argc() == 0 then
    -- there is no args so restore cwd session
    restore_session(vim.fn.getcwd())
else
    -- if first buffer is a directory then restore its session
    vim.api.nvim_create_autocmd('BufEnter', {
        once = true,
        callback = vim.schedule_wrap(function(args)
            restore_session(args.file)
        end),
    })
end

