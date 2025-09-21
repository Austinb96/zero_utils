local function open_ui()
    SetNuiFocus(true, true)
    SendNUIMessage({ 
        action = "enableUI",
        data = true,
    })
end

RegisterCommand("ztool", function()
    open_ui()
end, false)

RegisterNUICallback("closeUI", function(_, cb)
    SetNuiFocus(false, false)
    cb()
end)

RegisterNuiCallback("getEntities", function(data, cb)
    local objects = data.networked_only and GetGamePool("CNetObject") or GetGamePool("CObject")
    local peds = GetGamePool("CPed")
    local vehicles = GetGamePool("CVehicle")
    
    local entities = {}
    local playerCoords = GetEntityCoords(PlayerPedId(), true)
    
    for _, obj in ipairs(objects) do
        if DoesEntityExist(obj) then
            local coords = GetEntityCoords(obj, true)
            local rotation = GetEntityRotation(obj, 2)
            local entityData = {
                id = tostring(obj),
                type = "object",
                script = GetEntityScript(obj),
                model = GetEntityModel(obj),
                position = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = rotation or 1.0
                },
                isNetworked = NetworkGetEntityIsNetworked(obj)
            }
            if entityData.isNetworked then
                entityData.id = ("%s(net:%s)"):format(obj, NetworkGetNetworkIdFromEntity(obj))
            end
            table.insert(entities, entityData)
        end
    end
    

    for _, ped in ipairs(peds) do
        if DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped, true)
            local rotation = GetEntityRotation(ped, 2)
            local entityData = {
                id = tostring(ped),
                type = "ped",
                script = GetEntityScript(ped),
                model = GetEntityModel(ped),
                position = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = rotation or 1.0
                },
                isNetworked = NetworkGetEntityIsNetworked(ped)
            }
            if entityData.isNetworked then
                entityData.id = ("%s(net:%s)"):format(ped, NetworkGetNetworkIdFromEntity(ped))
            end
            table.insert(entities, entityData)
        end
    end

    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            local coords = GetEntityCoords(vehicle, true)
            local rotation = GetEntityRotation(vehicle, 2)
            
            local entityData = {
                id = tostring(vehicle),
                type = "vehicle",
                script = GetEntityScript(vehicle),
                model = GetEntityModel(vehicle),
                position = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = rotation or 1.0
                },
                isNetworked = NetworkGetEntityIsNetworked(vehicle)
            }
            if entityData.isNetworked then
                entityData.id = ("%s(net:%s)"):format(vehicle, NetworkGetNetworkIdFromEntity(vehicle))
            end
            table.insert(entities, entityData)
        end
    end

    cb({
        result = {
            entities = entities,
            playerCoords = {
                x = playerCoords.x,
                y = playerCoords.y,
                z = playerCoords.z
            }
        },
    })
end)