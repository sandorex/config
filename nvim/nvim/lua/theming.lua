--- THEMING ---

if vim.fn.has("nvim-0.8") == 1 then
    -- carbonfox is not supported on older versions sadly
    vim.cmd("colorscheme carbonfox")
else
    vim.cmd("colorscheme slate")
    vim.cmd("hi CursorLine cterm=NONE ctermbg=NONE")
    vim.cmd("hi CursorLineNr cterm=REVERSE ctermbg=NONE")
end

