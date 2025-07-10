function zutils.getClosestVehicle(max_dist, coords)
	coords = coords or zutils.context == "client" and GetEntityCoords(PlayerPedId()) or vector3(0, 0, 0)
    max_dist = max_dist or 10.0
    local vehicles = GetGamePool('CVehicle')
	local closestDistance = math.huge
	local closestVehicle = nil
	for i = 1, #vehicles do
		local veh = vehicles[i]
		local vehCoords = GetEntityCoords(veh)
		local distance = #(coords - vehCoords)
		if distance < closestDistance and distance < max_dist then
			closestDistance = distance
			closestVehicle = veh
		end
	end
	
	return closestVehicle, closestDistance
end


return zutils.getClosestVehicle