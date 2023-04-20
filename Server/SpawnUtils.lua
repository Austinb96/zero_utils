function SpawnVeh(model, pos, rot, src, teleportInto)
	model = type(model) == 'string' and GetHashKey(model) or model
	Utils.LoadModel(model)
    local vehicle = CreateVehicle(model, pos.x, pos.y, pos.z, rot or 0, true, true)
	local netId = nil
	while not DoesEntityExist(vehicle) or not netId do
		Wait(0)
		netId = NetworkGetNetworkIdFromEntity(vehicle)
	end

	SetNetworkIdCanMigrate(netid, true)
	SetVehicleFuelLevel(veh, 100.0)

	SetModelAsNoLongerNeeded(model)

    local plate = GetVehicleNumberPlateText(vehicle)
    PrintUtils.PrintDebug({
		{"Vehicle spawn Info: NetId:"},
		{netId, Color.White},
		{"Plate:"},
		{plate, Color.White},
		{"SpawnPos:"},
		{pos, Color.White}
	})

	if teleportInto then TaskWarpPedIntoVehicle(src, vehicle, -1) end
    return netId, plate
end
