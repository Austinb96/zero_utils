zutils.progressBar = function(src, name, label, duration, options)
    return zutils.callback.await("zero_utils:progress", src, name, label, duration, options)
end

return zutils.progressBar