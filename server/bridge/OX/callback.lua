if not AssertBridgeResource(Config.Bridge.Callback, "ox", "ox_lib") then return end
printdb("Loading Callback")
local callback = {}

callback.trigger = function(name, src, cb, ...)
    printdb("Triggering Callback %s", name)
    lib.callback(name, src, cb, ...)
end

callback.await = function(name, src, ...)
    printdb("Awaiting Callback %s", name)
    return lib.callback.await(name, src, ...)
end

callback.register = function(name, func)
    printdb("Registering Callback %s", name)
    lib.callback.register(name, func)
end
printtable(callback)
return callback

