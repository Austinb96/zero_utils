local function notify(src, notify_type, message, options)
    TriggerClientEvent("jixel-notify:client:j", src, notify_type, message, options?.length or 5000, options)
end

return notify