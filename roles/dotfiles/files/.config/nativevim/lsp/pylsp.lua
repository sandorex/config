-- does not make sense to run clangd in a container

-- this is a fork of pyls
-- https://github.com/python-lsp/python-lsp-server

---@type vim.lsp.Config
return {
    cmd = { "pylsp" },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git',
    },
    filetypes = { "python" },
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { 'utf-8', 'utf-16' },
    },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    -- TODO port of from old config
                    -- ignore = { "W391" },
                },
            },
        },
    },
}

