-- coc plugins
vim.g.coc_global_extensions = {
    'coc-json',
    'coc-yaml',
    'coc-pyright',
    'coc-clangd',
    'coc-cmake'
}

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
    -- TODO make select highlight brighter
    use {
        'EdenEast/nightfox.nvim',
        cond = "vim.fn.has('nvim-0.8')",
        config = function()
            vim.cmd('colorscheme carbonfox')
        end
    }

    --use 'scrooloose/nerdtree'

    --use 'vim-airline/vim-airline'
    --use 'vim-airline/vim-airline-themes'

    --use 'junegunn/vim-easy-align'

    --use {'neoclide/coc.nvim', branch = 'release'}

    use { 'neovim/nvim-lspconfig', cond = "vim.fn.has('nvim-0.7')" }

    -- apply the config if packer was just installed
    if packer_bootstrap then
        require('packer').sync()
    end
end)

