---- KEYBINDINGS ----
vim.keymap.set('n', '[b', '<cmd>bprev<cr>', { desc = 'Previous buffer', silent = true })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer', silent = true })

vim.keymap.set('n', '[t', '<cmd>tabp<cr>', { desc = 'Previous tab', silent = true })
vim.keymap.set('n', ']t', '<cmd>tabn<cr>', { desc = 'Next tab', silent = true })

--- custom ---
vim.keymap.set('n', '<space>', '<nop>')
vim.keymap.set('n', '<space>;', ':', { desc = 'Command' })

-- often used
vim.keymap.set('n', '<space>q', '<cmd>q<cr>', { silent = true })
vim.keymap.set('n', '<space>Q', '<cmd>qall<cr>', { silent = true })
vim.keymap.set('n', '<space>w', '<cmd>w<cr>', { silent = true })
vim.keymap.set('n', '<space>W', '<cmd>wall<cr>', { silent = true })

-- edit file
vim.keymap.set('n', '<space>e', ':e ', { desc = 'Open file' })
vim.keymap.set('n', '<space>E', ':tabe ', { desc = 'Open file (tab)' })

-- explore
vim.keymap.set('n', '<space>f', '<cmd>E<cr>', { desc = 'Open netrw in cwd', silent = true })

-- switch tabs
--vim.keymap.set('n', '<M-/>', '<cmd>tabn<cr> ', { desc = 'Next tab', silent = true })

-- easier redo
vim.keymap.set('n', '<S-u>', '<C-r>', { desc = 'Redo', silent = true })

