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
vim.opt.clipboard = 'unnamedplus' -- enable system clipboard

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

-- key timeout timing, setting this too high will break WhichKey but
-- setting it too low will make it harder to hit combo keys
vim.opt.timeout = true
vim.opt.timeoutlen = 300

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