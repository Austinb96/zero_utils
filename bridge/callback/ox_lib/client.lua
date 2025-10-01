zutils.core_loader("ox_lib")

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
    return lib.callback.await(name, delay, ...)
end
return callback