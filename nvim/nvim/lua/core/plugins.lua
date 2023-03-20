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

    -- theming
    -- TODO make select selection brighter
    -- TODO make status brighter and more visible
    use {
        'EdenEast/nightfox.nvim',
        cond = "vim.fn.has('nvim-0.8') == 1",
        config = function()
            vim.cmd('colorscheme carbonfox')
        end
    }

    use {
        'stevearc/resession.nvim',
        config = function()
            local resession = require('resession')
            resession.setup()

            vim.keymap.set('n', '<space>ss', resession.save, { desc = 'Session Save' })
            vim.keymap.set('n', '<space>sl', resession.load, { desc = 'Session Load' })
            vim.keymap.set('n', '<space>sd', resession.delete, { desc ='Session Delete' })

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
            -- TODO: move these to the main config file so they dont change in case the plugin is missing
            vim.o.timeout = true
            vim.o.timeoutlen = 500
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

            -- adds neovim api completion
            { 'folke/neodev.nvim' },
        },
        cond = "vim.fn.has('nvim-0.7') == 1",
        config = function()
            local core = require('core.lsp')

            require('mason').setup()
            require('mason-lspconfig').setup(core.mason_lsp_options)

            -- has to be loaded before lspconfig
            require('neodev').setup {}

            core.setup()
        end
    }

    -- apply the config if packer was just installed
    if packer_bootstrap then
        require('packer').sync()
    end
end)

