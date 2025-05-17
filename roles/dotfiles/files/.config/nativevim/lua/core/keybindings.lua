-- all keybindings should be here

-- leader --
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, desc = ":w" })
vim.keymap.set("n", "<leader>q", ":q<cr>", { silent = true, desc = ":q" })

vim.keymap.set("n", "<leader>f", ":e .<cr>", { silent = true, desc = "netrw cwd" })
vim.keymap.set("n", "<leader>F", ":e %:p:h<cr>", { silent = true, desc = "netrw cur buf dir" })

-- non-leader --
vim.keymap.set("i", "<c-space>", vim.lsp.completion.get, { silent = true, desc = "Trigger autocompletion" })
vim.keymap.set("i", "<c-w>", vim.lsp.buf.hover, { silent = true, desc = "Trigger hover in insert mode" })

-- switch buffers easily
vim.keymap.set("n", "<c-x>", ":bprev<cr>", { silent = true, desc = "Goto prev buffer" })
vim.keymap.set("n", "<c-c>", ":bnext<cr>", { silent = true, desc = "Goto next buffer" })

-- delete buffers easily
vim.keymap.set("n", "<c-b>", ":bdelete<cr>", { silent = true, desc = "Delete current buffer" })

