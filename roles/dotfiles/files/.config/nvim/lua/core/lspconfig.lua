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

