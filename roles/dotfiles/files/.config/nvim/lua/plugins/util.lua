local function telescope_formatter(_, path)
    local tail = vim.fs.basename(path)
    local parent = vim.fs.dirname(path)
    if parent == "." then
        return tail
    end

    return string.format("%s\t\t%s", tail, vim.fn.fnamemodify(parent, ":~:."))
end

return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {
                pickers = {
                    buffers = {
                        path_display = telescope_formatter,
                    }
                }
            }

            local telescope_fn = require('telescope.builtin')
            vim.keymap.set('n', '<leader>b', telescope_fn.buffers, { desc = 'Search buffers using telescope', silent = true })
        end,
    },

    {
        enabled = false,
        'junegunn/fzf.vim',
        dependencies = { 'junegunn/fzf' },
        keys = {
            { '<leader>b', '<cmd>Buffers<cr>', desc = 'Select buffer (fzf)', silent = true},
            -- { '<leader>f', '<cmd>Files %:p:h<cr>', desc = 'Open fzf in current file dir (fzf)', silent = true},
        },
        build = ':call fzf#install()',
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {},
    },

    {
        -- flatpak only
        enabled = os.getenv("container") == "flatpak",
        'sandorex/neobrew',
        lazy = false, -- make sure to load on startup so the PATH is adjusted
        priority = 999, -- make sure it loads before other package managers
        config = function()
            require("neobrew").init({})
        end
    },
}

