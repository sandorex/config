local options = {
    encoding = 'utf-8',

    -- indent options
    autoindent = true,
    expandtab = true,
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,

    showmode = false,

    completeopt = 'menuone,noselect',

    cursorline = true,
    --cursorlineopt = 'number',

    -- set terminal title
    title = true,

    -- enable clipboard syncing, works with tmux without any additional config
    clipboard = 'unnamedplus',

    -- do not move cursor on right mouse click
    mousemodel = 'popup',

    ignorecase = true,
    smartcase = true,

    -- undo history persistance between sessions (nvim defaults are good)
    undofile = true,
    backup = false,
    writebackup = false,

    -- scrolls when cursor gets too close to bounds of the screen
    scrolloff = 3,
    sidescrolloff = 3,

    number = true,
    signcolumn = 'yes',

    updatetime = 300,

    -- key timeout timing, setting this too high will break WhichKey but
    -- setting it too low will make it harder to hit combo keys
    timeout = true,
    timeoutlen = 300,

    foldmethod = 'syntax',
    fillchars = 'fold: ',

    -- default to everything unfolded
    foldlevel = 99,

    -- guide lines
    colorcolumn = '80,100',

    -- TODO comment
    breakindent = true,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- TODO: exapnd this further
vim.opt.wildignore:append('*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx')

-- make cursor go over to the next line when it hits the end like
-- literally every other editor ever?
vim.opt.whichwrap:append('<,>,h,l,[,]')

-- TODO: add recognizible character when line does not fit

-- separate vim plugins just in case
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

-- allow comments in JSON
vim.cmd([[autocmd FileType json syntax match Comment +\/\/.\+$+]])

-- remove trailing whitespaces
local group = vim.api.nvim_create_augroup('whitespace-remover', {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

-- local function toggle_cursor_centering(value)
--     if value == nil then
--         value = not vim.g.cursor_centering
--     end
--
--     group = vim.api.nvim_create_augroup('cursor-center', {})
--     if value then
--         vim.api.nvim_create_autocmd("CursorMoved", {
--             group = group,
--             command = 'norm! zz',
--         })
--     end
--
--     vim.g.cursor_centering = value
-- end

-- toggle_cursor_centering(false)

vim.api.nvim_create_user_command('CoreHealth', 'checkhealth core', {})

-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('core.right_click_menu')
require('core.theming')
require('core.statusline')
require('core.netrw')
require('core.keybindings')

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load the actual plugins
require('lazy').setup('plugins')

