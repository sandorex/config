return {
    {
        enabled = false,
        'Shatur/neovim-session-manager',
        dependencies = { 'nvim-lua/plenary.nvim' },
        init = function()
            vim.g.fuck = true
        end,
        config = function()
            require('session_manager').setup({
                -- automatically load last session in the directory
                autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir
            })

            -- automatically save session
            vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
                callback = function ()
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        -- Don't save while there's any 'nofile' buffer open.
                        if vim.api.nvim_get_option_value("buftype", { buf = buf }) == 'nofile' then
                            return
                        end
                    end
                    require('session_manager').save_current_session()
                end
            })
        end
    },

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

    {
        -- flatpak only
        enabled = os.getenv("container") == "flatpak",
        'sandorex/neobrew',
        lazy = false, -- make sure to load on startup so the PATH is adjusted
        priority = 999, -- make sure it loads before other package managers
        config = function()
            require("neobrew").init({
                ensure_installed = {
                    "bat",
                    "shellcheck",
                },
            })
        end
    },
}

