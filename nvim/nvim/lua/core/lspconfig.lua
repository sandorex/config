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

M.configs.mason_lsp = {
    ensure_installed = {
        'lua_ls',
        'bashls',
        'pylsp',
        'clangd',
        'cmake',
        'html',

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
