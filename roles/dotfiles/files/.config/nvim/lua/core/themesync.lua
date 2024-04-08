-- plugin for perstant colorscheme

-- reloads last set colorscheme
local function get_last_colorscheme()
    local file = io.open(vim.fn.stdpath('config') .. '/last_colorscheme.txt', 'r')
    if file == nil then
        return nil
    end

    local colorscheme = file:read("*l")
    file:close()

    return colorscheme
end

-- reloads last colorscheme if changed
local function reload_last_colorscheme()
    local last_colorscheme = get_last_colorscheme() or vim.g.colorscheme_dark

    if vim.g.colors_name ~= last_colorscheme then
        vim.cmd('colorscheme ' .. last_colorscheme)
    end
end

-- reload before adding autocmd to prevent a loop
reload_last_colorscheme()

-- automatically save the colorscheme set last
vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    callback = function(args)
        local new_colorscheme = args.match ---@type string

        local file, err = io.open(vim.fn.stdpath('config') .. '/last_colorscheme.txt', 'w')
        if file == nil then
            print('Error saving colorscheme name: ' .. err)
        else
            file:write(new_colorscheme)
            file:close()
        end
    end,
})

-- check for theme changes on resume and refocus
vim.api.nvim_create_autocmd({ 'VimResume', 'FocusGained' }, {
    callback = function()
        vim.schedule(function()
            reload_last_colorscheme()
        end)
    end,
})

