-- contains functions used in the config

local M = {}

---Opens file as a note but only once, if it is already open it is focused
---@param file string? path to the file
function M.open_notes(file)
    -- default to global notes
    if file == nil then
        file = vim.fn.stdpath('data') .. '/global_notes.md'
    end

    -- find buffers with same file open
    local note_bufs = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_loaded(buf)
            and vim.b[buf].is_notes == true
            and vim.api.nvim_buf_get_name(buf) == file
    end, vim.api.nvim_list_bufs())

    if #note_bufs == 0 then
        -- no buffers found then open it
        vim.cmd('edit ' .. file)
        vim.b.is_notes = true
    else
        -- focus the first one
        vim.api.nvim_set_current_buf(note_bufs[1])
    end
end

return M

