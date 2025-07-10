local function notify(notify_type, message, options)
    options = options or {}
    lib.notify({
        title = options.title or notify_type,
        description = message,
        duration = options.duration or 5000,
        type = notify_type,
    })
end

return notify
