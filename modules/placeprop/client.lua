--TODO DEPRICATE AND MOVE TO PROPlocal inPlaceingMode = false
local animDict = "pickup_object"
local anim = "pickup_low"

local function placeProp(item, coords, heading, snapToGround, options)
    local playerPed = PlayerPedId()
    TurnPedToCoords(playerPed, coords)
    options.anim = options.anim or {
        dict = animDict,
        anim = anim,
    }
    options.placeAnim = options.placeAnim or options.anim
    local function finish()
        local obj = CreateObject(item, coords, true, true)
        if not DoesEntityExist(obj) then
            PrintUtils.PrintError("Failed to create object %s", item)
            return
        end
        local netid = NetworkGetNetworkIdFromEntity(obj)
        SetEntityCoords(obj, coords)
        if options.propAnim then
            LoadAnim(options.propAnim.dict)
            PlayEntityAnim(obj, options.propAnim.anim, options.propAnim.dict, 1000.0, false, true, false, 0.0, 0)
            RemoveAnimDict(options.propAnim.dict)
        end
        SetEntityAlpha(obj, 255, false)
        SetEntityCollision(obj, true, true)
        SetEntityHeading(obj, heading)
        SetEntityAsMissionEntity(obj, true, true)
        if options.freeze then
            FreezeEntityPosition(obj, true)
        end
        if options.snapToGround or snapToGround then
            PlaceObjectOnGroundProperly(obj)
        end
        if options.target?.targetoptions or options.item then
            printdb("Adding target for %s", netid)
            TriggerServerEvent("zutils:server:makePropTarget", netid, options)
        end

        if options.onPlace then
            options.onPlace(obj, netid)
        end
        TriggerServerEvent("zutils:server:ItemSpawned", netid, options)
    end
    if options.progressbar then
        options.progressbar = options.progressbar or {}
        options.progressbar.label = options.progressbar.label or "Placing item"
        options.progressbar.time = options.progressbar.time or 1000
        zutils.progressBar("place_item", options.progressbar.label, options.progressbar.time, {
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = options.placeAnim.dict,
                anim = options.placeAnim.anim,
                flags = options.placeAnim.flag or 49,
            },
            onFinish = finish,
            onCancel = function()
                inPlaceingMode = false
            end,
        })
    else
        LoadAnim(options.placeAnim.dict)
        TaskPlayAnim(playerPed, options.placeAnim.dict, options.placeAnim.anim, options.placeAnim.BlendInSpeed or 8.0, options.placeAnim.BlendOutSpeed or 8.0, options.placeAnim.duration or 1.0, options.placeAnim.flag or 0, 0, false, false, false)
        WaitForAnim(playerPed, options.placeAnim.dict, options.placeAnim.anim)
        SetAnimRate(playerPed, 3.0, 1.0, false)
        RemoveAnimDict(options.placeAnim.dict)
        finish()
    end
end

