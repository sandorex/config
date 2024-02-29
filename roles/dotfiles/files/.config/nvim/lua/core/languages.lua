-- file contains overrides and things for specific languages

-- allow comments in JSON
vim.cmd([[autocmd FileType json syntax match Comment +\/\/.\+$+]])
