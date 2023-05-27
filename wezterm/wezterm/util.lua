-- utility functions

local M = {}

function M.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function M.merge_table(a, b)
    if type(a) ~= 'table' or type(b) ~= 'table' then
        error("Illegal argument: a or b are not a 'table' type")
    end
    for k, v in pairs(b) do
        if a[k] ~= nil then
            error(string.format("Duplicate keys detected:\nkey=%q, exist value=%q", dump(k), dump(a[k])))
            return
        end
        a[k] = v
    end
end

return M

