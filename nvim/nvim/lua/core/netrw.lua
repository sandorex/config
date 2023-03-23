local global_options = {
    -- keeps curdir same as the browsing dir, fixes file copying problems
    netrw_keepdir = 0,

    -- hide banner
    netrw_banner = 0,

    -- hide current dir
    netrw_list_hide = '^\\./$',

    -- hide files in netrw_list_hide by default, press 'a' to cycle
    netrw_hide = 1,

    -- recursive copy
    netrw_localcopydircmd = 'cp -r'
}

for k, v in pairs(global_options) do
    vim.g[k] = v
end

-- put netrw keybindings here
function NetrwMapping()
    -- go to next or prev directory with arrow keys
    vim.keymap.set('n', '<left>', '-', { desc = 'Go to parent', remap = true, buffer = true })
    vim.keymap.set('n', '<right>', '<cr>', { desc = 'Enter', remap = true, buffer = true })
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    callback = NetrwMapping,
})

-- TODO highlighting netrw marked files
-- hi! link netrwMarkFile Search

