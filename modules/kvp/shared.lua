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
    return success and result or value
end

function zutils.kvp.set(key, value)
    if type(value) == "table" then
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
