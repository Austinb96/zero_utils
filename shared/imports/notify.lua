if not Config.Bridge.Notify then
    if GetResourceState("qb-core"):find("start") then
        Config.Bridge.Notify = "qb"
    elseif GetResourceState("ox_lib"):find("start") then
        Config.Bridge.Notify = "ox"
    elseif GetResourceState("jixel-notify"):find("start") then
        Config.Bridge.Notify = "jixel"
    else
        printerr("No compatible resource found for Config.Bridge.Notify please check your Config")
    end
end
zutils.notify = require(("%s/bridge/%s/notify.lua"):format(zutils.context,string.upper(Config.Bridge.Notify)or""))
return zutils.notify