-- code for theme options
-- TODO Sometime in future use OSC 11 ANSI, cannot get it to work currently
local function set_theme_variant(variant)
    -- toggle by default
    if variant == nil then
        if vim.g.colors_name == vim.g.colorscheme_light then
            variant = 'dark'
        elseif vim.g.colors_name == vim.g.colorscheme_dark then
            variant = 'light'
        else
            variant = 'dark'
        end
    end

    -- NOTE if you set the same colorscheme again it flickers
    if variant == 'light' then
        if vim.g.colors_name ~= vim.g.colorscheme_light then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_light)
        end
    else -- default to dark mode if invalid variant is passed
        if vim.g.colors_name ~= vim.g.colorscheme_dark then
            vim.cmd('colorscheme ' .. vim.g.colorscheme_dark)
        end
    end
end

-- TODO move this to keybindings
vim.keymap.set('n', '<leader>tt', function()
    set_theme_variant()
end, { desc = 'Toggle dark/light theme', silent = true })

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

