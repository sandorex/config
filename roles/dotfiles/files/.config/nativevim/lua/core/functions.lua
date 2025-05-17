-- all user functions

vim.api.nvim_create_user_command("LspLog", function()
	local log_file = require('vim.lsp.log').get_filename()
	vim.cmd(":edit " .. log_file)
end, { desc = "Opens the LSP log file" })
