local M = {}

local function check_exe(exe, warn_msg, advice)
    if vim.fn.executable(exe) == 1 then
        vim.health.report_ok(exe .. ' found')
    else
        vim.health.report_warn(exe .. ' not found, ' .. warn_msg, advice)
    end
end

M.check = function()
    vim.health.report_start('Dummy report')
    vim.health.report_ok('Dummy report')

    vim.health.report_start('External Dependencies')
    check_exe('bat', 'fzf syntax highlighting wont work', 'Install it using homebrew or your package manager')
    check_exe('npm', 'required for mason')
    check_exe('cargo', 'required for mason')

    --if vim.fn.executable('bat') == 1 then
    --    vim.health.report_ok('Bat is available')
    --else
    --    vim.health.report_error('Bat is not available')
    --end
end

return M
