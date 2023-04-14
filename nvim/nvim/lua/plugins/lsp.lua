local plugins = {
    'lua_ls',
    'bashls',
    'denols',
    'pylsp',
    'clangd',
    'cmake',
}

-- contains configs for lsp plugins
local configs = {}

-- return empty table when cfg is not defined
setmetatable(configs, {
    __index = function(_, _)
        return {}
    end
})

-- CONFIGS --
configs.mason_lsp = {
    ensure_installed = plugins,
}

configs.lua_ls = {
    Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
    }
}

return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        -- event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- adds neovim api completion
            'folke/neodev.nvim',

            -- autocompletion and snippets
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function(_)
            -- has to be loaded before lspconfig
            require('neodev').setup {}

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            require('mason').setup()
            local mason_lspconfig = require('mason-lspconfig')

            -- TODO clean this up and put it all in lsp.lua
            mason_lspconfig.setup(configs.mason_lsp)
            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        --on_attach = on_attach,
                        settings = configs[server_name],
                    }
                end,
            }

            -- autocompletion setup
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'

            luasnip.config.setup {}

            -- load snippets lazily
            require("luasnip.loaders.from_snipmate").lazy_load()
            require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/LuaSnip/"})

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                -- i am not using presets because i hate that it captures arrows keys
                mapping = cmp.mapping {
                    ['<S-Down>'] = {
                        i = cmp.mapping.select_next_item {
                            behavior = cmp.SelectBehavior.Select
                        },
                    },
                    ['<S-Up>'] = {
                        i = cmp.mapping.select_prev_item {
                            behavior = cmp.SelectBehavior.Select
                        },
                    },
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            }
        end,
    },
}
