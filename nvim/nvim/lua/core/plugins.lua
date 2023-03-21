-- recompile packer when this file is edited
vim.cmd([[
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

-- automatically installs packer
local packer_bootstrap = (function()
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end

    return false
end)()

return require('packer').startup(function(use)
    -- HAS TO BE FIRST
    use 'wbthomason/packer.nvim'

    -- TODO make select selection brighter
    -- TODO make status brighter and more visible
    use {
        'EdenEast/nightfox.nvim',
        cond = "vim.fn.has('nvim-0.8') == 1",
        config = function()
            -- intentionally setting it here so i can have a default theme when
            -- this is not available
            vim.cmd('colorscheme carbonfox')
        end
    }

    -- session management
    use {
        'stevearc/resession.nvim',
        config = function()
            local resession = require('resession')
            resession.setup({
                buf_filter = function(bufnr)
                    if not resession.default_buf_filter(bufnr) then
                        return false
                    end

                    if vim.fn.expand('#' .. bufnr .. ':t') == 'COMMIT_EDITMSG' then
                        return false
                    end

                    return true
                end
            })

            vim.keymap.set('n', '<space>ss', resession.save, { desc = 'Session Save' })
            vim.keymap.set('n', '<space>sl', resession.load, { desc = 'Session Load' })
            vim.keymap.set('n', '<space>sd', resession.delete, { desc ='Session Delete' })

            -- TODO do not load session if it already loaded and running
            vim.api.nvim_create_autocmd('VimEnter', {
                callback = function()
                    if vim.fn.argc(-1) == 0 then
                        resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
                    end
                end
            })

            vim.api.nvim_create_autocmd('VimLeavePre', {
                callback = function()
                    resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
                end
            })
        end
    }

    use {
        'junegunn/fzf.vim',
        requires = { 'junegunn/fzf', run = ':call fzf#install()' },
        config = function()
            vim.keymap.set('n', '<space>b', '<cmd>Buffers<cr>', { desc = 'Select buffer fzf', silent = true })
            vim.keymap.set('n', '<space>f', '<cmd>Files %:p:h<cr>', { desc = 'Open fzf in current file dir', silent = true })
        end
    }

    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {}

            vim.keymap.set('n', '<space><space>', '<cmd>WhichKey<cr>')
        end
    }

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- sets tab stuff from the file itself
    use { 'tpope/vim-sleuth', cond = "vim.fn.has('nvim-0.7') == 1" }
    use { 'nvim-tree/nvim-web-devicons', cond = "vim.fn.has('nvim-0.7') == 1" }

    use {
        'neovim/nvim-lspconfig',
        requires = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- adds status update for LSP
            { 'j-hui/fidget.nvim' },

            -- adds neovim api completion
            { 'folke/neodev.nvim' },

            -- autocompletion and snippets
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp'},
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip'}
        },
        cond = "vim.fn.has('nvim-0.7') == 1",
        config = function()
            local core = require('core.lsp')

            -- it makes the screen flicker more and is annoying at least with lua_ls
            -- TODO enable it for other language servers
            --require('fidget').setup {}

            -- has to be loaded before lspconfig
            require('neodev').setup {}

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            require('mason').setup()
            local mason_lspconfig = require('mason-lspconfig')

            -- TODO clean this up and put it all in lsp.lua
            mason_lspconfig.setup(core.mason_lsp_options)
            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        --on_attach = on_attach,
                        settings = core.cfg[server_name],
                    }
                end,
            }

            -- autocompletion setup
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'

            luasnip.config.setup {}

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
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
        end
    }

    -- apply the config if packer was just installed
    if packer_bootstrap then
        require('packer').sync()
    end
end)

