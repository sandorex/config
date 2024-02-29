-- contains events and things that run automatically

-- remove trailing whitespaces
local group = vim.api.nvim_create_augroup('whitespace-remover', {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})
