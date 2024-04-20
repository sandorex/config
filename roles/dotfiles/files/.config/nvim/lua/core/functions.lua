-- contains functions used in the config

local M = {}

M.mason_packages = {
    'clangd',
    'cmake-language-server',
    'lua-language-server',
    'python-lsp-server',
    'jedi-language-server',
    'rust-analyzer', -- NOTE requires rust source to be installed
    'html-lsp',
    'typescript-language-server',
    'shellcheck',
}

--- neobrew packages to install in bootstrap
M.neobrew_packages = {}

--- installs lazy.nvim if missing and downloads LSPs and tools using mason and homebrew
function M.bootstrap()
    -- install lazy plugin manager
    require('core.lazy').install_lazy()

    if not pcall(require, 'lazy') then
        print("Lazy.nvim was just installed please restart neovim and rerun :Bootstrap")
        return
    end

    -- run only if plugin is enabled
    if pcall(require, 'neobrew') then
        vim.cmd('HomebrewSetup') -- initial setup of homebrew

        for _, i in ipairs(M.neobrew_packages) do
            vim.cmd('HomebrewInstall ' .. i)
        end
    end

    for _, i in ipairs(M.mason_packages) do
        vim.cmd('MasonInstall ' .. i)
    end
end
vim.api.nvim_create_user_command("Bootstrap", M.bootstrap, {})

--- Sets theme variant or toggles it if its nil
---@param variant string? can be 'dark', 'light' or nil
function M.set_theme_variant(variant)
    -- TODO Sometime in future use OSC 11 ANSI, cannot get it to work currently
    -- toggle if nil
    if variant == nil then
        -- turn darkness into light and vice versa
        if vim.g.colors_name == vim.g.colorscheme_light then
            variant = 'dark'
        elseif vim.g.colors_name == vim.g.colorscheme_dark then
            variant = 'light'
        else
            -- default to dark if unknown colorscheme was applied
            variant = 'dark'
        end
    end

    -- if you set the same colorscheme twice it flickers
    if variant == 'light' then
        if vim.g.colors_name ~= vim.g.colorscheme_light then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_light)
        end
    else -- default to dark mode
        if vim.g.colors_name ~= vim.g.colorscheme_dark then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_dark)
        end
    end
end

---Opens file as a note but only once, if it is already open it is focused
---@param file string? path to the file
function M.open_notes(file)
    -- default to global notes
    if file == nil then
        file = vim.fn.stdpath('data') .. '/global_notes.md'
    end

    -- find buffers with same file open
    local note_bufs = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_loaded(buf)
            and vim.b[buf].is_notes == true
            and vim.api.nvim_buf_get_name(buf) == file
    end, vim.api.nvim_list_bufs())

    if #note_bufs == 0 then
        -- no buffers found then open it
        vim.cmd('edit ' .. file)
        vim.b.is_notes = true
    else
        -- focus the first one
        vim.api.nvim_set_current_buf(note_bufs[1])
    end
end

return M

