-- lsp server configuration

local lspconfig = require('lspconfig')

local M = {}

-- contains M.configs for lsp plugins
M.configs = {}

-- return empty table when cfg is not defined
setmetatable(M.configs, {
    __index = function(_, _)
        return {}
    end
})

-- TODO remind the user somehow:
-- these have to be installed manually in :Mason:
-- shellcheck
M.configs.mason_lsp = {
    ensure_installed = {
        'lua_ls',
        'bashls',
        'pylsp',
        'clangd',
        'cmake',
        'html',
        'rust_analyzer', -- NOTE remember to install rust-src or it wont work properly

        -- ts
        -- 'denols', -- its not great and clashes with tsserver
        'tsserver',
    },
}

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

-- TODO setup root_dir for tsserver too? or just stop one from loading after other deno then tsserver

M.configs.denols = {
    root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc', 'import_map.json'),
    single_file_support = false,
}

return M
