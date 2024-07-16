local placedItems = {}

zutils.callback.register("zutils:server:pickupItem", function(source, netid, item)
    printdb("Picking up item for id %s", netid)
    local entity = AwaitEntityFromNetId(netid)
    if not entity then
        printwarn("Failed to get spike entity from netid %s", netid)
        return false
    end
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local dist = #(playerCoords - GetEntityCoords(entity))
    if dist > 10.0 then
        return printerr("Player tried to delete spikestrip from too far away : %s",dist)
    end
    DeleteEntity(entity)
    if item then
        --give item logic NYI
    end
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
end)