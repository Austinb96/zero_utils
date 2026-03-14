local props = {}
zutils.prop = {}

local in_placing_mode = false
local active_raycast = nil

function zutils.prop.deleteProp(id)
    local prop = props[id] and props[id].prop or id
    if not prop then return printwarn("Prop %s does not exist", id) end
    if DoesEntityExist(prop) then
        DeleteEntity(prop)
        props[id] = nil
    else
        printwarn("Prop %s does not exist", id)
    end
end

function zutils.prop.createEntityProp(entity, model, bone, offset, rotation, client_side)
    offset = offset or vector3(0, 0, 0)
    rotation = rotation or vector3(0, 0, 0)
    model = zutils.joaat(model)
    local id = zutils.uuid()
    local networked = true
    if client_side then networked = false end
    local prop = CreateObject(model, 0, 0, 0, networked, networked, false)
    AttachEntityToEntity(prop, entity, GetPedBoneIndex(entity, bone), offset.x, offset.y, offset.z, rotation.x,
        rotation.y, rotation.z, true, true, false, true, 1, true)
    props[id] = {
        id = id,
        prop = prop
    }
    return id, prop
end

function zutils.prop.createProp(model, coords, options, pedID)
    options = options or {}
    local id = pedID or zutils.uuid()
    if not props[id] then
        props[id] = {}
    end
    props[id].id = id
    printdb("Prop %s coords: %s", id, coords)
    if options.distance
        and not props[id].pointID
    then
        local pointID = zutils.points.addPoint(coords, {
            distance = options.distance,
            onEnter = function()
                if DoesEntityExist(props[id].prop) then return end
                local newprop = zutils.prop.createProp(model, coords, options, id)
                if options.onSpawn then options.onSpawn(newprop, id) end
            end,
            onExit = function()
                if DoesEntityExist(props[id].prop) then
                    printdb("Prop %s despawned at %s", id, coords)
                    DeleteEntity(props[id].prop)
                    if options.onDespawn then options.onDespawn() end
                end
            end,
            onRemove = function()
                local prop = props[id]
                if not prop then return end
                if DoesEntityExist(prop.prop) then
                    DeleteEntity(prop.prop)
                    if options.onDespawn then options.onDespawn() end
                end
            end
        })

        props[id].pointID = pointID
        return
    end

    printdb("Creating prop %s at %s", model, coords)
    local result, err = zutils.loadModel(model, true)
    
    if err then
        return false, err
    end
    
    if options.placeOnGround then
        coords = zutils.getGroundAt(coords, false, true)
    end
    
    local prop = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)
    
    SetEntityHeading(prop, coords.w or 0)
    
    if not DoesEntityExist(prop) then
        return
    end

    if options.freeze then
        FreezeEntityPosition(prop, true)
    end

    if options.noCollision then
        SetEntityNoCollisionEntity(prop, PlayerPedId(), true)
    end
    
    if options.onSpawn then
        options.onSpawn(prop, id)
    end
    
    if options.targetOptions then
        zutils.target.addEntityTarget(prop, options.targetOptions)
    end

    SetModelAsNoLongerNeeded(model)

    props[id].prop = prop
    return prop, id
end

function zutils.prop.placeProp(prop, options)
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
    if in_placing_mode then return end
    in_placing_mode = true
    
    local raycastWorldOnly = options.raycastWorldOnly == nil and true or options.raycastWorldOnly
    
    local handPropId, handProp
    local ped = PlayerPedId()
    local propModel = zutils.joaat(prop)
    options.animation = options.animation or {}
    options.animation = {
        place = options.animation.place or {
            dict = "pickup_object",
            anim = "pickup_low"
        },
        carry = options.animation.carry or {
            dict = "anim@heists@box_carry@",
            anim = "idle"
        }
    }
    
    if propModel then
        local loaded, err = zutils.loadModel(prop, true)
        if loaded then
            handPropId, handProp = zutils.prop.createEntityProp(
                ped, 
                prop, 
                60309,
                options.handOffset or vector3(0.0, 0.0, 0.0),
                options.handRotation or vector3(-30.0, 0.0, 0.0)
            )
        elseif err then
            printwarn(err)
        end
        zutils.animation.playAnim(ped, options.animation.carry.dict, options.animation.carry.anim, {
            flags = 49
        })
    end
    
    active_raycast = zutils.raycast.create({
        fromPlayer = true,
        distance = options.maxDist * 2,
        flags = raycastWorldOnly and 1 or -1,
        autoStart = true,
        draw = true,
        marker = {
            prop = prop,
            distance = {
                distance = options.maxDist,
                outOfRange = vector4(255, 50, 50, 200),
                inRange = vector4(255, 255, 255, 150)
            },
            offset = vector3(0, 0, 0),
            alpha = 150,
            heading = GetGameplayCamRot(2).z,
        },
        controls = {
            currentRotation = GetGameplayCamRot(2).z,
            zOffset = 0,
            lockHeading = options.lockHeading,
            disableFiring = true,
            onConfirm = function()
                if not active_raycast then return end
                local result = active_raycast:result()
                ClearPedTasks(ped)
                if handPropId then
                    zutils.prop.deleteProp(handPropId)
                end
                
                if not result.outOfRange and result.markerCoords then
                    zutils.animation.playAnim(ped, options.animation.place.dict, options.animation.place.anim, {
                        flags = 64
                    })
                    Wait(300)
                    if not options.dontCreate then
                        zutils.prop.createProp(prop, result.markerCoords, options)
                    end
                    if options.onConfirm then
                        options.onConfirm(result.markerCoords)
                    end
                else
                    if options.onCancel then
                        options.onCancel()
                    end
                end
                
                in_placing_mode = false
                active_raycast:delete()
                active_raycast = nil
            end,
            onCancel = function()
                if handPropId then
                    zutils.prop.deleteProp(handPropId)
                end
                
                ClearPedTasks(ped)
                
                in_placing_mode = false
                if active_raycast then
                    active_raycast:delete()
                    active_raycast = nil
                end
                if options.onCancel then
                    options.onCancel()
                end
            end
        }
    })
    
    local prop_entity = active_raycast:getEntity()
    if prop_entity and DoesEntityExist(prop_entity) then
        SetEntityCollision(prop_entity, false, false)
        SetEntityCompletelyDisableCollision(prop_entity, false, false)
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, data in pairs(props) do
        if DoesEntityExist(data.prop) then
            printdb("Deleting prop %s", data.id)
            DeleteEntity(data.prop)
        else
            printdb("Prop(%s) %s does not exist, skipping deletion", data.prop, data.id)
        end
            
    end
    
    if in_placing_mode then
        in_placing_mode = false
        if active_raycast then
            active_raycast:delete()
            active_raycast = nil
        end
    end
end)

return zutils.prop
