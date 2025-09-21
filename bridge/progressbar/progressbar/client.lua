local progressBar = function(name, label, duration, options)
    local promise = promise:new()
    options.animation = options.animation or {}
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = options.useWhileDead,
        canCancel = options.canCancel,
        controlDisables = options.controlDisables,
        animation = {
            animDict = options.animation.dict or options.animDict,
            anim = options.animation.anim,
            flags = options.animation.flags
        },
        prop = options.prop,
        propTwo = options.propTwo,
    }, function(cancelled)
        if not cancelled then
            if options.onFinish then
                options.onFinish()
            end
            promise:resolve(true)
        else
            if options.onCancel then
                options.onCancel()
            end
            promise:resolve(false)
        end
    end)

    Citizen.Await(promise)
    if options.onEnd then
        options.onEnd()
    end
    return promise.value
end

return progressBar
