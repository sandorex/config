-- loads lazy.nvim package manager if installed, won't install automatically

local M = {}

M.lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

--- installs lazy.nvim if it is not installed already
function M.install_lazy()
    if not vim.loop.fs_stat(M.lazypath) then
        vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', M.lazypath })
    end
end

--- loads lazy.nvim if available
function M.load_lazy()
    -- load lazy only if installed
    local success, lazy = pcall(require, 'lazy')
    if success then
        lazy.setup('plugins', {
            change_detection = {
                -- do not notify on changes to config
                notify = false,
            },
        })
    end
end

-- load now if available
vim.opt.rtp:prepend(M.lazypath)
M.load_lazy()

return M

