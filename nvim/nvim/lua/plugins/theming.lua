return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        config = function(plugin)
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
                    icons_enabled = true,
                    theme = 'nightfly',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                }
            }
        end,
    },
}
