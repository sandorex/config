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
                        -- TODO does not work same as fzf
                        --sort_lastused = true,
                        sort_mru = true,
                        -- ignore_current_buffer = true,
                    }
                }
            }

            local builtins = require('telescope.builtin')
            vim.keymap.set('n', '<leader>b', builtins.buffers, { desc = 'Pick buffer using telescope', silent = true })
            vim.keymap.set('n', '<leader>F', builtins.git_files, { desc = 'Pick file (respects git)', silent = true })
        end,
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

    -- replacement for which-key
    {
        'echasnovski/mini.clue',
        version = false,
        config = function()
            local miniclue = require('mini.clue')
            miniclue.setup({
                triggers = {
                    -- Leader triggers
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },

                    -- Built-in completion
                    { mode = 'i', keys = '<C-x>' },

                    -- `g` key
                    { mode = 'n', keys = 'g' },
                    { mode = 'x', keys = 'g' },

                    -- Marks
                    { mode = 'n', keys = "'" },
                    { mode = 'n', keys = '`' },
                    { mode = 'x', keys = "'" },
                    { mode = 'x', keys = '`' },

                    -- Registers
                    { mode = 'n', keys = '"' },
                    { mode = 'x', keys = '"' },
                    { mode = 'i', keys = '<C-r>' },
                    { mode = 'c', keys = '<C-r>' },

                    -- Window commands
                    { mode = 'n', keys = '<C-w>' },

                    -- `z` key
                    { mode = 'n', keys = 'z' },
                    { mode = 'x', keys = 'z' },
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                },

                window = {
                    -- 1s is too long
                    delay = 500,

                    config = {
                        -- make it fit content
                        width = 'auto',
                    }
                },
            })
        end,
    },
}

