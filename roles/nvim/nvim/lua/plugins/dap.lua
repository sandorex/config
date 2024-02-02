-- nvim-dap

-- TODO add https://github.com/rcarriga/cmp-dap for autocompletion in debugging REPL

return {
    {
        'mfussenegger/nvim-dap',
        enabled = false,
        lazy = false,
        dependencies = {
            'theHamsta/nvim-dap-virtual-text',
            'rcarriga/nvim-dap-ui',

            -- for neovim lua debugging
            -- 'jbyuki/one-small-step-for-vimkind',
        },
        config = function()
            require('nvim-dap-virtual-text').setup()
            require('dapui').setup()
        end,
    }
}
