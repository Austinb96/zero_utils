local function notify(notify_type, message, options)
    exports['jixel-notify']:J(notify_type, message, options?.length or 5000, options)
end

return notify
