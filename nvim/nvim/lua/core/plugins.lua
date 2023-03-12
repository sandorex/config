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
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
            require('which-key').setup {}
        end
    }

    use {
        'williamboman/mason-lspconfig.nvim',
        requires = {
            { 'williamboman/mason.nvim' },
            { 'neovim/nvim-lspconfig' },
        },
        cond = "vim.fn.has('nvim-0.7') == 1",
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'denols',
                }
            })

            local cfg = require('lspconfig')
            cfg.lua_ls.setup {}
            cfg.denols.setup {}
        end
    }

    -- apply the config if packer was just installed
    if packer_bootstrap then
        require('packer').sync()
    end
end)

