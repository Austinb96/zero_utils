local callback = {}
callback.trigger = function(name, _, cb, ...)
    printdb("Triggering Callback %s %s %s", name, tostring(_), tostring(cb))
    QBCore.Functions.TriggerCallback(name, cb, ...)
end
callback.register = function(name, func)
    printdb("Registering Callback %s", name)
    QBCore.Functions.CreateClientCallback(name, function(cb, ...)
        local result = {func(...)}
        cb(table.unpack(result))
    end)
end

callback.await = function(name, _, ...)
    printdb("Awaiting Callback %s", name)
    local p = promise.new()
    callback.trigger(name, nil, function(...)
        local args = {...}
        p:resolve(args)
    end, ...)
    local result = Citizen.Await(p)
    return table.unpack(result)
end
return callback
