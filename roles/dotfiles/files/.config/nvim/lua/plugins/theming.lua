return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('nightfox').setup({
                options = {
                    styles = {
                        -- by default comments are italicized.. ugh
                        comments = "",
                    }
                }
            })

            vim.g.colorscheme_dark = 'carbonfox'
            vim.g.colorscheme_light = 'dawnfox'
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
                },
                sections = {
                    lualine_a = {
                        {
                            -- this is defined in distro-icon.sh in dotfiles
                            'vim.env.PROMPT_ICON',
                            color = { fg = 'white', bg = vim.env.PROMPT_ICON_COLOR_HEX },
                            cond = function()
                                -- check if defined
                                return vim.env.PROMPT_ICON ~= nil
                            end,
                        },
                        'mode',
                    },
                },
            }
        end,
    },
}
