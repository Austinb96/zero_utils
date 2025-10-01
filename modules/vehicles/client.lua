local core = zutils.bridge_loader("core", "shared")
local fuel = zutils.bridge_loader("fuel", "client")
if not core or not fuel then return end

local MISMATCHED_VEHICLE_TYPES = {
    [`airtug`] = "automobile",       -- trailer
    [`avisa`] = "submarine",         -- boat
    [`blimp`] = "heli",              -- plane
    [`blimp2`] = "heli",             -- plane
    [`blimp3`] = "heli",             -- plane
    [`caddy`] = "automobile",        -- trailer
    [`caddy2`] = "automobile",       -- trailer
    [`caddy3`] = "automobile",       -- trailer
    [`chimera`] = "automobile",      -- bike
    [`docktug`] = "automobile",      -- trailer
    [`forklift`] = "automobile",     -- trailer
    [`kosatka`] = "submarine",       -- boat
    [`mower`] = "automobile",        -- trailer
    [`policeb`] = "bike",            -- automobile
    [`ripley`] = "automobile",       -- trailer
    [`rrocket`] = "automobile",      -- bike
    [`sadler`] = "automobile",       -- trailer
    [`sadler2`] = "automobile",      -- trailer
    [`scrap`] = "automobile",        -- trailer
    [`slamtruck`] = "automobile",    -- trailer
    [`Stryder`] = "automobile",      -- bike
    [`submersible`] = "submarine",   -- boat
    [`submersible2`] = "submarine",  -- boat
    [`thruster`] = "heli",           -- automobile
    [`towtruck`] = "automobile",     -- trailer
    [`towtruck2`] = "automobile",    -- trailer
    [`tractor`] = "automobile",      -- trailer
    [`tractor2`] = "automobile",     -- trailer
    [`tractor3`] = "automobile",     -- trailer
    [`trailersmall2`] = "trailer",   -- automobile
    [`utillitruck`] = "automobile",  -- trailer
    [`utillitruck2`] = "automobile", -- trailer
    [`utillitruck3`] = "automobile", -- trailer
}
local VEHICLE_TYPES = {
    [8] = "bike",
    [11] = "trailer",
    [13] = "bike",
    [14] = "boat",
    [15] = "heli",
    [16] = "plane",
    [21] = "train",
}

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

function zutils.vehicles.getVehicleTypeByModel(model)
    model = zutils.joaat(model)
    if not IsModelInCdimage(model) then
        return false, "Model not found in CD image: " .. model
    end

    if MISMATCHED_VEHICLE_TYPES[model] then
        return MISMATCHED_VEHICLE_TYPES[model]
    end

    local vehicleType = GetVehicleClassFromName(model)
    return VEHICLE_TYPES[vehicleType] or "automobile"
end

function zutils.vehicles.getClosestVehicle(maxDist, coords)
    coords = coords or GetEntityCoords(PlayerPedId())
    local vehicles = GetGamePool('CVehicle')
	local closestDistance = math.huge
	local closestVehicle = nil
	for i = 1, #vehicles do
		local veh = vehicles[i]
		local vehCoords = GetEntityCoords(veh)
		local distance = #(coords.xyz - vehCoords)
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
            local errmsg = "Plate did not match: expected: %s got: %s"
            printwarn(errmsg, plate, current)
            return false, errmsg:format(plate, current)
        end
        Wait(100)
    end
    return current
end

function zutils.vehicles.getProperties(veh)
    if not DoesEntityExist(veh) then
        return false, "Vehicle does not exist"
    end
    local properties = core.getVehicleProperties(veh)
    if not properties then
        return false, "Failed to get vehicle properties"
    end
    return properties
end

function zutils.vehicles.setFuel(veh, amount)
    if not DoesEntityExist(veh) then
        return false, "Vehicle does not exist"
    end
    if amount < 0 then
        return false, "Invalid fuel amount"
    end

    fuel.setFuel(veh, amount)

    return true
end

function zutils.vehicles.getFuel(veh)
    if not DoesEntityExist(veh) then
        return false, "Vehicle does not exist"
    end

    return fuel.getFuel(veh)
end

return zutils.vehicles