vim.opt.encoding = 'utf-8'

-- load all the plugins
require('plugins')

-- get config path
local cfg = vim.fn.stdpath('config')

-- load machine specific file if it exists
local custom_lua_file = 'custom_' .. vim.fn.hostname():lower()
if vim.fn.glob(cfg .. '/lua/' .. custom_lua_file .. '.lua') ~= '' then
    vim.g.custom_file_loaded = true
    require(custom_lua_file)
end

-- indent stuff
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- enable undo history persistance between sessions (neovim has sane defaults)
vim.opt.undofile = true

vim.opt.scrolloff=6 -- keep 2 lines above/below cursor
vim.opt.sidescrolloff=6 -- keep 2 characters left/right of the cursor

-- TODO: add recognizible character when line does not fit
-- TODO: custimize cursorline to change color slightly so i know where cursor is

-- show hybrid line numbers
vim.opt.number = true
-- todo: make relative numbers show on keybinding instead
--vim.opt.relativenumber = true

-- enable mouse support
-- TODO: it can be useful but prevents copy on computer
--vim.opt.mouse = 'a'

-- TODO: exapnd this further
vim.opt.wildignore:append('*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx')

-- make cursor go over to the next line when it hits the end like
-- literally every other editor ever?
vim.opt.whichwrap:append('<,>,h,l,[,]')

-- allow comments in JSON
vim.cmd([[autocmd FileType json syntax match Comment +\/\/.\+$+]])

-- set rulers todo: figure out how much can fit on phone/tablet
--vim.opt.colorcolumn = '80,100'

-- its a waste to make space only do commands as its not used that often
vim.cmd("nmap <space> <nop>")
vim.cmd("nnoremap <space>; :")

-- reload config
vim.cmd("nnoremap <space><F12> :source ~/.config/nvim/init.lua<CR>")

-- often used
vim.cmd("nnoremap <space>q :q<CR>")
vim.cmd("nnoremap <space>w :w<CR>")

-- edit file
vim.cmd("nnoremap <space>e :e ")
vim.cmd("nnoremap <space>E :tabe ")

-- switch tabs
vim.cmd("nnoremap <M-,> :tabp<CR>")
vim.cmd("nnoremap <M-.> :tabn<CR>")

-- easier redo
vim.cmd("nnoremap <S-u> <C-r>")

---- coc recommended settings!! ----
-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- TODO: this could be removed if i made symbol highlighting a keybinding, may be annoying but may improve performance especially on tablet/phone
-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable delays and poor user experience
vim.opt.updatetime = 300

-- TODO: make it shown only in files that can be debugged / show the diagnostics...
-- Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved
--vim.opt.signcolumn = 'yes'

