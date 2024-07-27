-- lazy.vim configuration for lsp

-- this function contains all keybindings for language servers
local function on_attach(ev)
    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map('n', '<leader>lR', vim.lsp.buf.rename, 'LSP Rename')
    map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, 'LSP Code Action')
    map('n', '<leader>ld', vim.lsp.buf.definition, 'LSP Definition')
    map('n', '<leader>lr', vim.lsp.buf.references, 'LSP References')
    map('n', '<C-k>', vim.lsp.buf.hover, 'LSP Hover')
    map({'n', 'i'}, '<2-LeftMouse>', vim.lsp.buf.hover) -- i'm a heretic
    map('n', '<leader>lf', function()
        vim.lsp.buf.format { async = true }
    end, 'LSP Format')
    map('i', '<C-c>', vim.lsp.buf.completion, 'LSP Completion')
end

local function lsp_config()
    -- has to be loaded before lspconfig
    require('neodev').setup {}

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- load configs from separate file
    local configs = require('core.lspconfig');
    
    local lspconfig = require('lspconfig')

    -- setup each lsp that has cfg defined
    for lsp_name, cfg in pairs(configs.configs) do
        lspconfig[lsp_name].setup(cfg)
    end

    require('mason').setup()

    -- removed to make    
    --[[
    local mason_lspconfig = require('mason-lspconfig')

    -- load configs from separate file
    local configs = require('core.lspconfig');

    -- used on all servers
    local default_server_config = {
        capabilities = capabilities,
        on_attach = on_attach,
    }

    -- autoconfigure servers
    mason_lspconfig.setup(configs.mason_lsp)
    mason_lspconfig.setup_handlers {
        function(server_name)
            require('lspconfig')[server_name].setup(vim.tbl_extend('force', default_server_config, configs.configs[server_name]))
        end,
    }]]

    -- autocompletion setup
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    luasnip.config.setup {}

    -- load snippets lazily
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/LuaSnip/" })

    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        -- these mappings are meant to be as unintrusive as possible, cause i really hate when
        -- it focuses the popup and i cannot move around
        mapping = cmp.mapping {
            ['<C-Up>'] = {
                i = cmp.mapping.select_prev_item {
                    behavior = cmp.SelectBehavior.Select
                },
            },
            ['<C-Down>'] = {
                i = cmp.mapping.select_next_item {
                    behavior = cmp.SelectBehavior.Select
                },
            },
            -- more heresy
            ['<ScrollWheelUp>'] = {
                i = cmp.mapping.select_prev_item {
                    behavior = cmp.SelectBehavior.Select
                },
            },
            ['<ScrollWheelDown>'] = {
                i = cmp.mapping.select_next_item {
                    behavior = cmp.SelectBehavior.Select
                },
            },
            ['<C-f>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete {},
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
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

    vim.diagnostic.config({
        underline = false,
        signs = true,
        virtual_text = true,
        float = {
            show_header = true,
            source = 'always',
            border = 'rounded',
            focusable = false,
        },
    })
end

return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- adds neovim api completion
            'folke/neodev.nvim', -- TODO does not work

            -- adds status for LSP
            'j-hui/fidget.nvim',

            -- autocompletion and snippets
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = lsp_config,
    },
    {
        'j-hui/fidget.nvim',
        config = function()
            -- replace default notification with fidget
            vim.notify = require('fidget.notification').notify
        end,
    },
}

