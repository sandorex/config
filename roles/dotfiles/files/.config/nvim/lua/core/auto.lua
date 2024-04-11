-- contains events and things that run automatically

-- remove trailing whitespaces
vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('whitespace-remover', {}),
    pattern = { '*' },
    command = [[%s/\s\+$//e]],
})
