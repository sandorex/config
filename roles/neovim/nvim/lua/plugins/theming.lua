return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('nightfox').setup({
                options = {
                    -- transparent = true,
                    styles = {
                        -- by default comments are italicized.. ugh
                        comments = "",
                    }
                }
            })

            local variant = os.getenv('THEME_VARIANT'):lower() or 'dark'
            if variant == 'dark' then
                vim.cmd('colorscheme carbonfox')
            else
                vim.cmd('colorscheme dawnfox')
            end
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
                    -- theme = 'base16', -- use base16?
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                }
            }
        end,
    },
}