local placeingObj
function zutils.placeProp(prop, options)
    printdb("Start Placing Item: %s", prop)
    Assert(prop, { "string", "number" })
    Assert(options, "table")
    if options.item then
        if type(options.item) == "string" then
            options.item = { name = options.item }
        end
        if not zutils.inventory.hasItem(options.item.name, 1, options.item.metadata, options.item.slot) then
            return zutils.notify("error", "Item not found in inventory")
        end
    end
    options.maxDist = options.maxDist or 10.0
    if inPlaceingMode then return end
    inPlaceingMode = true
    local ped = PlayerPedId()

    placeingObj = CreateObject(prop, GetEntityCoords(ped), false, false)
    if not DoesEntityExist(placeingObj) then
        PrintUtils.PrintError("Failed to create object %s", prop)
        return
    end
    SetEntityAlpha(placeingObj, 150, false)
    SetEntityCollision(placeingObj, false, false)
    SetEntityDrawOutlineColor(255, 50, 50, 200) -- set color
    SetEntityDrawOutlineShader(1)               -- set shader
    SetEntityDrawOutline(placeingObj, false)

    local outOfRange = false
    local zOffset = 0
    local raycastWorldOnly = true
    local rayDist = clamp(10.0, options.maxDist * 2, 100.0)
    local lastCoords = GetEntityCoords(ped)
    CreateThread(function()
        while inPlaceingMode do
            Wait(0)
            DisablePlayerFiring(ped, true)

            if options.lockHeading then
                local pedHeading = GetEntityHeading(ped)
                local heading = GetGameplayCamRelativeHeading()
                local initialHeading = pedHeading + heading
                SetEntityRotation(placeingObj, 0.0, 0.0, initialHeading, 2, true)
            end
            local hit, coords = RayCastFromPlayCam(rayDist, placeingObj, raycastWorldOnly)

            if hit and #(lastCoords - coords) > 0.02 then
                lastCoords = coords
                SetEntityCoords(placeingObj, coords.x, coords.y, coords.z + zOffset)
                if options.lockHeading then
                    local dist = #(GetEntityCoords(ped) - coords)
                    if (not outOfRange) and dist > options.maxDist then
                        SetEntityDrawOutline(placeingObj, true)
                        outOfRange = true
                    elseif outOfRange and dist <= options.maxDist then
                        SetEntityDrawOutline(placeingObj, false)
                        outOfRange = false
                    end
                end
                if options.snapToGround then
                    PlaceObjectOnGroundProperly(placeingObj)
                end
            end

            Draw2DText(
                '[E] Place\n[Shift+E] Place on ground\n[Scroll Up/Down] Rotate\n[Shift+Scroll Up/Down] Raise/lower', 4,
                { 255, 255, 255 }, 0.4, 0.85, 0.85)
            Draw2DText('[Scroll Click] Change mode\n[Right Click / Backspace] Exit place mode', 4, { 255, 255, 255 }, 0.4,
                0.85, 0.945)

            if not outOfRange and IsControlJustReleased(0, 38) and IsControlPressed(0, 21) then
                inPlaceingMode = false

                local objHeading = GetEntityHeading(placeingObj)
                local snapToGround = true

                DeleteEntity(placeingObj)
                placeProp(prop, vector3(coords.x, coords.y, coords.z + zOffset), objHeading, snapToGround, options)
            elseif not outOfRange and IsControlJustReleased(0, 38) then
                inPlaceingMode = false

                local objHeading = GetEntityHeading(placeingObj)
                local snapToGround = false

                DeleteEntity(placeingObj)
                placeProp(prop, vector3(coords.x, coords.y, coords.z + zOffset), objHeading, snapToGround, options)
            end
            if not options.lockHeading then
                if IsControlJustReleased(0, 241) and not IsControlPressed(0, 21) then
                    local objHeading = GetEntityHeading(placeingObj)
                    SetEntityRotation(placeingObj, 0.0, 0.0, objHeading + 10, false, false)
                end

                if IsControlJustReleased(0, 242) and not IsControlPressed(0, 21) then
                    local objHeading = GetEntityHeading(placeingObj)
                    SetEntityRotation(placeingObj, 0.0, 0.0, objHeading - 10, false, false)
                end
            end

            if IsControlPressed(0, 21) and IsControlJustReleased(0, 241) then
                zOffset = zOffset + 0.1
                if zOffset > 1.0 then
                    zOffset = 1.0
                end
            end

            if IsControlPressed(0, 21) and IsControlJustReleased(0, 242) then
                zOffset = zOffset - 0.1
                if zOffset < -1.0 then
                    zOffset = -1.0
                end
            end

            if IsControlJustReleased(0, 348) then
                raycastWorldOnly = not raycastWorldOnly
            end

            if IsControlJustReleased(0, 177) then
                inPlaceingMode = false
                DeleteEntity(placeingObj)
            end
        end
    end)
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if inPlaceingMode then
        DeleteEntity(placeingObj)
        inPlaceingMode = false
    end
end)

return zutils.placeProp
