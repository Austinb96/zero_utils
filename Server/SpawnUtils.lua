function ZeroUtils.SpawnVeh(model, pos, rot, src, teleportInto)
    local vehicle = CreateVehicle(model, pos.x, pos.y, pos.z, rot or 0, true, true)
	local netId = nil
	while not DoesEntityExist(vehicle) or not netId do
		Wait(0)
		if DoesEntityExist(vehicle) then
			netId = NetworkGetNetworkIdFromEntity(vehicle)
		end
	end

    local plate = GetVehicleNumberPlateText(vehicle)
	if teleportInto then TaskWarpPedIntoVehicle(src, vehicle, -1) end

    PrintUtils.PrintDebug("Vehicle Spawned: NetId: %s Plate: %s SpawnPos: %s",netId, plate, pos)

    return netId, plate
end
