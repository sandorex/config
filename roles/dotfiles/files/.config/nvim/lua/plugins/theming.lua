return {
    {
        'EdenEast/nightfox.nvim',
        enabled = false,
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
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.g.colorscheme_dark = 'catppuccin-macchiato'
            vim.g.colorscheme_light = 'catppuccin-latte'
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
                            function() return vim.env.PROMPT_ICON or '?' end,
                            color = { fg = 'white', bg = vim.env.PROMPT_ICON_COLOR_HEX or '#FFFFFF' },
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
