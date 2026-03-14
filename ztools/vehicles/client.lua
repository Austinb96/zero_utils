RegisterNUICallback("getVehicles", function(search, cb)
    local result, err = zutils.callback.await("ztool:server:getVehicles", nil, search)

    cb({
        result = result,
        err = err
    })
end)

RegisterNUICallback("updateVehicle", function(data, cb)
    local result, err = zutils.callback.await("ztool:server:updateVehicle", nil, data.vehicleId, data.updates)
    
    cb({
        result = result,
        err = err
    })
end)