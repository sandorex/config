-- lsp server configuration

local M = {}

-- contains M.configs for lsp plugins
M.configs = {}

-- return empty table when cfg is not defined
setmetatable(M.configs, {
    __index = function(_, _)
        return {}
    end
})

M.configs.mason_lsp = {}

-- install automatically only if npm is found
if vim.fn.executable('npm') == 1 then
    M.configs.mason_lsp.ensure_installed = {
        -- SHELLHECK (has to be installed manually)
        'lua_ls',
        'bashls',
        'pylsp',
        'clangd',
        'cmake',
        'html',
        'rust_analyzer', -- NOTE remember to install rust-src or it wont work properly

        -- ts
        'tsserver',
    }
end

M.configs.lua_ls = {
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    }
}

M.configs.pylsp = {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {
                        'E302', -- expected 2 blank lines..
                        'E402', -- module import not at top..
                        'W391', -- empty line on end of file
                        'E261', -- 2 spaces before inline comment..
                        'E305', -- 2 lines after statement blah blah..
                    },
                },
            },
        },
    },
}

return M

