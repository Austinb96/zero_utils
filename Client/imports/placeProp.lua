local inPlaceingMode = false
local animDict = "pickup_object"
local anim = "pickup_low"

local function placeProp(item, coords, heading, snapToGround, options)
    options.progressbar = options.progressbar or {}
    options.progressbar.label = options.progressbar.label or "Placing item"
    options.progressbar.time = options.progressbar.time or 1000
    options.anim = options.anim or {
        dict = animDict,
        anim = anim,
    }

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
            animDict = options.anim.dict,
            anim = options.anim.anim,
            flags = options.anim.flag or 49,
        },
        onFinish = function()
            local obj = CreateObject(item, coords, true, true)
            if not DoesEntityExist(obj) then
                PrintUtils.PrintError("Failed to create object %s", item)
                return
            end
            local netid = NetworkGetNetworkIdFromEntity(obj)
            SetEntityCoords(obj, coords)
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

            if options.onPlace then
                options.onPlace(obj, netid)
            end
            TriggerServerEvent("zutils:server:ItemSpawned", netid, options)
        end,
        onCancel = function()
            inPlaceingMode = false
        end,
    })
end

local placeingObj
function zutils.placeProp(item, options)
    printdb("Start Placing Item: %s", item)
    Assert(item, { "string", "number" })
    Assert(options, "table")
    options.maxDist = options.maxDist or 10.0
    if inPlaceingMode then return end
    inPlaceingMode = true
    local ped = PlayerPedId()

    placeingObj = CreateObject(item, GetEntityCoords(ped), false, false)
    if not DoesEntityExist(placeingObj) then
        PrintUtils.PrintError("Failed to create object %s", item)
        return
    end
    SetEntityAlpha(placeingObj, 150, false)
    SetEntityCollision(placeingObj, false, false)
    SetEntityDrawOutlineColor(255, 50, 50, 200) -- set color
    SetEntityDrawOutlineShader(1)               -- set shader
    SetEntityDrawOutline(placeingObj, false)

    local outOfRange = false
    local canPlace = true
    local zOffset = 0
    local raycastWorldOnly = true
    local rayDist = clamp(10.0, options.maxDist * 2, 100.0)
    local lastCoords = GetEntityCoords(ped)
    CreateThread(function()
        while inPlaceingMode do
            Wait(0)
            DisablePlayerFiring(ped, true)
            local hit, coords, entityHit = RayCastFromPlayCam(rayDist, placeingObj, raycastWorldOnly)
            if hit and #(lastCoords - coords) > 0.02 then
                lastCoords = coords
                SetEntityCoords(placeingObj, coords.x, coords.y, coords.z + zOffset)
                if options.maxDist then
                    local dist = #(GetEntityCoords(ped) - coords)
                    if (not outOfRange) and dist > options.maxDist then
                        SetEntityDrawOutline(placeingObj, true)
                        outOfRange = true
                        canPlace = false
                    elseif outOfRange and dist <= options.maxDist then
                        SetEntityDrawOutline(placeingObj, false)
                        outOfRange = false
                        canPlace = true
                    end
                end
                if options.canPlace then
                    canPlace = options.canPlace(coords, placeingObj)
                    if not canPlace then
                        SetEntityDrawOutline(placeingObj, true)
                    else
                        SetEntityDrawOutline(placeingObj, false)
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

            if canPlace and IsControlJustReleased(0, 38) and IsControlPressed(0, 21) then
                inPlaceingMode = false

                local objHeading = GetEntityHeading(placeingObj)
                local snapToGround = true

                DeleteEntity(placeingObj)
                placeProp(item, vector3(coords.x, coords.y, coords.z + zOffset), objHeading, snapToGround, options)
            elseif canPlace and IsControlJustReleased(0, 38) then
                inPlaceingMode = false

                local objHeading = GetEntityHeading(placeingObj)
                local snapToGround = false

                DeleteEntity(placeingObj)
                placeProp(item, vector3(coords.x, coords.y, coords.z + zOffset), objHeading, snapToGround, options)
            end

            if IsControlJustReleased(0, 241) and not IsControlPressed(0, 21) then
                local objHeading = GetEntityHeading(placeingObj)
                SetEntityRotation(placeingObj, 0.0, 0.0, objHeading + 10, false, false)
            end

            if IsControlJustReleased(0, 242) and not IsControlPressed(0, 21) then
                local objHeading = GetEntityHeading(placeingObj)
                SetEntityRotation(placeingObj, 0.0, 0.0, objHeading - 10, false, false)
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
