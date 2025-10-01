zutils.callback.register('zero_utils:server:spawnVehicle', function(source, model, coords, props, options)
    return zutils.spawnVehicle(source, model, coords, props, options)
end)

zutils.callback.register('zero_utils:server:isVehicleOwnedByPlayer', function(source, plate)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false, "Player not found" end

    local result = MySQL.query.await("SELECT * FROM player_vehicles WHERE citizenid = @citizenid AND plate = @plate ", {
        ['@citizenid'] = player.PlayerData.citizenid,
        ['@plate'] = plate
    })

    if not result or not result[1] then return false, "Vehicle not found" end

    return true
end)

local placedItems = {}

zutils.callback.register("zutils:server:pickupItem", function(source, netid, item)
    printdb("Picking up item for id %s", netid)
    local entity, err = zutils.AwaitEntityFromNetId(netid)
    if err then
        printwarn(err)
        zutils.notify(source, "error", err)
        return false
    end
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local dist = #(playerCoords - GetEntityCoords(entity))
    if dist > 10.0 then
        return printerr("Player tried to delete spikestrip from too far away : %s",dist)
    end
    if item then
        local success, err = zutils.inventory.AddItem(source, item.name, 1, item.metadata)
        if not success then
            zutils.notify(source, "error", err)
            return
        end
    end
    DeleteEntity(entity)
    return true
end)

zutils.callback.register("zutils:server:getSpawnedItems", function(source, netid, item)
    printdb("Getting spawned items")
    return placedItems
end)

RegisterNetEvent("zutils:server:ItemSpawned", function(netid, options)
    printdb("Setting up prop target for %s", netid)
    placedItems[netid] = {
        target = options.target,
        anim = options.anim,
        item = options.item,
        pickupTime = options.pickupTime,
    }
    if options.target?.onPickupEvent or options.item then
        TriggerClientEvent("zero_utils:client:SetupPropTarget", -1, netid, options)
    end
    if options.item then
        zutils.inventory.RemoveItem(source, options.item.name, 1, nil, options.item.slot, true)
    end
end)

