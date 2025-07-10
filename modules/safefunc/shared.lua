local _pcall = pcall
local _type = type
local prefix = "error:"
function zutils.Err(msg)
    return {err = msg}
end
function zutils.safefunc(func)
    return function(...)
        local status, result = _pcall(func, ...)
        if status then
            if _type(result) == "table" and result.err then
                return false, prefix..result.err
            end
            return result
        else
            return false, prefix..result
        end
    end
end

return zutils.safefunc
