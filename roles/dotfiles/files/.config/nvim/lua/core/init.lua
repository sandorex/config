-- separate vim plugins just in case
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set default themes (overriden when theme loads)
vim.g.colorscheme_dark = 'habamax'
vim.g.colorscheme_light = 'shine'

require('core.languages')
require('core.keybindings')
require('core.editor')
require('core.right_click_menu').apply()
require('core.netrw')
require('core.auto')
require('core.lazy')

local function get_kitty_theme_variant()
    -- works using -dark -light prefix in theme.conf link target
    local result = vim.fn.system('readlink ~/.config/kitty/theme.conf')
    if vim.v.shell_error == 0 then
        local filename = vim.fn.fnamemodify(result, ':t')
        -- this is very fragile but i dont want to do regex here
        if string.find(filename, '-light') then
            return 'light'
        else
            return 'dark'
        end
    end

    return nil
end

function SetTheme(variant)
    -- if variant is not explicitly set
    if variant == nil then
        -- TODO Sometime in future replace this with OSC 11 escape, cannot get it to work currently
        -- if running in kitty just try to get the theme its using
        if vim.env.KITTY_PID ~= nil then
            variant = get_kitty_theme_variant()
        end

        -- fallback to time based theme switching
        if variant == nil then
            local hour = tonumber(os.date('%H'))

            -- set dark theme from 18 00 to 05 59
            if hour < 6 or hour >= 18 then
                variant = 'dark'
            else
                variant = 'light'
            end
        end
    end

    -- NOTE if you set colorscheme twice it flickers
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

-- set theme every focus gain
vim.api.nvim_create_autocmd({ 'VimResume' }, {
    callback = function()
        -- without this delay the theme is not set properly
        vim.fn.timer_start(100, function()
            SetTheme()
        end)
    end,
})

-- set the theme initially
SetTheme()

