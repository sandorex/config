-- editor related plugins

return {
    -- adds indent guide lines
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    -- easily (un)comment lines of code
    { 'numToStr/Comment.nvim', config = true },

    -- smart indent
    'tpope/vim-sleuth',

    -- smart parentheses
    {
        'tpope/vim-surround',
        config = function()
            vim.keymap.set('n', '{', 'ysiw', { remap = true, silent = true, desc = 'Surround' })
        end
    },

    -- add git status signs
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                -- map({ 'n', 'v' }, ']c', function()
                --     if vim.wo.diff then
                --         return ']c'
                --     end
                --     vim.schedule(function()
                --         gs.next_hunk()
                --     end)
                --     return '<Ignore>'
                -- end, { expr = true, desc = 'Jump to next hunk' })
                --
                -- map({ 'n', 'v' }, '[c', function()
                --     if vim.wo.diff then
                --         return '[c'
                --     end
                --     vim.schedule(function()
                --         gs.prev_hunk()
                --     end)
                --     return '<Ignore>'
                -- end, { expr = true, desc = 'Jump to previous hunk' })

                -- Actions
                -- visual mode
                -- map('v', '<leader>hs', function()
                --     gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                -- end, { desc = 'Stage git hunk' })
                -- map('v', '<leader>hr', function()
                --     gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                -- end, { desc = 'Reset git hunk' })
                -- normal mode
                -- map('n', '<leader>vs', gs.stage_hunk, { desc = 'Git stage hunk' })
                -- map('n', '<leader>vr', gs.reset_hunk, { desc = 'Git reset hunk' })
                -- map('n', '<leader>vS', gs.stage_buffer, { desc = 'Git stage buffer' })
                -- map('n', '<leader>vu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
                -- map('n', '<leader>vR', gs.reset_buffer, { desc = 'Git reset buffer' })
                map('n', '<leader>vb', function()
                    gs.blame_line { full = false }
                end, { desc = 'git blame line' })
                -- TODO idk how to exit these
                -- map('n', '<leader>vd', gs.diffthis, { desc = 'git diff against index' })
                -- map('n', '<leader>vD', function()
                --     gs.diffthis '~'
                -- end, { desc = 'git diff against last commit' })

                -- Toggles
                map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })
            end,
        },
    },

    -- SYNTAX PLUGINS --

    -- add justfile syntax
    'NoahTheDuke/vim-just',
}
