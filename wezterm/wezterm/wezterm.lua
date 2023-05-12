-- wezterm configuration

local wezterm = require('wezterm')
local act = wezterm.action

-- is the current desktop a window manager
local WM = false

-- detect a tiling window manager
-- NOTE: to add a new one just check what 'XDG_CURRENT_DESKTOP' env var is
local CUR_DE = os.getenv('XDG_CURRENT_DESKTOP')
if CUR_DE == 'qtile' then
    WM = true
end

local config = {}

-- makes nicer error messages for config errors
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.check_for_updates = true

config.color_scheme = 'carbonfox'
config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 16

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    -- firacode is named differently on windows for some reason..
    config.font = wezterm.font 'FiraCode NFM'
end

-- makes the tabbar look more like TUI
config.use_fancy_tab_bar = false;

config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true

-- makes alt act as regular alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- remove title bar in a tiling window managers
if WM then
    config.window_decorations = "RESIZE"
end

-- i plan to emulate tmux syntax so i do not need the bindings
config.disable_default_key_bindings = true

-- NOTE: this is not SHIFT + , but the key < left of Z!
-- as alternative 'RightAlt' is the next candidate
local leader = '<'

-- keybindings shameless stolen from https://github.com/wez/wezterm/discussions/2329
config.leader = { key=leader, mods="NONE", timeout_milliseconds=500 }
config.keys = {
    {key = "LeftArrow" , mods = "OPT", action = act.SendString("\x1bb")},
    {key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf")},

    -- The physical CMD key on OSX is the Alt key on Win/*nix, so map the common Alt-combo commands.
    {key = ".", mods = "CMD", action = act.SendString("\x1b.")},
    {key = "p", mods = "CMD", action = act.SendString("\x1bp")},
    {key = "n", mods = "CMD", action = act.SendString("\x1bn")},
    {key = "b", mods = "CMD", action = act.SendString("\x1bb")},
    {key = "f", mods = "CMD", action = act.SendString("\x1bf")},

    -- Window management
    -- {key = "Space", mods="LEADER", action=act{SendString=leader}},
    {key="-",  mods="LEADER", action=act{SplitVertical={domain="CurrentPaneDomain"}} },
    {key="\\", mods="LEADER", action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
    {key="z" , mods="LEADER", action="TogglePaneZoomState" },
    {key="c" , mods="LEADER", action=act{SpawnTab="CurrentPaneDomain"}},

    {key="LeftArrow", mods="LEADER", action=act.ActivatePaneDirection("Left")},
    {key="DownArrow", mods="LEADER", action=act.ActivatePaneDirection("Down")},
    {key="UpArrow", mods="LEADER", action=act.ActivatePaneDirection("Up")},
    {key="RightArrow", mods="LEADER", action=act.ActivatePaneDirection("Right")},

    {key="LeftArrow", mods="LEADER", action=act{AdjustPaneSize={"Left", 5}}},
    {key="DownArrow", mods="LEADER", action=act{AdjustPaneSize={"Down", 5}}},
    {key="UpArrow", mods="LEADER", action=act{AdjustPaneSize={"Up", 5}}},
    {key="RightArrow", mods="LEADER", action=act{AdjustPaneSize={"Right", 5}}},

    {key="`", mods="LEADER", action=act.ActivateLastTab},
    {key=" ", mods="LEADER", action=act.ActivateTabRelative(1)},
    {key="1", mods="LEADER", action=act{ActivateTab=0}},
    {key="2", mods="LEADER", action=act{ActivateTab=1}},
    {key="3", mods="LEADER", action=act{ActivateTab=2}},
    {key="4", mods="LEADER", action=act{ActivateTab=3}},
    {key="5", mods="LEADER", action=act{ActivateTab=4}},
    {key="6", mods="LEADER", action=act{ActivateTab=5}},
    {key="7", mods="LEADER", action=act{ActivateTab=6}},
    {key="8", mods="LEADER", action=act{ActivateTab=7}},
    {key="9", mods="LEADER", action=act{ActivateTab=8}},
    {key="x", mods="LEADER", action=act{CloseCurrentPane={confirm=true}}},

    -- Activate Copy Mode
    {key="[", mods="LEADER", action=act.ActivateCopyMode},
    -- Paste from Copy Mode
    {key="]", mods="LEADER", action=act.PasteFrom("PrimarySelection")},

    -- allow to map keybinings to SHIFT + ESCAPE
    { key = 'Escape', mods = 'SHIFT', action = act.SendString("\x1b[[") },

    -- show debug overlay
    { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action.ShowDebugOverlay },
}

config.key_tables = {
    copy_mode = {
        {key="c", mods="CTRL", action=act.CopyMode("Close")},
        {key="g", mods="CTRL", action=act.CopyMode("Close")},
        {key="q", mods="NONE", action=act.CopyMode("Close")},
        {key="Escape", mods="NONE", action=act.CopyMode("Close")},

        {key="h", mods="NONE", action=act.CopyMode("MoveLeft")},
        {key="j", mods="NONE", action=act.CopyMode("MoveDown")},
        {key="k", mods="NONE", action=act.CopyMode("MoveUp")},
        {key="l", mods="NONE", action=act.CopyMode("MoveRight")},

        {key="LeftArrow",  mods="NONE", action=act.CopyMode("MoveLeft")},
        {key="DownArrow",  mods="NONE", action=act.CopyMode("MoveDown")},
        {key="UpArrow",    mods="NONE", action=act.CopyMode("MoveUp")},
        {key="RightArrow", mods="NONE", action=act.CopyMode("MoveRight")},

        {key="RightArrow", mods="ALT",  action=act.CopyMode("MoveForwardWord")},
        {key="f",          mods="ALT",  action=act.CopyMode("MoveForwardWord")},
        {key="Tab",        mods="NONE", action=act.CopyMode("MoveForwardWord")},
        {key="w",          mods="NONE", action=act.CopyMode("MoveForwardWord")},

        {key="LeftArrow", mods="ALT",   action=act.CopyMode("MoveBackwardWord")},
        {key="b",         mods="ALT",   action=act.CopyMode("MoveBackwardWord")},
        {key="Tab",       mods="SHIFT", action=act.CopyMode("MoveBackwardWord")},
        {key="b",         mods="NONE",  action=act.CopyMode("MoveBackwardWord")},

        {key="0",     mods="NONE",  action=act.CopyMode("MoveToStartOfLine")},
        {key="Enter", mods="NONE",  action=act.CopyMode("MoveToStartOfNextLine")},

        {key="$",     mods="NONE",  action=act.CopyMode("MoveToEndOfLineContent")},
        {key="$",     mods="SHIFT", action=act.CopyMode("MoveToEndOfLineContent")},
        {key="^",     mods="NONE",  action=act.CopyMode("MoveToStartOfLineContent")},
        {key="^",     mods="SHIFT", action=act.CopyMode("MoveToStartOfLineContent")},
        {key="m",     mods="ALT",   action=act.CopyMode("MoveToStartOfLineContent")},

        {key=" ", mods="NONE",  action=act.CopyMode{SetSelectionMode="Cell"}},
        {key="v", mods="NONE",  action=act.CopyMode{SetSelectionMode="Cell"}},
        {key="V", mods="NONE",  action=act.CopyMode{SetSelectionMode="Line"}},
        {key="V", mods="SHIFT", action=act.CopyMode{SetSelectionMode="Line"}},
        {key="v", mods="CTRL",  action=act.CopyMode{SetSelectionMode="Block"}},

        {key="G", mods="NONE",  action=act.CopyMode("MoveToScrollbackBottom")},
        {key="G", mods="SHIFT", action=act.CopyMode("MoveToScrollbackBottom")},
        {key="g", mods="NONE",  action=act.CopyMode("MoveToScrollbackTop")},

        {key="H", mods="NONE",  action=act.CopyMode("MoveToViewportTop")},
        {key="H", mods="SHIFT", action=act.CopyMode("MoveToViewportTop")},
        {key="M", mods="NONE",  action=act.CopyMode("MoveToViewportMiddle")},
        {key="M", mods="SHIFT", action=act.CopyMode("MoveToViewportMiddle")},
        {key="L", mods="NONE",  action=act.CopyMode("MoveToViewportBottom")},
        {key="L", mods="SHIFT", action=act.CopyMode("MoveToViewportBottom")},

        {key="o", mods="NONE",  action=act.CopyMode("MoveToSelectionOtherEnd")},
        {key="O", mods="NONE",  action=act.CopyMode("MoveToSelectionOtherEndHoriz")},
        {key="O", mods="SHIFT", action=act.CopyMode("MoveToSelectionOtherEndHoriz")},

        {key="PageUp",   mods="NONE", action=act.CopyMode("PageUp")},
        {key="PageDown", mods="NONE", action=act.CopyMode("PageDown")},

        {key="b", mods="CTRL", action=act.CopyMode("PageUp")},
        {key="f", mods="CTRL", action=act.CopyMode("PageDown")},

        -- Enter y to copy and quit the copy mode.
        {key="y", mods="NONE", action=act.Multiple{
            act.CopyTo("ClipboardAndPrimarySelection"),
            act.CopyMode("Close"),
        }},
        {key="Enter", mods="NONE", action=act.Multiple{
            act.CopyTo("ClipboardAndPrimarySelection"),
            act.CopyMode("Close"),
        }},

        -- Enter search mode to edit the pattern.
        -- When the search pattern is an empty string the existing pattern is preserved
        {key="/", mods="NONE", action=act{Search={CaseSensitiveString=""}}},
        {key="?", mods="NONE", action=act{Search={CaseInSensitiveString=""}}},
        {key="n", mods="CTRL", action=act{CopyMode="NextMatch"}},
        {key="p", mods="CTRL", action=act{CopyMode="PriorMatch"}},
    },

    search_mode = {
        {key="Escape", mods="NONE", action=act{CopyMode="Close"}},
        -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
        -- to navigate search results without conflicting with typing into the search area.
        {key="Enter", mods="NONE", action="ActivateCopyMode"},
        {key="c", mods="CTRL", action="ActivateCopyMode"},
        {key="n", mods="CTRL", action=act{CopyMode="NextMatch"}},
        {key="p", mods="CTRL", action=act{CopyMode="PriorMatch"}},
        {key="r", mods="CTRL", action=act.CopyMode("CycleMatchType")},
        {key="u", mods="CTRL", action=act.CopyMode("ClearPattern")},
    },
}

config.mouse_bindings = {
    -- disable middle click paste
    {
        event = { Down = { streak = 1, button = 'Middle' } },
        mods = 'NONE',
        action = act.DisableDefaultAssignment,
    },
}

return config
