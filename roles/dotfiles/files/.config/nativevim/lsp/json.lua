local lspcontainers = require("lspcontainers")

---@type vim.lsp.Config
local config = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
}

-- if cmd is not found in PATH then use container
if not lspcontainers.is_available(config.cmd[1]) then
	config.cmd = lspcontainers.command({
		image = "json-language-server",
		command = config.cmd,
		home_readonly = true,
	})
end

return config

