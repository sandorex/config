-- lazy.vim configuration for lsp, for server configs go to core.lsp_configs

return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- adds neovim api completion
            'folke/neodev.nvim',

            -- adds status for LSP
            { 'j-hui/fidget.nvim', opts = {} },

            -- autocompletion and snippets
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            -- has to be loaded before lspconfig
            require('neodev').setup {}

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            require('mason').setup()
            local mason_lspconfig = require('mason-lspconfig')

            -- load configs from separate file
            local configs = require('core.lspconfig');

            -- used on all servers
            local default_server_config = {
                capabilities = capabilities,
                -- on_attach = on_attach,
            }

            -- autoconfigure servers
            mason_lspconfig.setup(configs.configs.mason_lsp)
            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup(vim.tbl_extend('force', default_server_config, configs.configs[server_name]))
                end,
            }

            -- autocompletion setup
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'

            luasnip.config.setup {}

            -- load snippets lazily
            require("luasnip.loaders.from_snipmate").lazy_load()
            require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" }) -- TODO get current lua path so it APP_NAME can be used

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                -- i changed many things so it does not automatically focus
                mapping = cmp.mapping {
                    ['<C-k>'] = {
                        i = cmp.mapping.select_prev_item {
                            behavior = cmp.SelectBehavior.Select
                        },
                    },
                    ['<C-j>'] = {
                        i = cmp.mapping.select_next_item {
                            behavior = cmp.SelectBehavior.Select
                        },
                    },
                    ['<S-j>'] = cmp.mapping.scroll_docs(-4),
                    ['<S-k>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                    -- the suggestions keep annoying me when i want to indent
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
        end,
    },

    -- add git status signs
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                -- map({ 'n', 'v' }, ']c', function()
                --     if vim.wo.diff then
                --         return ']c'
                --     end
                --     vim.schedule(function()
                --         gs.next_hunk()
                --     end)
                --     return '<Ignore>'
                -- end, { expr = true, desc = 'Jump to next hunk' })
                --
                -- map({ 'n', 'v' }, '[c', function()
                --     if vim.wo.diff then
                --         return '[c'
                --     end
                --     vim.schedule(function()
                --         gs.prev_hunk()
                --     end)
                --     return '<Ignore>'
                -- end, { expr = true, desc = 'Jump to previous hunk' })

                -- Actions
                -- visual mode
                -- map('v', '<leader>hs', function()
                --     gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                -- end, { desc = 'Stage git hunk' })
                -- map('v', '<leader>hr', function()
                --     gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                -- end, { desc = 'Reset git hunk' })
                -- normal mode
                -- map('n', '<leader>vs', gs.stage_hunk, { desc = 'Git stage hunk' })
                -- map('n', '<leader>vr', gs.reset_hunk, { desc = 'Git reset hunk' })
                -- map('n', '<leader>vS', gs.stage_buffer, { desc = 'Git stage buffer' })
                -- map('n', '<leader>vu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
                -- map('n', '<leader>vR', gs.reset_buffer, { desc = 'Git reset buffer' })
                map('n', '<leader>vb', function()
                    gs.blame_line { full = false }
                end, { desc = 'git blame line' })
                -- TODO idk how to exit these
                -- map('n', '<leader>vd', gs.diffthis, { desc = 'git diff against index' })
                -- map('n', '<leader>vD', function()
                --     gs.diffthis '~'
                -- end, { desc = 'git diff against last commit' })

                -- Toggles
                map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })
            end,
        },
    },

    -- adds indent guide lines
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    'NoahTheDuke/vim-just',
}
