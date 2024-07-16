printdb("loading QB progressBar.lua")
if not AssertBridgeResource(Config.Bridge.ProgressBar, "qb", "progressbar") then return end
local progressBar = function(name, label, duration, options)
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = options.useWhileDead,
        canCancel = options.canCancel,
        controlDisables = options.controlDisables,
        animation = options.animation,
        prop = options.prop,
        propTwo = options.propTwo,
    }, function(cancelled)
        if not cancelled then
            if options.onFinish then
                options.onFinish()
            end
        else
            if options.onCancel then
                options.onCancel()
            end
        end
    end)
end

return progressBar