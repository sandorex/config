local M = {}

M.mason_packages = {
    'clangd',
    'cmake-language-server',
    'lua-language-server',
    'python-lsp-server',
    'jedi-language-server',
    'rust-analyzer', -- NOTE requires rust source to be installed
    'html-lsp',
    'typescript-language-server',
    'shellcheck',
}

--- Installs lazy.nvim if missing and downloads LSPs and tools using mason and homebrew
function M.bootstrap()
    print("Bootstrapping plugins and LSPs")

    -- install and load lazy plugin manager
    require('core.lazy').install_and_load()
end

function M.bootstrap_mason()
    M.bootstrap()

    print("Installing mason packages")
    for _, i in ipairs(M.mason_packages) do
        vim.cmd('MasonInstall ' .. i)
    end
end

vim.api.nvim_create_user_command("Bootstrap", M.bootstrap, {})
vim.api.nvim_create_user_command("BootstrapMason", M.bootstrap_mason, {})

return M

