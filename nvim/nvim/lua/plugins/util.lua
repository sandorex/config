return {
    {
        'stevearc/resession.nvim',
        config = function(plugin)
            local resession = require('resession')
            resession.setup({
                buf_filter = function(bufnr)
                    if not resession.default_buf_filter(bufnr) then
                        return false
                    end

                    if vim.fn.expand('#' .. bufnr .. ':t') == 'COMMIT_EDITMSG' then
                        return false
                    end

                    return true
                end
            })

            vim.keymap.set('n', '<space>ss', resession.save, { desc = 'Session Save' })
            vim.keymap.set('n', '<space>sl', resession.load, { desc = 'Session Load' })
            vim.keymap.set('n', '<space>sd', resession.delete, { desc ='Session Delete' })

            -- TODO do not load session if it already loaded and running
            vim.api.nvim_create_autocmd('VimEnter', {
                callback = function()
                    if vim.fn.argc(-1) == 0 then
                        local session_name = vim.fn.getcwd()
                        local session_dir = 'dirsession'

                        -- delete the session after loading so its not started twice
                        local function on_load()
                            resession.delete(session_name, { dir = session_dir })

                            resession.remove_hook('post_load', on_load)
                        end

                        resession.add_hook('post_load', on_load)
                        resession.load(session_name, { dir = session_dir, silence_errors = true })
                    end
                end
            })

            vim.api.nvim_create_autocmd('VimLeavePre', {
                callback = function()
                    resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
                end
            })
        end
    },

    { 'numToStr/Comment.nvim', config = true },
    { "lukas-reineke/indent-blankline.nvim" },

    -- smart indent
    'tpope/vim-sleuth',

    {
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
}

