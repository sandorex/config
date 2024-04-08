-- contains functions used in the config

local M = {}

M.mason_packages = {
    'clangd',
    'cmake-language-server',
    'lua-language-server',
    'python-lsp-server',
    'rust-analyzer', -- NOTE requires rust source to be installed
    'html-lsp',
    'typescript-language-server',
}

M.neobrew_packages = {}

-- this function should not be called twice
function M.bootstrap()
    -- run only if plugin is enabled
    if pcall(require, 'neobrew') then
        vim.cmd('HomebrewSetup') -- initial setup of homebrew

        for _, i in ipairs(M.neobrew_packages) do
            vim.cmd('HomebrewInstall ' .. i)
        end
    end

    for _, i in ipairs(M.mason_packages) do
        vim.cmd('MasonInstall ' .. i)
    end
end
vim.api.nvim_create_user_command("Bootstrap", M.bootstrap, { desc = 'Run bootstrap process to setup LSPs and other things' })
-- TODO define user command using bootstrap

-- update all packages (excluding lazy.nvim plugins)
function M.update_all()
    -- run only if plugin is enabled
    if pcall(require, 'neobrew') then
        vim.cmd('HomebrewUpdate')
    end

    vim.cmd('MasonUpdate')
end
vim.api.nvim_create_user_command("UpdateAll", M.update_all, { desc = 'Update all packages (excluding lazy.nvim)' })

function M.set_theme_variant(variant)
    -- TODO Sometime in future use OSC 11 ANSI, cannot get it to work currently
    -- toggle by default
    if variant == nil then
        if vim.g.colors_name == vim.g.colorscheme_light then
            variant = 'dark'
        elseif vim.g.colors_name == vim.g.colorscheme_dark then
            variant = 'light'
        else
            variant = 'dark'
        end
    end

    -- NOTE if you set the same colorscheme again it flickers
    if variant == 'light' then
        if vim.g.colors_name ~= vim.g.colorscheme_light then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_light)
        end
    else -- default to dark mode if invalid variant is passed
        if vim.g.colors_name ~= vim.g.colorscheme_dark then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_dark)
        end
    end
end
vim.api.nvim_create_user_command("ThemeVariant", function() M.set_theme_variant() end, { desc = 'Toggle theme variant (dark/light)' })

return M

