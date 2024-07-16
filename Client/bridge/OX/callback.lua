if not AssertBridgeResource(Config.Bridge.Callback, "ox", "ox_lib") then return end
printdb("Loading Callback")
local callback = {}

callback.trigger = function(name, delay, cb, ...)
    printdb("Triggering Callback %s", name)
    lib.callback(name, delay, cb, ...)
end
callback.register = function(name, func)
    printdb("Registering Callback %s", name)
    lib.callback.register(name, func)
end

callback.await = function(name, delay, ...)
    printdb("Awaiting Callback %s", name)
    local result = lib.callback.await(name, delay, ...)
    printdb("Callback Result %s", json.encode(result))
    return result
end
return callback

