zutils.callback.register('zero_utils:server:spawnVehicle', function(source, model, coords, props, options)
    printdb("Spawning vehicle %s %s %s %s %s", source, model, coords, props, options)
    local hash = type(model) == 'string' and joaat(model) or model;
    if not options then options = {} end
    options.vehicleType = options.vehicleType or zutils.callback.await('zero_utils:client:GetVehicleType',source, model)
    local veh = CreateVehicleServerSetter and CreateVehicleServerSetter(hash, options.vehicleType, coords.x, coords.y, coords.z, coords.w) or CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w, true, true)
    if not veh then printerr("Failed to create vehicle") return end
    
    local netId = AwaitNetId(veh)
    
    if props then
        if props.plate then
            if not AwaitSetPlate(veh, props.plate) then DeleteEntity(veh) return end
        end
        local entityOwner = NetworkGetEntityOwner(veh)
        TriggerClientEvent('ox_lib:setVehicleProperties', entityOwner, netId, props)
    end
    
    if options.warp then
        local ped = GetPlayerPed(source)
        SetPedIntoVehicle(ped, veh, -1)
    end
    
    if options.freeze then
        FreezeEntityPosition(veh, true)
    end
    
    if options.statebag then
        local state = Entity(veh).state
        if type(options.statebag) == 'table' then
            for k,v in pairs(options.statebag) do
                state[k] = v
            end
        else
            printwarn("Invalid statebag type. Must pass in as table. got: %s", type(options.statebag))
        end
    end
    
    return netId
end)