if not AssertBridgeResource(Config.Bridge.Callback, "qb", "qb-core") then return end
printdb("Loading Callback")
local callback = {}
local qbfunction = exports["qb-core"]:GetCoreObject().Functions
callback.trigger = function(name, src, cb, ...)
    printdb("Triggering Callback %s", name)
    qbfunction.TriggerClientCallback(name,src, cb, ...)
end

callback.register = function(name, func)
    printdb("Registering Callback %s", name)
    qbfunction.CreateCallback(name, function(src, cb, ...)
        local result = {func(src, ...)}
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

