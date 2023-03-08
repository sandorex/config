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

            vim.keymap.set('n', '<space>ss', resession.save)
            vim.keymap.set('n', '<space>sl', resession.load)
            vim.keymap.set('n', '<space>sd', resession.delete)

            -- save the session automatically
            vim.api.nvim_create_autocmd('VimLeavePre', {
                callback = function()
                    if os.getenv('TMUX') ~= nil then
                        local tmux_session = vim.fn.system('tmux display-message -p "#S"')
                        resession.save('tmux-' .. tmux_session)
                    else
                        resession.save('last')
                    end
                end
            })

            -- autoload tmux session if in tmux and no files or directories are opened
            vim.api.nvim_create_autocmd('VimEnter', {
                callback = function()
                    if os.getenv('TMUX') == nil then
                        return
                    end

                    local filename = vim.fn.expand('%')
                    if vim.bo.filetype == '' and (filename == '' or vim.fn.filereadable(filename) == 0) then
                        local tmux_session = vim.fn.system('tmux display-message -p "#S"')
                        resession.load('tmux-' .. tmux_session)
                        print("Loaded last tmux session")
                    end
                end
            })
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
                ensure_installed = { "lua_ls" }
            })

            require("lspconfig").lua_ls.setup {}
        end
    }

    -- apply the config if packer was just installed
    if packer_bootstrap then
        require('packer').sync()
    end
end)

