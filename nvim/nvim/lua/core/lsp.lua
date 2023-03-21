local m = {}

-- these plugins are installed automatically
m.plugins = {
    'lua_ls',
    'bashls',
    'denols',
    'pylsp',
}

-- contains configs for lsp plugins
m.cfg = {}

-- return empty table when cfg is not defined
setmetatable(m.cfg, {
    __index = function(_, _)
        return {}
    end
})

m.mason_lsp_options = {
    ensure_installed = m.plugins,
}

function m.setup()
    local lsp = require('lspconfig')

    -- setup all of the plugins
    for i = 1, #m.plugins do
        lsp[m.plugins[i]].setup(m.cfg[m.plugins[i]])
    end
end

-- CONFIGS --
m.cfg.lua_ls = {
    Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
    }
}

return m

