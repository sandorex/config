-- all keybindings should be here

-- make wildchar trigger autocompletion in command mode (<tab> by default)
vim.o.wildcharm = vim.o.wildchar

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = ":w" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = ":q" })

vim.keymap.set("v", "p", "\"_dP", { desc = "Paste without yanking", silent = true })
vim.keymap.set("n", "<s-u>", "<cmd>redo<cr>", { desc = "Redo" })

vim.keymap.set("n", "<leader>f", "<cmd>e .<cr>", { desc = "netrw cwd" })
vim.keymap.set("n", "<leader>F", "<cmd>e %:p:h<cr>", { desc = "netrw cur buf dir" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.keymap.set("i", "<c-space>", vim.lsp.completion.get, { silent = true, desc = "Trigger autocompletion" })
vim.keymap.set("i", "<c-w>", vim.lsp.buf.hover, { silent = true, desc = "Trigger hover in insert mode" })

vim.keymap.set("n", "<c-x>", "<cmd>bprev<cr>", { desc = "Goto prev buffer" })
vim.keymap.set("n", "<c-c>", "<cmd>bnext<cr>", { desc = "Goto next buffer" })
vim.keymap.set("n", "<c-b>", "<cmd>bdelete<cr>", { desc = "Delete current buffer" })

-- wildcharm --
vim.keymap.set("n", "<leader>b", ":buffer<space><tab>", { desc = "Select buffer shorthand", silent = false })

