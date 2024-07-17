local inPlaceingMode = false

local function placeVeh(model, coords, options)
    printdb("Placing Veh func %s %s %s %s", model, coords, options)
    local netid = zutils.callback.await("zero_utils:server:spawnVehicle", nil, model, coords, options.props, options)
    if not netid then
        PrintUtils.PrintError("Failed to create vehicle")
        return
    end
    local veh = AwaitEntityFromNetId(netid)
    if options.props then
        AwaitNetOwnership(netid)
        lib.setVehicleProperties(veh, options.props)
    end
    if options.targetOptions then
        if options.targetOptions.sync then
            local options = options.targetOptions.options or options.targetOptions[1]
            for i = 1, #options do
                if options[i].onSelect or options[i].action then
                    DeleteEntity(veh)
                    printerr("onSelect(action) is not supported in sync mode")
                end
            end
            TriggerServerEvent("zero_utils:server:syncTargets", netid, options.targetOptions)
        else
            zutils.target.AddNetIDTarget(netid, options.targetOptions)
        end
    end
    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(veh, true, true)
    return veh, netid
end

local placeingVeh
function zutils.placeVeh(model, options)
    Assert(model, "string")
    Assert(options, "table")
    if options.spawnAt then
        local coords = options.spawnAt
        local veh, netid = placeVeh(model, coords, options)
        if options.onPlace then
            options.onPlace(veh, netid)
        end
        return
    end
    options.maxDist = options.maxDist or 10.0
    if inPlaceingMode then return end
    inPlaceingMode = true
    local ped = PlayerPedId()
    LoadModel(model)
    placeingVeh = CreateVehicle(model, GetEntityCoords(ped), 0, false, false)
    if options.props then
        lib.setVehicleProperties(placeingVeh, options.props)
    end
    if options.color then
        SetVehicleColourCombination(placeingVeh, options.color)
    end
    UnloadModel(model)
    if not DoesEntityExist(placeingVeh) then
        inPlaceingMode = false
        printerr("Failed to create Veh %s", model)
        return
    end
    SetEntityAlpha(placeingVeh, 150, false)
    SetEntityCollision(placeingVeh, false, false)
    SetEntityDrawOutlineColor(255, 50, 50, 200) -- set color
    SetEntityDrawOutlineShader(1)                -- set shader
    SetEntityDrawOutline(placeingVeh, false)

    local outOfRange = false
    local zOffset = 0.3
    local raycastWorldOnly = true
    local rayDist = clamp(8.0,options.maxDist * 2 , 100.0)
    local heading = GetEntityHeading(ped) - 90
    local isBoat = IsThisModelABoat(model)
    CreateThread(function()
        while inPlaceingMode do
            Wait(0)
            local hit, coords, entityHit = RayCastFromPlayCam(rayDist, placeingVeh, raycastWorldOnly, isBoat)
            
            if hit then
                outOfRange = false
                SetEntityCoords(placeingVeh, coords.x, coords.y, coords.z , false, false, false, false)
                SetVehicleOnGroundProperly(placeingVeh)
                FreezeEntityPosition(placeingVeh, true)
                SetEntityHeading(placeingVeh, heading)
                if options.onCheckPoint then
                    local result = options.onCheckPoint(coords)
                    if not result then
                        SetEntityDrawOutline(placeingVeh, true)
                        outOfRange = true
                    end
                end
                if (not outOfRange) and options.maxDist then
                        local dist = #(GetEntityCoords(ped) - coords)
                        if dist > options.maxDist then
                            SetEntityDrawOutline(placeingVeh, true)
                            outOfRange = true
                        elseif dist <= options.maxDist then
                            SetEntityDrawOutline(placeingVeh, false)
                            outOfRange = false
                        end
                end
            end
            
            Draw2DText('[E] Place\n[Scroll Up/Down] Rotate\n', 4, {255, 255, 255}, 0.4, 0.85, 0.85)
            Draw2DText('[Right Click / Backspace] Exit place mode', 4, {255, 255, 255}, 0.4, 0.85, 0.945)
            
            if not outOfRange and IsControlJustReleased(0, 38) then
                inPlaceingMode = false

                local heading = GetEntityHeading(placeingVeh)

                DeleteEntity(placeingVeh)
                local veh, netid = placeVeh(model, vector4(coords.x, coords.y, coords.z + zOffset, heading), options)
                if options.onPlace then
                    options.onPlace(veh, netid)
                end
            end

            if IsControlJustReleased(0, 241) and not IsControlPressed(0, 21) then
                heading += 10
            end

            if IsControlJustReleased(0, 242) and not IsControlPressed(0, 21) then
                heading -= 10
            end

            if IsControlJustReleased(0, 177) then
                inPlaceingMode = false
                DeleteEntity(placeingVeh)
            end
        end
    end)
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if inPlaceingMode then
        DeleteEntity(placeingVeh)
        inPlaceingMode = false
    end
end)

return zutils.placeVeh