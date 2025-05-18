-- general options
vim.o.completeopt = "menu,menuone,noinsert,popup,fuzzy" -- modern completion menu

vim.o.foldenable = true   -- enable fold
vim.o.foldlevel = 99      -- start editing with all folds opened
vim.o.foldmethod = "expr" -- use tree-sitter for folding method
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.o.termguicolors = true  -- enable rgb colors

vim.o.cursorline = true     -- enable cursor line

vim.o.number = true         -- enable line number
vim.o.relativenumber = true -- and relative line number

vim.o.signcolumn = "yes"    -- always show sign column

vim.o.pumheight = 10        -- max height of completion menu

vim.o.list = true           -- use special characters to represent things like tabs or trailing spaces
vim.opt.listchars = {       -- NOTE: using `vim.opt` instead of `vim.o` to pass rich object
    tab = "> ",
    trail = "·",
    extends = "»",
    precedes = "«",
}

vim.opt.diffopt:append("linematch:60") -- second stage diff to align lines

vim.o.confirm = true     -- show dialog for unsaved file(s) before quit
vim.o.updatetime = 200   -- save swap file with 200ms debouncing

vim.o.ignorecase = true  -- case-insensitive search
vim.o.smartcase = true   -- , until search pattern contains upper case characters

vim.o.smartindent = true -- auto-indenting when starting a new line
vim.o.shiftround = true  -- round indent to multiple of 'shiftwidth'
vim.o.shiftwidth = 0     -- 0 to follow the 'tabstop' value
vim.o.tabstop = 4        -- tab width
vim.o.expandtab = true   -- use spaces instead of tabs

vim.o.undofile = true    -- enable persistent undo
vim.o.undolevels = 10000 -- 10x more undo levels

-- define <leader> and <localleader> keys
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")

-- remove netrw banner for cleaner looking
vim.g.netrw_banner = 0

-- smart filtering for directories
vim.opt.wildignore:append {
    "*.pyc",
    "node_modules",
}
vim.opt.path:append {
    "src/**",
    "config/",
    "cmake/",
}

