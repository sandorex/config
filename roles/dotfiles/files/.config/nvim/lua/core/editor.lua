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
if (os.getenv('SSH_TTY') ~= nil or os.getenv('NVIM_FORCE_OSC52') ~= nil) and vim.fn.has('nvim-0.10') then
    local function default_paste()
        return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
    end

    -- use OSC52 to copy to primary clipboard but do not paste from it as every terminal should
    -- support Ctrl + Shift + V
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            ['+'] = default_paste,
            ['*'] = default_paste,
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

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 4

vim.opt.colorcolumn = '80,100' -- guide lines (old standard 80 and my fav 100)

vim.opt.breakindent = true -- ??

vim.opt.wildignore:append('*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx')

-- make cursor go over to the next line when it hits the end like
-- literally every other editor ever?
vim.opt.whichwrap:append('<,>,h,l,[,]')
