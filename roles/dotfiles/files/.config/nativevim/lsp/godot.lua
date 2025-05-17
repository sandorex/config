---@type vim.lsp.Config
local config = {
    cmd = { "nc", "127.0.0.1:6005" },
    root_markers = { "project.godot", ".git" },
    filetypes = { "gdscript" },
}

return config

