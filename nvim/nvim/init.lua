local options = {
    encoding = 'utf-8',

    -- indent options
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,
    expandtab = true,

    showmode = false,

    cursorline = true,
    --cursorlineopt = 'number',

    undofile = true, -- undo history persistance between sessions (nvim defaults are ok)
    backup = false,
    writebackup = false,

    -- scrolls when cursor gets too close to bounds of the screen
    scrolloff = 8,
    sidescrolloff = 8,

    number = true,

    updatetime = 300,

    -- guide lines, TODO
    --colorcolumn = '80,100',
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- TODO: exapnd this further
vim.opt.wildignore:append('*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx')

-- make cursor go over to the next line when it hits the end like
-- literally every other editor ever?
vim.opt.whichwrap:append('<,>,h,l,[,]')

-- TODO: add recognizible character when line does not fit

-- separate vim plugins just in case
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

-- allow comments in JSON
vim.cmd([[autocmd FileType json syntax match Comment +\/\/.\+$+]])

-- remove trailing whitespaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

require('core.theming')
require('core.statusline')
require('core.keybindings')
require('core.plugins')

-- load machine specific file 'lua/host_<host>.lua'
local cfg = vim.fn.stdpath('config')
local custom_lua_file = 'host_' .. vim.fn.hostname():lower()
if vim.fn.glob(cfg .. '/lua/' .. custom_lua_file .. '.lua') ~= '' then
    vim.g.custom_file_loaded = true
    require(custom_lua_file)
end

