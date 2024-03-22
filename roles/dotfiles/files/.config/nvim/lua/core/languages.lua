-- file contains overrides and things for specific languages

-- allow comments in JSON
vim.cmd([[autocmd FileType json syntax match Comment +\/\/.\+$+]])

-- automatically compile latex if possible
if vim.fn.executable('latexmk') == 1 then
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = {'*.tex'},
        callback = function()
            vim.schedule(function()
                vim.fn.jobstart(
                    'latexmk -output-format=pdf'
                )
            end)
        end,
    })
end

