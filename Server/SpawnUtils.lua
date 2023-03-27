function SpawnVeh(model, pos, rot)
    rot = rot or 0
    local vehicle = CreateVehicle(model, pos.x, pos.y, pos.z, rot, true, true)

    while not DoesEntityExist(vehicle) do
        Wait(0)
    end

    local netId = nil
    while not netId do
        Wait(0)
        netId = NetworkGetNetworkIdFromEntity(vehicle)
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    PrintUtils.PrintDebug({
		{"Vehicle spawn Info: NetId:"},
		{netId, Color.Yellow},
		{"Plate:"},
		{plate, Color.Yellow},
		{"SpawnPos:"},
		{pos, Color.Yellow}
	})
    return netId, plate
end
