zutils.kvp = {}

function zutils.kvp.get(key, resource)
    local value
    if resource then
        value = GetExternalKvpString(resource, key)
    else
        value = GetResourceKvpString(key)
    end
    if value == nil then
        return nil, "Key does not exist"
    end
    local success, result = pcall(json.decode, value)
    if success then return result or value else return value end
end

function zutils.kvp.set(key, value)
    if value == nil then
        zutils.kvp.remove(key)
        return
    end
    if type(value) == "table" or type(value) == "boolean" then
        value = json.encode(value)
    end

    SetResourceKvp(key, value)
end

function zutils.kvp.remove(key)
    if GetResourceKvpString(key) ~= nil then
        DeleteResourceKvp(key)
    else
        return false, "Key does not exist"
    end
end

return zutils.kvp
