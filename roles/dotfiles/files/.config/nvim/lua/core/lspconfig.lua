-- lsp server configuration
-- NOTE use lspconfig naming!
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md

local M = {}

-- contains M.configs for lsp plugins
M.configs = {}

-- return empty table when cfg is not defined
setmetatable(M.configs, {
    __index = function(_, _)
        return {}
    end
})

M.mason_lsp = {}

M.configs.lua_ls = {
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                -- checkThirdParty = false
            },
            -- disable telemetry
            telemetry = {
                enable = false
            },
        },
    }
}

M.configs.pylsp = {
    settings = {
        pylsp = {
            plugins = {
                jedi = {
                    environment = vim.fn.exepath('python3'),
                },
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

M.configs.clangd = {}
M.configs.cmake = {}
--M.configs.jedi_language_server = {} -- if needed remove pylsp first
M.configs.rust_analyzer = {}
M.configs.html = {}
M.configs.tsserver = {}
M.configs.bashls = {}

return M

