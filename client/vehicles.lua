local fuel = zutils.bridge_loader("fuel", "client")
if not fuel then printerr("Failed to load fuel bridge") return end

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

AddStateBagChangeHandler('veh_properties', '', function(bagName, _, value)
    if not value or not value.plate then return end
    local vehicle = zutils.await(function()
        local vehicle = GetEntityFromStateBagName(bagName)
        if DoesEntityExist(vehicle) then
            return vehicle
        end
    end, nil, 10000, true)
    if not vehicle then return end

    --TODO support other properties later.
    lib.setVehicleProperties(vehicle, value)
    Wait(200)
    
    
    if NetworkGetEntityOwner(vehicle) == PlayerId() then
        lib.setVehicleProperties(vehicle, value)
        Entity(vehicle).state:set('veh_properties', nil, true)
        printdb(true, "Setting properties for vehicle %s", vehicle)
    end
end)

AddStateBagChangeHandler('zutils:fuel', '', function(bagName, _, value)
    if not value then return end
    printdb(true, "Fuel state bag changed: %s %s", bagName, value)
    local vehicle = zutils.await(function()
        local vehicle = GetEntityFromStateBagName(bagName)
        if DoesEntityExist(vehicle) then
            return vehicle
        end
    end, nil, 10000, true)
    if not vehicle then return end
    
    if NetworkGetEntityOwner(vehicle) == PlayerId() then
        Entity(vehicle).state:set('zutils:fuel', nil, true)
        SetVehicleFuelLevel(vehicle, value)
        fuel.setFuel(vehicle, value)
        printdb(true, "Setting fuel for vehicle %s to %s", vehicle, value)
    end
end)

function zutils.GetVehicleType(model)
    model = zutils.joaat(model)
    if not IsModelInCdimage(model) then
        printerr("Model not found in CD image:", model)
    end

    if MISMATCHED_VEHICLE_TYPES[model] then
        return MISMATCHED_VEHICLE_TYPES[model]
    end

    local vehicleType = GetVehicleClassFromName(model)
    return VEHICLE_TYPES[vehicleType] or "automobile"
end

zutils.callback.register("zero_utils:client:GetVehicleType", zutils.GetVehicleType)
