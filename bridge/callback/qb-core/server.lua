local callback = {}
callback.trigger = function(name, src, cb, ...)
    printdb("Triggering Callback %s", name)
    QBCore.Functions.TriggerClientCallback(name,src, cb, ...)
end

callback.register = function(name, func)
    printdb("Registering Callback %s", name)
    QBCore.Functions.CreateCallback(name, function(src, cb, ...)
        local result = {func(src, ...)}
        printtable("Callback result", result)
        cb(table.unpack(result))
    end)
end

callback.await = function(name, src, ...)
    printdb("Awaiting Callback %s", name)
    local p = promise.new()
    callback.trigger(name, src, function(...)
        local args = {...}
        p:resolve(args)
    end, ...)
    printdb("Awaiting Callback %s", name)
    local result = Citizen.Await(p)
    return table.unpack(result)
end

return callback