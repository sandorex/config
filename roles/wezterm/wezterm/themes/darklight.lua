-- custom theme

local M = {}

M.LIGHT = 'DarkLight Dark'
M.DARK = 'DarkLight Light'

function M.apply(config)
    local light = {}
    light.background = '#EEDFD1'
    light.foreground = '#141414'

    -- TODO this is left for later
    light.cursor_bg = 'orange'
    light.cursor_fg = 'black'
    light.cursor_border = 'red'

    -- is this good enough?
    light.selection_fg = light.background
    light.selection_bg = light.foreground

    light.split = '#acb2b1'

    light.ansi = {
        '#1f2125',
        '#882424',
        '#294512',
        '#67472b',
        '#103152',
        '#58206b',
        '#1d4657',
        '#2b2c2c',
    }

    light.brights = {
        '#727a87',
        '#bb1919',
        '#2b750c',
        '#866014',
        '#155993',
        '#8916ab',
        '#0e6570',
        '#575757',
    }

    --- DARK THEME ---
    local dark = {}
    dark.background = '#080808'
    dark.foreground = '#ebebeb'

    -- TODO this is left for later
    dark.cursor_bg = 'orange'
    dark.cursor_fg = 'black'
    dark.cursor_border = 'red'

    -- is this good enough?
    dark.selection_fg = dark.background
    dark.selection_bg = dark.foreground

    dark.split = '#acb2b1'

    dark.ansi = {
        '#1f2125',
        '#b85757',
        '#8c9440',
        '#c37a46',
        '#5285B8',
        '#9670a2',
        '#6d7797',
        '#989ea3',
    }

    dark.brights = {
        '#727A87',
        '#e76666',
        '#a6b428',
        '#d9991b',
        '#367ab4',
        '#b294bb',
        '#8289b2',
        '#b7bdbc',
    }

    config.color_schemes = config.color_schemes or {}
    config.color_schemes[M.LIGHT] = light
    config.color_schemes[M.DARK] = dark
end

return M
