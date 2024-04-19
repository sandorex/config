-- module contains all session/project stuff

local M = {}

M.sessions_dir = vim.fn.stdpath('data') .. '/mksessions'
M.autosave_interval = 30000
M.autosave = true

vim.o.sessionoptions = 'skiprtp,buffers,curdir,folds,help,tabpages,winsize,terminal'

-- TODO filter out some buffers like git commit and netrw
-- TODO choose interactively

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
    if vim.v.this_session ~= '' then
        vim.cmd.mksession { args = { vim.fn.fnameescape(vim.v.this_session) }, bang = true }
        return true
    end

    return false
end

---saves current session, the name can be an absolute path to save as a directory session
---if session_name is '.' then uses cwd as session name
---@param session_name string
function M.save_session(session_name)
    -- make sure the directory exists
    vim.fn.mkdir(M.sessions_dir, 'p')

    if session_name == '.' or session_name == '' then
        session_name = vim.fn.getcwd()
    end

    local path = M.sessions_dir .. '/' .. b64_encode(session_name) .. '.vim'
    vim.cmd.mksession { args = { vim.fn.fnameescape(path) }, bang = true }

    -- make it seem as if a session was loaded
    vim.v.this_session = path

    -- enable auto save if requested
    if M.autosave then
        M.enable_auto_save()
    end
end
vim.api.nvim_create_user_command("SessionSave", function(args)
    -- if not bang (!) and session was loaded already then overwrite it and ignore the argument
    if not args.bang and vim.v.this_session ~= '' then
        M.save_current_session()
    end

    M.save_session(args.args)
end, {
    desc = 'Save current session as new session, to save session even though it is loaded already use bang!',
    nargs=1,
    bang=true
})

---load session, the name can be an absolute path to load a directory session
---if session_name is '.' then load cwd session
---@param session_name string
function M.load_session(session_name)
    if session_name == '.' or session_name == '' then
        session_name = vim.fn.getcwd()
    end

    -- check if it exists
    local path = M.sessions_dir .. '/' .. vim.fn.fnameescape(b64_encode(session_name)) .. '.vim'
    if vim.fn.filereadable(path) ~= 1 then
        return false
    end

    vim.cmd.source(path)

    -- enable autosaving if requested
    if M.autosave then
        M.enable_auto_save()
    end

    return true
end
vim.api.nvim_create_user_command("SessionLoad", function(args)
    if not M.load_session(args.args) then
        vim.notify('Could not find session: ' .. arg, vim.log.levels.WARN)
    end
end, {
    desc = 'Load session',
    complete = function(_, _, _)
        return M.get_sessions()
    end,
    nargs='?'
})

---returns all known sessions
---@return table
function M.get_sessions()
    local sessions = {}

    local iter = vim.fs.dir(M.sessions_dir, {})
    for name, type_ in iter do
        -- ignore directories
        if type_ == 'file' then
            -- remove .vim extension and decode the name
            table.insert(sessions, b64_decode(vim.fn.fnamemodify(name, ":t:r")))
        end
    end

    return sessions
end

---automatically save session at fixed interval M.autosave_interval
function M.enable_auto_save()
    -- no session to save to
    if vim.v.this_session == nil then
        return
    end

    -- start a timer and reset it each time CursorHold event triggers, this achieves effect like
    -- OnIdle event with M.autosave_interval being the idle time
    M.timer = M.timer or vim.loop.new_timer()
    local augroup = vim.api.nvim_create_augroup('session_autosave', {})
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = augroup,
        callback = function()
            -- schedule_wrap allows usage of vim api inside
            M.timer:start(M.autosave_interval, 0, vim.schedule_wrap(function()
                M.save_current_session()

                vim.notify('Session automatically saved', vim.log.levels.INFO)
            end))
        end
    })

    -- save session before quitting or suspending
    vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
        group = augroup,
        callback = function()
            M.save_current_session()
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

