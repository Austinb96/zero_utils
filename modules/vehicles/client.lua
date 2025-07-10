zutils.vehicles = {}

function zutils.vehicles.getVehiclesByPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    for i = 1, #vehicles do
        local veh = vehicles[i]
        local vehPlate = GetVehicleNumberPlateText(veh)
        if vehPlate == plate then
            return veh
        end
    end
    return nil, 'Vehicle not found'
end

function zutils.vehicles.getClosestVehicle(maxDist)
    local ped = PlayerPedId()
    local vehicles = GetGamePool('CVehicle')
	local closestDistance = math.huge
	local closestVehicle = nil
	for i = 1, #vehicles do
		local veh = vehicles[i]
		local vehCoords = GetEntityCoords(veh)
		local distance = #(GetEntityCoords(ped) - vehCoords)
		if distance < closestDistance and not(maxDist and distance > maxDist) then
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
            local errmsg = "Failed to set plate: %s"
            printwarn(errmsg, plate)
            return false, errmsg:format(plate)
        end
        Wait(100)
    end
    return true
end

return zutils.vehicles