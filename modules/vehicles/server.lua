local fuel = zutils.bridge_loader("fuel", "server")
if not fuel then return end

zutils.vehicles = {}

function zutils.vehicles.createVehicle(model, coords, props, options)
    model = zutils.joaat(model)
    options = options or {}
    options.type = options.type or "automobile"
    local vehicle = CreateVehicleServerSetter(model, options.type, coords.x, coords.y, coords.z,
        coords.w or options.heading)
        
    local exists, err = zutils.await(function()
        return DoesEntityExist(vehicle)
    end, "Vehicle Failed to Spawn", 10000, true)

    if not exists then
        return false, err
    end
    
    local vehicle_netId, netIdErr = zutils.AwaitNetId(vehicle)
    if not vehicle_netId then
        DeleteEntity(vehicle)
        return false, false, netIdErr
    end
    Wait(50)
    
    if options.warp then
        local ped = GetPlayerPed(options.warp)
        SetPedIntoVehicle(ped, vehicle, -1)
    end

    props.plate = zutils.vehicles.formatPlate(props.plate or zutils.vehicles.generatePlate())

    local result, plateErr = zutils.vehicles.setPlate(vehicle, props.plate)

    if not result then
        DeleteEntity(vehicle)
        return false, false, plateErr or "Plate failed to set"
    end
    
    SetEntityOrphanMode(vehicle, 2)

    Entity(vehicle).state:set('veh_properties', props, true)
    if options.fuel then
        if options.fuel == true then
            options.fuel = 100.0
        end
        fuel.setFuel(vehicle, options.fuel)
    end
    if options.states then
        for state, value in pairs(options.states) do
            Entity(vehicle).state:set(state, value, true)
        end
    end
    
    if options.onSpawn then
        options.onSpawn(vehicle, vehicle_netId)
    end
    if options.giveKeys then
        Wait(200)
        zutils.keys.giveKeys(props.plate, options.giveKeys)
    end
    
    if options.freeze then
        FreezeEntityPosition(vehicle, true)
    else
        CreateThread(function()
            Wait(1000)
            FreezeEntityPosition(vehicle, false)
        end)
    end
    
    return vehicle, vehicle_netId
end

function zutils.vehicles.getClosestVehicle(maxDist, coords)
    coords = coords or vector3(0, 0, 0)
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = math.huge
    local closestVehicle = nil
    for i = 1, #vehicles do
        local veh = vehicles[i]
        local vehCoords = GetEntityCoords(veh)
        local distance = #(coords - vehCoords)
        if distance < closestDistance and not (maxDist and distance > maxDist) then
            closestDistance = distance
            closestVehicle = veh
        end
    end
    return closestVehicle
end

function zutils.vehicles.awaitPlate(veh, plate)
    local timeout = 0
    local current = zutils.GetPlate(veh)
    while current ~= plate do
        current = zutils.GetPlate(veh)
        timeout = timeout + 1
        if timeout > 100 then
            local errmsg = "Plate did not match: expected: %s got: %s"
            printwarn(errmsg, plate, current)
            return false, errmsg:format(plate, current)
        end
        Wait(100)
    end
    return current
end

function zutils.vehicles.setPlate(veh, plate)
    if not veh or not plate then return false end
    SetVehicleNumberPlateText(veh, plate)
    local timeout = 0
    local current = zutils.GetPlate(veh)
    while current ~= plate do
        Wait(100)
        SetVehicleNumberPlateText(veh, plate)
        timeout = timeout + 100
        if timeout > 10000 then
            local errmsg = "Failed to set plate: %s"
            printwarn(errmsg, plate)
            return false, errmsg:format(plate)
        end
        current = zutils.GetPlate(veh)
    end
    Wait(100)
    return true
end

function zutils.vehicles.formatPlate(plate)
    plate = string.upper(plate)
    plate = plate:gsub('^%s*(.-)%s*$', '%1')
    return plate
end

local function randomChar(char)
    if not char then return " " end
    if char == "1" then
        return tostring(math.random(0, 9))
    elseif char == "A" then
        return string.char(math.random(65, 90))
    elseif char == "." then
        if math.random(1, 2) == 1 then
            return tostring(math.random(0, 9))
        else
            return string.char(math.random(65, 90))
        end
    end
end

zutils.vehicles.generatePlate = function(pattern)
    local plate = ""
    pattern = pattern or "1AAA..11"
    for i = 1, 8 do
        local char = string.sub(pattern, i, i)
        plate = plate .. randomChar(char)
    end
    local result = MySQL.Sync.fetchAll("SELECT id FROM player_vehicles WHERE plate = ?", {
        plate
    })
    if result[1] then
        return vehicles.generatePlate()
    else
        printdb("Generated plate: %s", plate)
        return plate
    end
end

function zutils.vehicles.isPlateOwned(plate)
    local result = MySQL.Sync.fetchAll("SELECT id FROM player_vehicles WHERE plate = ?", { plate })
    return result[1] ~= nil
end

function zutils.vehicles.isOwned(veh)
    local plate = zutils.GetPlate(veh)
    if not plate or plate == "" then
        printerr("Vehicle does not have a valid plate.")
        return false
    end
    local result = MySQL.Sync.fetchAll("SELECT id FROM player_vehicles WHERE plate = ?", { plate })
    return result[1] ~= nil
end

function zutils.vehicles.getVehicleTypeByModel(src, model)
    return zutils.callback.await('zero_utils:client:GetVehicleType', src, model)
end

function zutils.vehicles.isOut(plate)
    plate = zutils.vehicles.formatPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    for i = 1, #vehicles do
        if zutils.GetPlate(vehicles[i]) == plate then
            return true
        end
    end
    return false
end

return zutils.vehicles
