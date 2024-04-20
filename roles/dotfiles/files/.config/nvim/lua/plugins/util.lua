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
            local actions = require('telescope.actions')

            require('telescope').setup {
                defaults = {
                    preview = {
                        filesize_limit = 0.1, -- MB
                    },
                },
                pickers = {
                    buffers = {
                        mappings = {
                            i = {
                                -- delete buffers using ALT + d
                                ["<M-d>"] = actions.delete_buffer,
                            }
                        },
                        path_display = telescope_formatter,
                        sort_lastused = true,
                        -- ignore_current_buffer = true,
                    }
                }
            }

            local telescope_fn = require('telescope.builtin')
            vim.keymap.set('n', '<leader>b', telescope_fn.buffers, { desc = 'Pick buffer using telescope', silent = true })
        end,
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

