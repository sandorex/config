local options = {
    encoding = 'utf-8',

    -- indent options
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,
    expandtab = true,

    showmode = false,

    cursorline = true,
    --cursorlineopt = 'number',

    -- set terminal title
    title = os.getenv('TMUX') ~= nil,

    -- enable clipboard syncing, works with tmux without any additional config
    clipboard = 'unnamedplus',

    ignorecase = true,
    smartcase = true,

    -- undo history persistance between sessions (nvim defaults are good)
    undofile = true,
    backup = false,
    writebackup = false,

    -- scrolls when cursor gets too close to bounds of the screen
    scrolloff = 12,
    sidescrolloff = 12,

    number = true,
    signcolumn = 'yes',

    updatetime = 300,

    -- key timeout timing, setting this too high will break WhichKey but
    -- setting it too low will make it harder to hit combo keys
    timeout = true,
    timeoutlen = 300,

    foldmethod = 'marker',
    foldmarker = '--/,/--',
    foldtext = 'v:lua.CustomFoldText()',
    fillchars = 'fold: ',

    -- default to everything unfolded
    foldlevel = 99,

    -- guide lines
    colorcolumn = '80,100',
}

function CustomFoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    local _, index = string.find(line, '--/', 1, true)

    line = string.sub(line, index + 1)

    if string.sub(line, 1, 1) == ' ' then
        line = string.sub(line, 2)
    end

    if line == '' then
        return '+' .. vim.v.folddashes .. ' ' .. (vim.v.foldend - vim.v.foldstart) .. ' lines ' .. vim.v.folddashes .. '+'
    end

    return '+' .. vim.v.folddashes .. '/ ' .. line .. ' /' .. vim.v.folddashes .. '+'
end

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
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_user_command('CoreHealth', 'checkhealth core', {})

-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

