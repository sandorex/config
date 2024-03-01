vim.keymap.set({ 'n', 'v' }, '<leader>', '<nop>', { silent = true })

--- REMAPS ---
-- make c-Left/c-Right move by word
vim.keymap.set({'n', 'v'}, '<C-Left>', 'b', { remap = true, silent = true })
vim.keymap.set({'n', 'v'}, '<C-Right>', 'w', { remap = true, silent = true })

-- make c-Up/C-Down move by half a screen
vim.keymap.set('i', '<C-Up>', '<C-o><C-u><C-o>zz', { silent = true })
vim.keymap.set('i', '<C-Down>', '<C-o><C-d><C-o>zz', { silent = true })
vim.keymap.set({'n', 'v'}, '<C-Up>', '<C-u>zz', { silent = true })
vim.keymap.set({'n', 'v'}, '<C-Down>', '<C-d>zz', { silent = true })

-- make <Up>/<Down> respect word wrap
vim.keymap.set('i', '<Up>', "v:count == 0 ? '<C-o>gk' : '<C-o>k'", { expr = true, silent = true })
vim.keymap.set('i', '<Down>', "v:count == 0 ? '<C-o>gj' : '<C-o>j'", { expr = true, silent = true })
vim.keymap.set({'n', 'v'}, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({'n', 'v'}, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

---- KEYBINDINGS ----
-- buffer
vim.keymap.set('n', '<leader>B', '<cmd>bd<cr>', { desc = 'Drop buffer', silent = true })
vim.keymap.set('n', '[b', '<cmd>bprev<cr>', { desc = 'Previous buffer', silent = true })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer', silent = true })

--vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { silent = true })
vim.keymap.set('n', '<leader>Q', '<cmd>qall<cr>', { silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { silent = true })

-- edit file
vim.keymap.set('n', '<leader>e', ':e ', { desc = 'Open file' })

-- move content lines
vim.keymap.set('n', '<M-Up>', '<cmd>m .-2<cr>==', { desc = 'Move line up', silent = true })
vim.keymap.set('n', '<M-Down>', '<cmd>m .+1<cr>==', { desc = 'Move line down', silent = true })
vim.keymap.set('v', '<M-Up>', ":m '<-2<cr>gv=gv", { desc = 'Move lines up', silent = true })
vim.keymap.set('v', '<M-Down>', ":m '>+1<cr>gv=gv", { desc = 'move lines down', silent = true })

-- explore
vim.keymap.set('n', '<leader>f', '<cmd>e %:p:h<cr>', { desc = 'Open netrw in cwd', silent = true })

-- dont yank when pasting
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking', silent = true })

-- easier redo
vim.keymap.set('n', '<S-u>', '<C-r>', { desc = 'Redo', silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>D', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- TODO figure out a way to replace some gaps if some plugins are missing
