local M = {}

local function check_exe(exe, warn_msg, advice)
    if vim.fn.executable(exe) == 1 then
        vim.health.report_ok(exe .. ' found')
    else
        vim.health.report_warn(exe .. ' not found, ' .. warn_msg, advice)
    end
end

M.check = function()
    vim.health.report_start('External Dependencies (Recommended)')
    check_exe('npm', 'required for mason')
    check_exe('cargo', 'required for mason')

    check_exe(
        'bat',
        'provides syntax highlighting in fzf',
        'Install it using package manager or homebrew, https://github.com/sharkdp/bat#installation'
    )

    check_exe(
        'shellcheck',
        'improves bash-language-server',
        'Install it using your package manager or homebrew, https://github.com/koalaman/shellcheck#installing'
    )
end

return M
