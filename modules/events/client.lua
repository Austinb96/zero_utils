zutils.events = {}

function zutils.events.onPlayerLoaded(cb)
    if LocalPlayer.state.isLoggedIn then
        Wait(500)
        printdb("Player was already loaded")
        cb()
    end
    if not zutils.isResourceMissing("qb-core") then
        AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
            Wait(500)
            while not LocalPlayer.state.isLoggedIn do Wait(1000) end
            printdb("Player loaded")
            cb()
        end)
    end
end

zutils.events.onPlayerUnload = function(cb)
    if not zutils.isResourceMissing("qb-core") then
        AddEventHandler("QBCore:Client:OnPlayerUnload", function()
            printdb("Player unloaded")
            cb()
        end)
    end
end

function zutils.events.onVehicleEntered(cb)
    if zutils.cache.vehicle and zutils.cache.vehicle ~= 0 then
        local model = GetEntityModel(zutils.cache.vehicle)
        local vehicle_name = GetDisplayNameFromVehicleModel(model)
        local vehicle_type = zutils.vehicles.getVehicleTypeByModel(model)
        cb(zutils.cache.vehicle, zutils.cache.seat, model, vehicle_name, vehicle_type)
    end
    zutils.cache.onSet('vehicle', function(vehicle)
        if not vehicle or vehicle == 0 then
            return
        end
        local model = GetEntityModel(vehicle)
        local vehicle_name = GetDisplayNameFromVehicleModel(model)
        local vehicle_type = zutils.vehicles.getVehicleTypeByModel(model)
        cb(vehicle, zutils.cache.seat, model, vehicle_name, vehicle_type)
    end)
end

function zutils.events.onLeftVehicle(cb)
    zutils.cache.onSet('vehicle', function(vehicle, oldVeh)
        if not oldVeh or oldVeh == 0 then
            return
        end
        local model = GetEntityModel(oldVeh)
        local vehicle_name = GetDisplayNameFromVehicleModel(model)
        local vehicle_type = zutils.vehicles.getVehicleTypeByModel(model)
        cb(oldVeh, zutils.cache.seat, model, vehicle_name, vehicle_type)
    end)
end

return zutils.events