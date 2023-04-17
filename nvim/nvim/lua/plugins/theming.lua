return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        config = function(plugin)
            -- intentionally setting it here so i can have a default theme when
            -- this is not available
            vim.cmd('colorscheme carbonfox')
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        lazy = false,
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'nightfly',
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '', right = '' },
                }
            }
        end,
    },
}
