local m = {}

-- these plugins are installed automatically
m.plugins_auto = {
    'lua_ls',
    'bashls',
}

-- these plugins are installed when Mason is called
m.plugins = {
    'denols',
    'pylsp',
    table.unpack(m.plugins_auto),
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
    ensure_installed = m.plugins_auto,
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

