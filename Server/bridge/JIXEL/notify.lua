if not AssertBridgeResource(Config.Bridge.Notify, "jixel", "jixel-notify") then return end

local notify = function(src, type, message, options)
    TriggerClientEvent("jixel-notify:client:j", src, type, message, options?.length or 5000, options)
end

return notify
