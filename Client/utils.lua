local mismatchedTypes = {
    [`airtug`] = "automobile", -- trailer
    [`avisa`] = "submarine", -- boat
    [`blimp`] = "heli", -- plane
    [`blimp2`] = "heli", -- plane
    [`blimp3`] = "heli", -- plane
    [`caddy`] = "automobile", -- trailer
    [`caddy2`] = "automobile", -- trailer
    [`caddy3`] = "automobile", -- trailer
    [`chimera`] = "automobile", -- bike
    [`docktug`] = "automobile", -- trailer
    [`forklift`] = "automobile", -- trailer
    [`kosatka`] = "submarine", -- boat
    [`mower`] = "automobile", -- trailer
    [`policeb`] = "bike", -- automobile
    [`ripley`] = "automobile", -- trailer
    [`rrocket`] = "automobile", -- bike
    [`sadler`] = "automobile", -- trailer
    [`sadler2`] = "automobile", -- trailer
    [`scrap`] = "automobile", -- trailer
    [`slamtruck`] = "automobile", -- trailer
    [`Stryder`] = "automobile", -- bike
    [`submersible`] = "submarine", -- boat
    [`submersible2`] = "submarine", -- boat
    [`thruster`] = "heli", -- automobile
    [`towtruck`] = "automobile", -- trailer
    [`towtruck2`] = "automobile", -- trailer
    [`tractor`] = "automobile", -- trailer
    [`tractor2`] = "automobile", -- trailer
    [`tractor3`] = "automobile", -- trailer
    [`trailersmall2`] = "trailer", -- automobile
    [`utillitruck`] = "automobile", -- trailer
    [`utillitruck2`] = "automobile", -- trailer
    [`utillitruck3`] = "automobile", -- trailer
}

function GetVehicleTypeFromModelOrHash(model)
    model = type(model) == "string" and joaat(model) or model
    if not IsModelInCdimage(model) then
        return
    end
    if mismatchedTypes[model] then
        return mismatchedTypes[model]
    end

    local vehicleType = GetVehicleClassFromName(model)
    local types = {
        [8] = "bike",
        [11] = "trailer",
        [13] = "bike",
        [14] = "boat",
        [15] = "heli",
        [16] = "plane",
        [21] = "train",
    }

    return types[vehicleType] or "automobile"
end

function AwaitEntityFromNetId(netId)
    local timeout = 0
    while not NetworkDoesNetworkIdExist(netId) do
        timeout = timeout + 1
        if timeout > 100 then
            printerr("Failed to get entity from net id")
            return false
        end
        Wait(100)
    end
    local entity = NetworkGetEntityFromNetworkId(netId)
    while not entity do
        entity = NetworkGetEntityFromNetworkId(netId)
        timeout = timeout + 1
        if timeout > 100 then
            printerr("Failed to get entity from net id")
            return false
        end
        Wait(100)
    end
    return entity
end

function AwaitNetOwnership(netid)
    local timeout = 0
    while not NetworkDoesNetworkIdExist(netid) do
        timeout = timeout + 1
        if timeout > 100 then
            printerr("Failed to get entity from net id")
        end
        Wait(100)
    end
    while not NetworkHasControlOfNetworkId(netid) do
        NetworkRequestControlOfNetworkId(netid)
        timeout = timeout + 1
        if timeout > 100 then
            printerr("Failed to get control of net id")
        end
        Wait(100)
    end
end

function LoadModel(model)
    if type(model) == "string" then model = joaat(model) end
    Assert(model,"number")

    if not IsModelInCdimage(model) then
        printerr("Model %s not found in cdimage", model)
    end
    
    if HasModelLoaded(model) then
        return model
    end
    
    RequestModel(model)
    Await(function()
        return HasModelLoaded(model)
    end, {"Model Failed to Load %s", model}, 10000)
end

function UnloadModel(model)
    if HasModelLoaded(model) then
        SetModelAsNoLongerNeeded(model)
    end
end

function GetGroundAt(coords)
    SetFocusPosAndVel(coords.x, coords.y, coords.z)
    local _, z = GetGroundZExcludingObjectsFor_3dCoord(coords.x, coords.y, coords.z, false)
    ClearFocus()
    return vector3(coords.x, coords.y, z or coords.z)
end