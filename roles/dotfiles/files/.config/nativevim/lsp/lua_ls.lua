-- TODO 
--[[
-- if the real lsp server is not available in PATH then use a container
lspcontainers = require("lspcontainers")
if not lspcontainers.is_available("lua-language-server") then
	-- modify the original config to
	config.cmd = lspcontainers.command {
		image = 'localhost/lua_language_server',
		args = config.cmd,
		-- manager_args = { '-v', '/bah/blah:/blah' }
	}
end

---]]

local function lua_ls_on_init(client)
    local path = vim.tbl_get(client, "workspace_folders", 1, "name")
    if not path then
        return
    end

	local settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                checkThirdParty = false,
            },
			telemetry = {
				enable = false,
			},
		},
	}

	-- load neovim files only if in config as its slow
	if path:find("^" .. vim.fn.stdpath("config")) ~= nil then
		settings.Lua.workspace.library = vim.api.nvim_get_runtime_file("", true)
	end

	-- apply the settings
    client.settings = vim.tbl_deep_extend('force', client.settings, settings)
end

---@type vim.lsp.Config
local config = {
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    filetypes = { "lua" },
    on_init = lua_ls_on_init,
}

-- if cmd is not found in PATH then use container
if vim.fn.executable(config.cmd[1]) ~= 1 then
	config.cmd = {
		"podman",
		"run",
		"--security-opt=label=disable",
		"--pull=never",
		"-i",
		"--rm",

		"--network=none",

		-- TODO it will work great for in-home things but not for outside, even tmp
		-- mount home read-only
		vim.fn.expand("--volume=$HOME:$HOME:ro"),

		-- local lsp container
		"lua_language_server",

		-- the actual command
		config.cmd[1],
	}
end

return config

