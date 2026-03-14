RegisterCommand("gethash", function(_, args)
    local model = args[1]
    print(("%s = %s"):format(model, GetHashKey(model)))
end, false)

RegisterCommand("findhash", function(_, args)
    local hash = tonumber(args[1])
    if not hash then return print("usage: /findhash <decimal>") end

    for name in pairs(exports.ox_inventory:Items()) do
        if zutils.joaat(name) == hash then
            return print(("foundItem: %s(%s)"):format(name, hash))
        end
    end

    print("none found")
end, false)



RegisterCommand("carmax", function(source, args)
    local model = args[1]
    local coords = GetEntityCoords(GetPlayerPed(source))
    coords = vector4(coords.x, coords.y, coords.z, GetEntityHeading(GetPlayerPed(source)))

    local vehicle_ped_is_in = GetVehiclePedIsIn(GetPlayerPed(source), false)
    if vehicle_ped_is_in and vehicle_ped_is_in ~= 0 then
        DeleteEntity(vehicle_ped_is_in)
    end
    zutils.vehicles.createVehicle(model, coords, {
        modEngine = 3,
        modBrakes = 2,
        modTransmission = 2,
        modSuspension = 2,
        modTurbo = true,
    }, {
        warp = source,
        giveKeys = source,
        fuel = true,
        onSpawn = function()
            zutils.notify(source, "success", "Vehicle spawned with max upgrades!")
        end,
    })
end, true)