return {
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
            require("neobrew").init({})
        end
    },
}

