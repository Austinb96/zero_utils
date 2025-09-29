--TODO DEPRECATE LATER
function zutils.spawnVehicle(source, model, coords, props, options)
    printdb("Spawning vehicle %s %s %s %s %s", source, model, coords, props, options)
    local hash = type(model) == 'string' and joaat(model) or model;
    if not options then options = {} end
    options.vehicleType = options.vehicleType or zutils.callback.await('zero_utils:client:GetVehicleType',source, model)
    local veh = CreateVehicleServerSetter and CreateVehicleServerSetter(hash, options.vehicleType, coords.x, coords.y, coords.z, coords.w) or CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w, true, true)
    if not veh then printerr("Failed to create vehicle") return end
    while not DoesEntityExist(veh) do Wait(0) end
    
    SetEntityOrphanMode(veh, 2)
    
    local netId = zutils.AwaitNetId(veh)
    
    if options.statebag then
        local state = Entity(veh).state
        if type(options.statebag) == 'table' then
            for k,v in pairs(options.statebag) do
                printdb("Setting statebag key %s to %s", k, v)
                state[k] = v
            end
        else
            printwarn("Invalid statebag type. Must pass in as table. got: %s", type(options.statebag))
        end
    end
    
    if props then
        local entityOwner = NetworkGetEntityOwner(veh)
        TriggerClientEvent('ox_lib:setVehicleProperties', entityOwner, netId, props)
        Wait(200)
        if props.plate then
            local result, err = AwaitSetPlate(veh, props.plate)
            if not result then
                zutils.notify(source, "error", err)
                DeleteEntity(veh)
                return
            end
        end
    end
    
    if options.warp then
        local ped = GetPlayerPed(source)
        SetPedIntoVehicle(ped, veh, -1)
        Wait(100)
    end
    
    if options.freeze then
        FreezeEntityPosition(veh, true)
    end
    
    if options.onSpawn then
        options.onSpawn(netId, veh)
    end
    
    return netId
end


return zutils.spawnVehicle
