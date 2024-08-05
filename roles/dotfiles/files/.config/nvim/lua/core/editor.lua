-- file contains tweaks of vim editing experience

vim.opt.encoding = 'utf-8'

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.showmode = false -- do not add '-- MODE --' text as statusline does it

vim.opt.completeopt = 'menuone,noselect' -- ??

vim.opt.cursorline = true -- highlight the line where cursor is
vim.opt.title = true -- set terminal title

-- use primary clipboard by default (IDE experience)
vim.o.clipboard = 'unnamedplus'

-- ability to force OSC 52 usage
if os.getenv('NVIM_FORCE_OSC52') ~= nil and vim.fn.has('nvim-0.10') then
    -- copy to primary clipboard but not paste, cause you can easily press
    -- CTRL + SHIFT + V
    vim.o.clipboard = 'unnamed'

    -- make it use terminal for clipboard (works through tmux or even in container)
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
            ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
        },
    }
end

vim.opt.mousemodel = 'popup' -- do not move cursor on right mouse click

vim.opt.ignorecase = true -- case-insensitive search by default
vim.opt.smartcase = true -- ?!?

vim.opt.undofile = true -- preserve history between sessions
vim.opt.backup = false  -- do not create annoying backup files
vim.opt.writebackup = false

vim.opt.scrolloff = 3     -- scroll when less than 3 lines away from any
vim.opt.sidescrolloff = 3 -- edge edge

vim.opt.number = true -- ??
vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 300

-- this should be high if WhichKey is used, otherwise at least 800
vim.opt.timeout = true
vim.opt.timeoutlen = 800

-- TODO redo this
vim.opt.foldlevel = 99 -- unfold everything by default TODO
vim.opt.foldmethod = 'syntax'
vim.opt.fillchars = 'fold: '

vim.opt.colorcolumn = '80,100' -- guide lines (old standard 80 and my fav 100)

vim.opt.breakindent = true -- ??

vim.opt.wildignore:append('*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx')

-- make cursor go over to the next line when it hits the end like
-- literally every other editor ever?
vim.opt.whichwrap:append('<,>,h,l,[,]')
