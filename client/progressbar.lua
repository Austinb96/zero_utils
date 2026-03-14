zutils.callback.register("zero_utils:progress", function(name, label, duration, options)
    return zutils.progressBar(
        name,
        label,
        duration,
        options
    )
end)