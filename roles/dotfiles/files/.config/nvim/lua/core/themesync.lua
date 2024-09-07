-- plugin for colorscheme variant switching or auto based on terminal background

local M = {}

-- prevent nvim from setting it and messing things up
vim.o.background = 'dark'

function M.set_colorscheme(variant)
    -- if i dont set vim.o.background then text becomes unreadable
    if variant == 'light' then
        vim.cmd('silent! colorscheme ' .. vim.g.colorscheme_light)
        vim.o.background = 'light'
    else
        vim.cmd('silent! colorscheme ' .. vim.g.colorscheme_dark)
        vim.o.background = 'dark'
    end
end

---Uses OSC11 to query terminal for background color and sets vim.o.background
function M.set_colorscheme_auto()
    -- TermResponse is available in nvim 0.10+
    if vim.fn.has('nvim-0.10') ~= 1 then
        set_colorscheme('dark')
        return
    end

    vim.api.nvim_create_autocmd('TermResponse', {
        once = true,
        callback = function(args)
            -- it replies with weird 16bit colors...
            -- ^[]11;rgb:2424/2727/3a3a
            local resp = args.data
            local r_raw, g_raw, b_raw = resp:match("\027%]11;rgb:(%w+)/(%w+)/(%w+)")
            local color = tonumber(r_raw .. g_raw .. b_raw, 16)

            -- rougly half between light and dark
            if color < 0x888888888888 then
                vim.schedule(function() M.set_colorscheme('dark') end)
            else
                vim.schedule(function() M.set_colorscheme('light') end)
            end
        end,
    })
    io.stdout:write("\027]11;?\027\\")
end

M.au_group_name = 'themesync-auto'

---@param variant string? can be 'dark', 'light', 'toggle', 'auto'
function M.set_theme_variant(variant)
    if variant == 'toggle' then
        -- prevent errors if augroup does not exist
        pcall(vim.api.nvim_del_augroup_by_name, M.au_group_name)

        if vim.g.colors_name == vim.g.colorscheme_dark then
            M.set_colorscheme('light')
        else
            M.set_colorscheme('dark')
        end
    elseif variant == 'auto' then
        M.set_colorscheme_auto()

        local group_id = vim.api.nvim_create_augroup(M.au_group_name, {
            clear = true
        })

        -- check for theme changes on resume and refocus
        vim.api.nvim_create_autocmd({ 'VimResume', 'FocusGained' }, {
            callback = M.set_colorscheme_auto,
            group = group_id,
        })
    else
        -- prevent errors if augroup does not exist
        pcall(vim.api.nvim_del_augroup_by_name, M.au_group_name)

        M.set_colorscheme(variant)
    end
end

vim.api.nvim_create_user_command("SetVariant", function(opts)
    if opts.args == '' or opts.args == nil then
        M.set_theme_variant('auto')
    else
        M.set_theme_variant(opts.args)
    end
end, {
    nargs = '?',
    complete = function(args)
        return { 'light', 'dark', 'auto', 'toggle' }
    end,
    desc = 'Set colorscheme variant',
})

-- use auto by default
M.set_theme_variant('auto')

return M

