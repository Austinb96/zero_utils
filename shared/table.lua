local function contains(t, search)
    if type(search) == "table" then
        for _, v in ipairs(search) do
            if not contains(t, v) then
                return false
            end
        end
        return true
    end

    if t[search] then
        return true
    end

    for _, v in ipairs(t) do
        if v == search then
            return true
        end
    end
    return false
end

local function count(table)
    local i = 0
    for _ in pairs(table) do
        i = i + 1
    end
    return i
end

local function isArray(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

local function isTable(t1)
    return type(t1) == "table"
end

local function combine(t1, t2)
    local combined = {}
    if isArray(t1) and isArray(t2) then
        for _, v in ipairs(t1) do
            table.insert(combined, v)
        end
        for _, v in ipairs(t2) do
            table.insert(combined, v)
        end
    else
        for k, v in pairs(t1 or {}) do
            combined[k] = v
        end
        for k, v in pairs(t2 or {}) do
            combined[k] = v
        end
    end
    return combined
end

local function isEmpty(t1)
    return (not next(t1)) and true or false
end

local function serialize(tbl, indent, sort_order)
    indent = indent or 0
    sort_order = sort_order or {}
    local spacing = string.rep("    ", indent)
    local result = "{\n"

    local is_array = isArray(tbl)

    if is_array then
        for i = 1, #tbl do
            result = result .. spacing .. "    "

            if type(tbl[i]) == "table" then
                result = result .. serialize(tbl[i], indent + 1, sort_order)
            elseif type(tbl[i]) == "string" then
                result = result .. '"' .. tbl[i] .. '"'
            else
                result = result .. tostring(tbl[i])
            end

            result = result .. ",\n"
        end
    else
        local priority_keys = {}
        local other_keys = {}
        local priority_set = {}

        for _, key in ipairs(sort_order) do
            priority_set[key] = true
        end

        for k in pairs(tbl) do
            if priority_set[k] then
                table.insert(priority_keys, k)
            else
                table.insert(other_keys, k)
            end
        end

        table.sort(priority_keys, function(a, b)
            for i, key in ipairs(sort_order) do
                if key == a then return true end
                if key == b then return false end
            end
            return false
        end)

        table.sort(other_keys, function(a, b)
            return tostring(a) < tostring(b)
        end)

        local all_keys = {}
        for _, k in ipairs(priority_keys) do
            table.insert(all_keys, k)
        end
        for _, k in ipairs(other_keys) do
            table.insert(all_keys, k)
        end

        for _, k in ipairs(all_keys) do
            local v = tbl[k]
            result = result .. spacing .. "    "

            if type(k) == "number" then
                result = result .. "[" .. k .. "] = "
            else
                if k:match("[^%w_]") or k:match("^%d") then
                    result = result .. '["' .. k .. '"] = '
                else
                    result = result .. k .. ' = '
                end
            end

            if type(v) == "table" then
                result = result .. serialize(v, indent + 1, sort_order)
            elseif type(v) == "string" then
                result = result .. '"' .. v .. '"'
            else
                result = result .. tostring(v)
            end

            result = result .. ",\n"
        end
    end

    result = result .. spacing .. "}"
    return result
end


table.isArray = isArray
table.contains = contains
table.count = count
table.combine = combine
table.isEmpty = isEmpty
table.serialize = serialize