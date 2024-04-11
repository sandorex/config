-- module contains all session/project stuff

local M = {}

M.sessions_dir = vim.fn.stdpath('data') .. '/mksessions'
M.autosave_interval = 30000
M.autosave = true

-- TODO list sessions api
-- TODO choose interactively the api

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function b64_encode(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c=0
    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
    return b:sub(c+1,c+1)
end)..({ '', '==', '=' })[#data%3+1])
end

local function b64_decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
end))
end

---saves current session, does nothing if no session is active
---@return boolean
function M.save_current_session()
    if vim.v.this_session ~= nil then
        vim.cmd('mksession! ' .. vim.fn.fnameescape(vim.v.this_session))
        return true
    end

    return false
end

--- saves current session, the name can be an absolute path to save as a directory session
---@param session_name string
function M.save_session(session_name)
    -- make sure the directory exists
    vim.fn.mkdir(M.sessions_dir, 'p')

    vim.cmd('mksession! ' .. M.sessions_dir .. '/' .. vim.fn.fnameescape(b64_encode(session_name)) .. '.vim')
end

---load session, the name can be an absolute path to load a directory session
---@param session_name string
function M.load_session(session_name)
    -- check if it exists
    local path = M.sessions_dir .. '/' .. vim.fn.fnameescape(b64_encode(session_name)) .. '.vim'
    if vim.fn.filereadable(path) ~= 1 then
        return false
    end

    vim.cmd('source ' .. path)

    -- enable autosaving if requested
    if M.autosave then
        M.enable_auto_save()
    end
end

---automatically save session at fixed interval M.autosave_interval
function M.enable_auto_save()
    -- no session to save to
    if vim.v.this_session == nil then
        return
    end

    M.timer = M.timer or vim.loop.new_timer()
    vim.api.nvim_create_autocmd("CursorHold", {
        group = vim.api.nvim_create_augroup('mksession_autosave', {}),
        callback = function()
            -- schedule_wrap allows usage of vim api inside
            M.timer:start(M.autosave_interval, 0, vim.schedule_wrap(function()
                M.save_current_session()

                vim.notify('Session auto save', vim.log.levels.OFF)
            end))
        end
    })
end

---disable auto saving timer
function M.disable_auto_save()
    vim.api.nvim_create_augroup('mksession_autosave', {})

    if M.timer ~= nil then
        M.timer:stop()
        M.timer = nil
    end
end

return M

