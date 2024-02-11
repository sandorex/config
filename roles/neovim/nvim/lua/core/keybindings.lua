vim.keymap.set({ 'n', 'v' }, '<leader>', '<nop>', { silent = true })

--- REMAPS ---
-- map arrow keys to hjkl so i dont have to duplicate bindings
for key, arrow in pairs({h='Left', j='Down', k='Up', l='Right'}) do
    vim.keymap.set({'n', 'v'}, '<' .. arrow .. '>', key, { remap = true, silent = true })
    vim.keymap.set({'n', 'v'}, '<M-' .. arrow .. '>', '<M-' .. key .. '>', { remap = true, silent = true })
    vim.keymap.set({'n', 'v'}, '<S-' .. arrow .. '>', '<S-' .. key .. '>', { remap = true, silent = true })
    vim.keymap.set({'n', 'v'}, '<C-' .. arrow .. '>', '<C-' .. key .. '>', { remap = true, silent = true })
end

-- remap shift left/right to be word based
vim.keymap.set({'n', 'v'}, '<S-h>', 'b', { remap = true, silent = true })
vim.keymap.set({'n', 'v'}, '<S-l>', 'w', { remap = true, silent = true })

---- KEYBINDINGS ----
-- treat word wrap as lines when moving up/down
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- buffer
vim.keymap.set('n', '<leader>B', '<cmd>bd<cr>', { desc = 'Drop buffer', silent = true })
vim.keymap.set('n', '[b', '<cmd>bprev<cr>', { desc = 'Previous buffer', silent = true })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer', silent = true })

vim.keymap.set('n', '[t', '<cmd>tabp<cr>', { desc = 'Previous tab', silent = true })
vim.keymap.set('n', ']t', '<cmd>tabn<cr>', { desc = 'Next tab', silent = true })

-- remap shift up down to be half page not full page and center cursor
vim.keymap.set('n', '<S-k>', '<C-u>zz', { desc = 'Half page up' })
vim.keymap.set('n', '<S-j>', '<C-d>zz', { desc = 'Half page down' })

-- often used
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { silent = true })
vim.keymap.set('n', '<leader>Q', '<cmd>qall<cr>', { silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { silent = true })
-- vim.keymap.set('n', '<leader>W', '<cmd>wall<cr>', { silent = true })

-- edit file
vim.keymap.set('n', '<leader>e', ':e ', { desc = 'Open file' })
vim.keymap.set('n', '<leader>E', ':tabe ', { desc = 'Open file in a tab' })

-- move content lines
vim.keymap.set('n', '<M-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up', silent = true })
vim.keymap.set('n', '<M-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down', silent = true })

-- NOTE: intentionally using ':' instead of <cmd> as it does not work with visual mode
vim.keymap.set('v', '<M-k>', ":m '<-2<cr>gv=gv", { desc = 'Move lines up', silent = true })
vim.keymap.set('v', '<M-j>', ":m '>+1<cr>gv=gv", { desc = 'move lines down', silent = true })

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

-- TODO maybe run plugin specific stuff here? like have section for both enabled/disabled state

