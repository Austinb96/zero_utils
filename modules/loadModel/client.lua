function zutils.loadModel(model, return_err)
    local hash = zutils.joaat(model)

    if not IsModelInCdimage(hash) then
        if return_err then 
            return false, ("Model %s notfound in cdimage"):format(model)
        else
            printerr("Model %s not found in cdimage", model)
        end
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