if not Config.Bridge.Callback then
    printdb("Config.Bridge.Callback not set. Checking for started resources")
    if GetResourceState("ox_lib"):find("start") then
        Config.Bridge.Callback = "ox"
    elseif GetResourceState("qb-core"):find("start") then
        Config.Bridge.Callback = "qb"
    else
        printerr("No compatible resource found for Config.Bridge.Callback please check your Config")
    end
end

local callback = require(("%s/bridge/%s/callback.lua"):format(zutils.context,string.upper(Config.Bridge.Callback)or""))
zutils.callback = setmetatable({}, {
    __call = function (_, name, delay, cb, ...)
        callback.trigger(name, delay, cb, ...)
    end
})
zutils.callback.trigger = callback.trigger
zutils.callback.register = callback.register
zutils.callback.await = callback.await

return zutils.callback