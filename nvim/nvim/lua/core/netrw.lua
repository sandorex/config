local global_options = {
    -- keeps curdir same as the browsing dir, fixes file copying problems
    netrw_keepdir = 0,

    -- hide banner
    netrw_banner = 0,

    -- recursive copy
    netrw_localcopydircmd = 'cp -r'
}

for k, v in pairs(global_options) do
    vim.g[k] = v
end

-- TODO add keybindings to netrw

-- TODO highlighting netrw marked files
-- hi! link netrwMarkFile Search

