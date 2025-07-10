function zutils.loadModel(model)
    local hash = zutils.joaat(model)

    if not IsModelInCdimage(hash) then
        printerr("Model %s not found in cdimage", model)
    end

    if HasModelLoaded(hash) then
        return true
    end

    RequestModel(hash)
    zutils.await(function()
        return HasModelLoaded(hash)
    end, { "Model Failed to Load %s", model }, 20000)
end


return zutils.loadModel