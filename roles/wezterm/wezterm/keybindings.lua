local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

function M.apply(config)
    -- makes alt act as regular alt
    config.send_composed_key_when_left_alt_is_pressed = false
    config.send_composed_key_when_right_alt_is_pressed = false

    -- this is ISO PIPE key not 'SHIFT + COMMA'!
    config.leader = { key = '<', mods = "NONE" }

    config.mouse_bindings = {
        -- disable middle click paste and selects command output in shell (using wezterm escape sequences)
        {
            event = { Down = { streak = 1, button = 'Middle' } },
            mods = 'NONE',
            action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
        },
        -- make left click only select text not open links
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "NONE",
            action = wezterm.action { CompleteSelection = "PrimarySelection" }
        },
        -- and make CTRL-Click open links
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = "OpenLinkAtMouseCursor"
        }
    }

    config.keys = {
        -- allow to map keybinings to SHIFT + ESCAPE
        { key = 'Escape',     mods = 'SHIFT',        action = act.SendString("\x1b[[") },

        -- show debug overlay
        { key = 'D',          mods = 'SHIFT|ALT',    action = wezterm.action.ShowDebugOverlay },

        -- {
        --     key = 'P',
        --     mods = 'CTRL|SHIFT',
        --     action = wezterm.action.ActivateCommandPalette,
        -- },

        { key = 'l',          mods = 'LEADER',       action = act.ShowLauncherArgs({ title = 'New Tab', flags = "LAUNCH_MENU_ITEMS" }) },
        { key = "x",          mods = "LEADER",       action = act.CloseCurrentPane { confirm = true } },
        { key = "LeftArrow",  mods = "LEADER|ALT",   action = act.ActivateTabRelative(-1) },
        { key = "RightArrow", mods = "LEADER|ALT",   action = act.ActivateTabRelative(1) },
        { key = "<",          mods = "LEADER",       action = act.ActivateTabRelative(1) },

        -- window management
        { key = "UpArrow",    mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
        { key = "DownArrow",  mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
        { key = "LeftArrow",  mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
        { key = "RightArrow", mods = "LEADER",       action = act.ActivatePaneDirection("Right") },

        -- resizing
        { key = "UpArrow",    mods = "LEADER|SHIFT", action = act { AdjustPaneSize = { "Up", 3 } } },
        { key = "DownArrow",  mods = "LEADER|SHIFT", action = act { AdjustPaneSize = { "Down", 3 } } },
        { key = "LeftArrow",  mods = "LEADER|SHIFT", action = act { AdjustPaneSize = { "Left", 3 } } },
        { key = "RightArrow", mods = "LEADER|SHIFT", action = act { AdjustPaneSize = { "Right", 3 } } },

        -- splitting
        { key = "-",          mods = "LEADER",       action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },
        { key = "/",          mods = "LEADER",       action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },

        -- extra window stuff
        { key = "z",          mods = "LEADER",       action = "TogglePaneZoomState" },
        { key = "c",          mods = "LEADER",       action = act { SpawnTab = "CurrentPaneDomain" } },
    }

    config.key_tables = {
        vim = {
            -- The physical CMD key on OSX is the Alt key on Win/*nix, so map the common Alt-combo commands.
            { key = ".",          mods = "CMD",    action = act.SendString("\x1b.") },
            { key = "p",          mods = "CMD",    action = act.SendString("\x1bp") },
            { key = "n",          mods = "CMD",    action = act.SendString("\x1bn") },
            { key = "b",          mods = "CMD",    action = act.SendString("\x1bb") },
            { key = "f",          mods = "CMD",    action = act.SendString("\x1bf") },

            -- Window management
            -- {key = "Space", mods="LEADER", action=act{SendString=leader}},
            { key = "-",          mods = "LEADER", action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },
            { key = "\\",         mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
            { key = "z",          mods = "LEADER", action = "TogglePaneZoomState" },
            { key = "c",          mods = "LEADER", action = act { SpawnTab = "CurrentPaneDomain" } },
            { key = "LeftArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
            { key = "DownArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },
            { key = "UpArrow",    mods = "LEADER", action = act.ActivatePaneDirection("Up") },
            { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
            { key = "`",          mods = "LEADER", action = act.ActivateLastTab },
            { key = " ",          mods = "LEADER", action = act.ActivateTabRelative(1) },
            { key = "1",          mods = "LEADER", action = act { ActivateTab = 0 } },
            { key = "2",          mods = "LEADER", action = act { ActivateTab = 1 } },
            { key = "3",          mods = "LEADER", action = act { ActivateTab = 2 } },
            { key = "4",          mods = "LEADER", action = act { ActivateTab = 3 } },
            { key = "5",          mods = "LEADER", action = act { ActivateTab = 4 } },
            { key = "6",          mods = "LEADER", action = act { ActivateTab = 5 } },
            { key = "7",          mods = "LEADER", action = act { ActivateTab = 6 } },
            { key = "8",          mods = "LEADER", action = act { ActivateTab = 7 } },
            { key = "9",          mods = "LEADER", action = act { ActivateTab = 8 } },
            { key = "x",          mods = "LEADER", action = act { CloseCurrentPane = { confirm = true } } },

            -- Activate Copy Mode
            { key = "[",          mods = "LEADER", action = act.ActivateCopyMode },
            -- Paste from Copy Mode
            { key = "]",          mods = "LEADER", action = act.PasteFrom("PrimarySelection") },
        },

        copy_mode = {
            { key = "c",          mods = "CTRL",  action = act.CopyMode("Close") },
            { key = "g",          mods = "CTRL",  action = act.CopyMode("Close") },
            { key = "q",          mods = "NONE",  action = act.CopyMode("Close") },
            { key = "Escape",     mods = "NONE",  action = act.CopyMode("Close") },
            { key = "h",          mods = "NONE",  action = act.CopyMode("MoveLeft") },
            { key = "j",          mods = "NONE",  action = act.CopyMode("MoveDown") },
            { key = "k",          mods = "NONE",  action = act.CopyMode("MoveUp") },
            { key = "l",          mods = "NONE",  action = act.CopyMode("MoveRight") },
            { key = "LeftArrow",  mods = "NONE",  action = act.CopyMode("MoveLeft") },
            { key = "DownArrow",  mods = "NONE",  action = act.CopyMode("MoveDown") },
            { key = "UpArrow",    mods = "NONE",  action = act.CopyMode("MoveUp") },
            { key = "RightArrow", mods = "NONE",  action = act.CopyMode("MoveRight") },
            { key = "RightArrow", mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
            { key = "f",          mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
            { key = "Tab",        mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
            { key = "w",          mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
            { key = "LeftArrow",  mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
            { key = "b",          mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
            { key = "Tab",        mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
            { key = "b",          mods = "NONE",  action = act.CopyMode("MoveBackwardWord") },
            { key = "0",          mods = "NONE",  action = act.CopyMode("MoveToStartOfLine") },
            { key = "Enter",      mods = "NONE",  action = act.CopyMode("MoveToStartOfNextLine") },
            { key = "$",          mods = "NONE",  action = act.CopyMode("MoveToEndOfLineContent") },
            { key = "$",          mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
            { key = "^",          mods = "NONE",  action = act.CopyMode("MoveToStartOfLineContent") },
            { key = "^",          mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
            { key = "m",          mods = "ALT",   action = act.CopyMode("MoveToStartOfLineContent") },
            { key = " ",          mods = "NONE",  action = act.CopyMode { SetSelectionMode = "Cell" } },
            { key = "v",          mods = "NONE",  action = act.CopyMode { SetSelectionMode = "Cell" } },
            { key = "V",          mods = "NONE",  action = act.CopyMode { SetSelectionMode = "Line" } },
            { key = "V",          mods = "SHIFT", action = act.CopyMode { SetSelectionMode = "Line" } },
            { key = "v",          mods = "CTRL",  action = act.CopyMode { SetSelectionMode = "Block" } },
            { key = "G",          mods = "NONE",  action = act.CopyMode("MoveToScrollbackBottom") },
            { key = "G",          mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
            { key = "g",          mods = "NONE",  action = act.CopyMode("MoveToScrollbackTop") },
            { key = "H",          mods = "NONE",  action = act.CopyMode("MoveToViewportTop") },
            { key = "H",          mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
            { key = "M",          mods = "NONE",  action = act.CopyMode("MoveToViewportMiddle") },
            { key = "M",          mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
            { key = "L",          mods = "NONE",  action = act.CopyMode("MoveToViewportBottom") },
            { key = "L",          mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
            { key = "o",          mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEnd") },
            { key = "O",          mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
            { key = "O",          mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
            { key = "PageUp",     mods = "NONE",  action = act.CopyMode("PageUp") },
            { key = "PageDown",   mods = "NONE",  action = act.CopyMode("PageDown") },
            { key = "b",          mods = "CTRL",  action = act.CopyMode("PageUp") },
            { key = "f",          mods = "CTRL",  action = act.CopyMode("PageDown") },

            -- Enter y to copy and quit the copy mode.
            {
                key = "y",
                mods = "NONE",
                action = act.Multiple {
                    act.CopyTo("ClipboardAndPrimarySelection"),
                    act.CopyMode("Close"),
                }
            },
            {
                key = "Enter",
                mods = "NONE",
                action = act.Multiple {
                    act.CopyTo("ClipboardAndPrimarySelection"),
                    act.CopyMode("Close"),
                }
            },

            -- Enter search mode to edit the pattern.
            -- When the search pattern is an empty string the existing pattern is preserved
            { key = "/", mods = "NONE", action = act { Search = { CaseSensitiveString = "" } } },
            { key = "?", mods = "NONE", action = act { Search = { CaseInSensitiveString = "" } } },
            { key = "n", mods = "CTRL", action = act { CopyMode = "NextMatch" } },
            { key = "p", mods = "CTRL", action = act { CopyMode = "PriorMatch" } },
        },

        search_mode = {
            { key = "Escape", mods = "NONE", action = act { CopyMode = "Close" } },
            -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
            -- to navigate search results without conflicting with typing into the search area.
            { key = "Enter",  mods = "NONE", action = "ActivateCopyMode" },
            { key = "c",      mods = "CTRL", action = "ActivateCopyMode" },
            { key = "n",      mods = "CTRL", action = act { CopyMode = "NextMatch" } },
            { key = "p",      mods = "CTRL", action = act { CopyMode = "PriorMatch" } },
            { key = "r",      mods = "CTRL", action = act.CopyMode("CycleMatchType") },
            { key = "u",      mods = "CTRL", action = act.CopyMode("ClearPattern") },
        },
    }
end

return M
