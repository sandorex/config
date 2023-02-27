---- KEYBINDINGS ----
-- its a waste to make space only do commands as its not used that often
vim.cmd("nmap <space> <nop>")
vim.cmd("nnoremap <space>; :")

-- reload config
vim.cmd("nnoremap <space><F12> :luafile ~/.config/nvim/init.lua<CR>")

-- often used
vim.cmd("nnoremap <space>q :q<CR>")
vim.cmd("nnoremap <space>w :w<CR>")

-- edit file
vim.cmd("nnoremap <space>e :e ")
vim.cmd("nnoremap <space>E :tabe ")

-- switch tabs
vim.cmd("nnoremap <M-/> :tabn<CR>")

-- easier redo
vim.cmd("nnoremap <S-u> <C-r>")
