zutils.core_loader("ox_lib")

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

return callback