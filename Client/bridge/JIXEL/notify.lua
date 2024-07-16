if not AssertBridgeResource(Config.Bridge.Notify, "jixel", "jixel-notify") then return end

local notify = function (type,message,options)
    exports['jixel-notify']:J(type, message, options?.length or 5000, options)
end

return notify