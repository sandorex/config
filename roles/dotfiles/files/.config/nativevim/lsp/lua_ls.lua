local lspcontainers = require("lspcontainers")

local function lua_ls_on_init(client)
    local path = vim.tbl_get(client, "workspace_folders", 1, "name")
    if not path then
        return
    end

	-- simplest way to check if neovim config or not
	if vim.fn.filereadable(path .. "/.nvimconfig") then
		local settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file("", true),
				},
			},
		}
		-- apply the settings
		client.settings = vim.tbl_deep_extend('force', client.settings, settings)
	end
end

---@type vim.lsp.Config
local config = {
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    filetypes = { "lua" },
    on_init = lua_ls_on_init,
    settings = {
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
  },
}

if not lspcontainers.is_available(config.cmd[1]) then
	config.cmd = lspcontainers.command({
		image = "lua-language-server",
		command = config.cmd,
		home_readonly = true,
	})
end

return config

