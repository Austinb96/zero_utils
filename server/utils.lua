function AwaitNetId(entity)
    local timeout = 0
    local netId = NetworkGetNetworkIdFromEntity(entity)
    while not netId do
        netId = NetworkGetNetworkIdFromEntity(entity)
        timeout = timeout + 1
        if timeout > 100 then
            printerr("Failed to get net id for entity")
            return false
        end
        Wait(100)
    end
    
    return netId
end

function AwaitEntityFromNetId(netID)
    local timeout = 0
    local entity = NetworkGetEntityFromNetworkId(netID)
    while not entity do
        entity = NetworkGetEntityFromNetworkId(netID)
        timeout = timeout + 1
        if timeout > 100 then
            printerr("Failed to get entity from net id")
            return false
        end
        Wait(100)
    end
    
    return entity
end

function AwaitSetPlate(veh, plate)
    local timeout = 0
    while not SetVehicleNumberPlateText(veh, plate) do
        timeout = timeout + 1
        if timeout > 100 then
            printerr("Failed to set plate")
            return false
        end
        Wait(100)
    end
    return true
end