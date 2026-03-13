zutils.nui = {}

local function Result(result, err)
    if result == nil and err == nil then
        result = "ok"
    end
    return {
        result = result,
        err = err
    }
end

function zutils.nui.registerCallback(action, cb)
    if not cb then return end
    RegisterNUICallback(action, function(data, nuiCb)
        local result, err = cb(data)
        nuiCb(Result(result, err))
    end)
end

function zutils.nui.send(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

return zutils.nui