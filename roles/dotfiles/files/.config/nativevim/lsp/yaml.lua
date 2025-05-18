local lspcontainers = require("lspcontainers")

---@type vim.lsp.Config
local config = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
    root_markers = { ".git" },
    settings = {
        -- disable telemetry
        redhat = { telemetry = { enabled = false } },
    }
}

-- if cmd is not found in PATH then use container
if not lspcontainers.is_available(config.cmd[1]) then
	config.cmd = lspcontainers.command({
		image = "yaml-language-server",
		command = config.cmd,
		home_readonly = true,
	})
end

return config

