vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

---- KEYBINDINGS ----
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })
vim.keymap.set('n', '<leader>;', ':', { desc = 'Command' })

vim.keymap.set('n', '[b', '<cmd>bprev<cr>', { desc = 'Previous buffer', silent = true })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer', silent = true })

vim.keymap.set('n', '[t', '<cmd>tabp<cr>', { desc = 'Previous tab', silent = true })
vim.keymap.set('n', ']t', '<cmd>tabn<cr>', { desc = 'Next tab', silent = true })

-- often used
vim.keymap.set('n', '<space>q', '<cmd>q<cr>', { silent = true })
vim.keymap.set('n', '<space>Q', '<cmd>qall<cr>', { silent = true })
vim.keymap.set('n', '<space>w', '<cmd>w<cr>', { silent = true })
vim.keymap.set('n', '<space>W', '<cmd>wall<cr>', { silent = true })

-- edit file
vim.keymap.set('n', '<space>e', ':e ', { desc = 'Open file' })
vim.keymap.set('n', '<space>E', ':tabe ', { desc = 'Open file (tab)' })

-- move content
vim.keymap.set('n', '<A-Up>', '<cmd>m .-2<cr>==', { desc = 'Move line up', silent = true })
vim.keymap.set('n', '<A-Down>', '<cmd>m .+1<cr>==', { desc = 'Move line down', silent = true })

-- explore
vim.keymap.set('n', '<space>f', '<cmd>E<cr>', { desc = 'Open netrw in cwd', silent = true })

-- dont yank when pasting
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking', silent = true })

-- easier redo
vim.keymap.set('n', '<S-u>', '<C-r>', { desc = 'Redo', silent = true })

