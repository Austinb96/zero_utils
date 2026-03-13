local peds = {}
zutils.ped = {}
function zutils.ped.createPed(model, coords, options, pedId)
    if not coords and not options.vehicle then return printerr("coords not defined") end
    coords = (not options.vehicle) and vector4(coords.x, coords.y, coords.z, coords.w or options.heading or 0)
    options = options or {}
    model = zutils.joaat(model)
    local id = pedId or zutils.uuid()
    if not peds[id] then
        peds[id] = {}
    end
    peds[id].id = id
    if (options.distance or options.usePoint)
        and not peds[id].pointID
        and not options.networked
        and not options.vehicle
    then
        options.distance = options.distance or 100.0
        options.usePoint = options.usePoint or true
        local pointID = zutils.points.addPoint(coords, {
            distance = options.distance,
            onEnter = function()
                if DoesEntityExist(peds[id].ped) then return end
                local newped = zutils.ped.createPed(model, coords, options, id)
                if options.onSpawn then options.onSpawn(newped, id) end
            end,
            onExit = function()
                local ped = peds[id]
                if not ped then printwarn("ped(%s) id:(%s) was did not exist on exit", ped.ped, id) return end
                if DoesEntityExist(ped.ped) then
                    DeleteEntity(ped.ped)
                    for prop, _ in pairs(peds[id].props or {}) do
                        zutils.prop.deleteProp(prop)
                    end
                    if options.onDespawn then options.onDespawn() end
                    printdb("ped(%s) with id: %s despawend", ped.ped, id)
                end
            end,
            onRemove = function()
                local ped = peds[id]
                if not ped then return end
                for prop, _ in pairs(peds[id].props or {}) do
                    zutils.prop.deleteProp(prop)
                end
                if DoesEntityExist(ped.ped) then
                    DeleteEntity(ped.ped)
                    if options.onDespawn then options.onDespawn() end
                    printdb("ped(%s) with id:(%s) removed", ped.ped, id)
                end
            end
        })
        peds[id].pointID = pointID
        return
    end

    printdb("Creating ped %s at %s", model, coords)
    zutils.loadModel(model)
    local ped
    if options.vehicle then
        if not DoesEntityExist(options.vehicle.entity) then
            printerr("Vehicle does not exist for ped %s", id)
            return false, "vehicle did not exist"
        end
        ped = CreatePedInsideVehicle(options.vehicle.entity, options.pedtype or 26, model, options.vehicle.seat, true,
            true)
    else
        if not coords then
            printerr("No coords provided for ped %s", id)
        end

        local networked = false
        if options.networked ~= nil then
            networked = options.networked
        end

        ped = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w or 0, networked, networked)

        if not options.ignoreGroundCheck then
            local ground_coords = zutils.getGroundAt(coords)
            SetEntityCoords(ped, ground_coords.x, ground_coords.y, ground_coords.z, false, false, false, false)
        end
    end
    peds[id].ped = ped
    if options.freeze then
        FreezeEntityPosition(ped, true)
    end

    if options.targetOptions then
        zutils.target.addEntityTarget(ped, options.targetOptions)
    end

    if options.scenario then
        TaskStartScenarioInPlace(ped, options.scenario, 0, true)
    end
    
    if options.noCollision then
        SetEntityNoCollisionEntity(ped, PlayerPedId(), true)
    end
    if options.blockEvent then
        SetBlockingOfNonTemporaryEvents(ped, true)
    end

    if options.flags then
        for flag, active in pairs(options.flags) do
            local flag_num = tonumber(flag)
            if flag_num then
                SetPedConfigFlag(ped, flag_num, active)
            end
        end
    end

    if options.weapon then
        options.weapon = {
            model = zutils.joaat(options.weapon.model),
            sideWeaponModel = options.weapon.sideWeaponModel and zutils.joaat(options.weapon.sideWeaponModel) or nil,
            ammoCapacity = options.weapon.ammoCapacity or 100,
            hidden = options.weapon.hidden or false,
            forceInHand = options.weapon.forceInHand ~= false,
            canSwap = options.weapon.canSwap ~= false,
            dropWeapon = options.weapon.dropWeapon == true,
            accuracy = options.weapon.accuracy,
            infiniteAmmo = options.weapon.infiniteAmmo or false,
        }

        GiveWeaponToPed(ped, options.weapon.model, options.weapon.ammoCapacity, false, false)
        if options.weapon.sideWeaponModel then
            GiveWeaponToPed(ped, options.weapon.sideWeaponModel, options.weapon.ammoCapacity, options.weapon.hidden,
                options.weapon.forceInHand)
            SetPedInfiniteAmmo(ped, options.weapon.infiniteAmmo, options.weapon.sideWeaponModel)
            SetPedAmmo(ped, options.weapon.sideWeaponModel, options.weapon.ammoCapacity)
        end
        SetCurrentPedWeapon(ped, options.weapon.model, true)
        SetPedCanSwitchWeapon(ped, options.weapon.canSwap)
        SetPedDropsWeaponsWhenDead(ped, options.weapon.dropWeapon)
        SetPedAmmo(ped, options.weapon.model, options.weapon.ammoCapacity)
        SetPedInfiniteAmmo(ped, options.weapon.infiniteAmmo, options.weapon.model)
        if options.weapon.accuracy then
            SetPedAccuracy(ped, options.weapon.accuracy)
        end
    end

    if options.canSufferCrits ~= nil then
        SetPedSuffersCriticalHits(ped, options.canSufferCrits)
    end

    if options.relationshipGroup then
        SetPedRelationshipGroupHash(ped, zutils.joaat(options.relationshipGroup))
    end

    if options.canRagdoll ~= nil then
        SetPedCanRagdoll(ped, options.canRagdoll)
    end

    if options.health then
        SetEntityHealth(ped, options.health)
    end

    if options.armor then
        SetPedArmour(ped, options.armor)
    end

    if options.flee ~= nil then
        SetPedFleeAttributes(ped, 0, options.flee)
    end
    
    if options.variations then
        zutils.ped.setVariations(ped, options.variations)
    end
    
    if options.scale then
        if type(options.scale) == "number" then 
            options.scale = {
                options.scale,
                options.scale
            }
        end
        zutils.ped.setScale(ped, options.scale[1], options.scale[2])
    end
    
    if options.props then
        for prop, prop_options in pairs(options.props) do
            local prop_id = zutils.prop.createEntityProp(ped, prop, prop_options.bone, prop_options.offset, prop_options.rotation, true)
            if not peds[id].props then peds[id].props = {} end
            peds[id].props[prop_id] = true
        end
    end
    
    if options.anim then
        zutils.animation.playAnim(ped, options.anim.dict, options.anim.anim, options.anim.options)
    end

    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, options.invincible or false)
    SetPedCanLosePropsOnDamage(ped, false, 0)

    if options.onSpawn then options.onSpawn(ped, id) end
    printdb("ped(%s) spawned with id:(%s)", ped, id)
    SetModelAsNoLongerNeeded(model)
    return ped, id
end

local function getPedByEntity(ped)
    for id, data in pairs(peds) do
        if data.ped == ped then
            return data
        end
    end
    return nil
end

function zutils.ped.removePed(pedid)
    local ped = peds[pedid] or getPedByEntity(pedid)
    if not ped then
        printerr("Ped not found for id:(%s)", pedid)
        return
    end
    if ped.pointID then
        zutils.points.removePoint(ped.pointID)
    else
        if DoesEntityExist(ped.ped) then
            DeleteEntity(ped.ped)
        end
    end
    peds[pedid] = nil
end
zutils.ped.RemovePed = zutils.ped.removePed

function zutils.ped.turnTo(ped, target, duration)
    if not DoesEntityExist(ped) then return false, "ped does not exist" end
    local targetCoords
    if type(target) == "vector3" then
        targetCoords = target
    elseif type(target) == "number" then
        if not DoesEntityExist(target) then return false, "target entity does not exist" end
        targetCoords = GetEntityCoords(target)
    end

    TaskTurnPedToFaceCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, duration or -1)

    while not IsPedHeadingTowardsPosition(ped, targetCoords.x, targetCoords.y, targetCoords.z, 20.0) do
        Wait(100)
    end
    Wait(100)
    ClearPedTasks(ped)
    return true
end

local FACE_FEATURE = {
    noseWidth = 0,              -- Nose Width (Thin/Wide)
    nosePeak = 1,               -- Nose Peak (Up/Down)
    noseLength = 2,             -- Nose Length (Long/Short)
    noseBoneCurveness = 3,      -- Nose Bone Curveness (Crooked/Curved)
    noseTip = 4,                -- Nose Tip (Up/Down)
    noseBoneTwist = 5,          -- Nose Bone Twist (Left/Right)
    eyebrowHeight = 6,          -- Eyebrow (Up/Down)
    eyebrowForward = 7,         -- Eyebrow (In/Out)
    cheekBones = 8,             -- Cheek Bones (Up/Down)
    cheekSideways = 9,          -- Cheek Sideways Bone Size (In/Out)
    cheekWidth = 10,            -- Cheek Bones Width (Puffed/Gaunt)
    eyeOpening = 11,            -- Eye Opening (Both) (Wide/Squinted)
    lipThickness = 12,          -- Lip Thickness (Both) (Fat/Thin)
    jawBoneWidth = 13,          -- Jaw Bone Width (Narrow/Wide)
    jawBoneShape = 14,          -- Jaw Bone Shape (Round/Square)
    chinBone = 15,              -- Chin Bone (Up/Down)
    chinBoneLength = 16,        -- Chin Bone Length (In/Out or Backward/Forward)
    chinBoneShape = 17,         -- Chin Bone Shape (Pointed/Square)
    chinHole = 18,              -- Chin Hole (Chin Bum)
    neckThickness = 19,         -- Neck Thickness
}

local HEAD_OVERLAY = {
    blemishes = 0,          -- Blemishes (0-23, 255 to disable)
    facialHair = 1,         -- Facial Hair (0-28, 255 to disable)
    eyebrows = 2,           -- Eyebrows (0-33, 255 to disable)
    ageing = 3,             -- Ageing (0-14, 255 to disable)
    makeup = 4,             -- Makeup (0-74, 255 to disable)
    blush = 5,              -- Blush (0-6, 255 to disable)
    complexion = 6,         -- Complexion (0-11, 255 to disable)
    sunDamage = 7,          -- Sun Damage (0-10, 255 to disable)
    lipstick = 8,           -- Lipstick (0-9, 255 to disable)
    molesFreckles = 9,      -- Moles/Freckles (0-17, 255 to disable)
    chestHair = 10,         -- Chest Hair (0-16, 255 to disable)
    bodyBlemishes = 11,     -- Body Blemishes (0-11, 255 to disable)
    addBodyBlemishes = 12,  -- Add Body Blemishes (0-1, 255 to disable)
}

function zutils.ped.setVariations(ped, data)
    if not DoesEntityExist(ped) then 
        return false, "ped does not exist"
    end
    if data.components then
        for componentId, component in pairs(data.components) do
            if type(component) == "table" then
                SetPedComponentVariation(ped, componentId, component.drawable or 0, component.texture or 0, component.palette or 0)
            elseif type(component) == "number" then
                SetPedComponentVariation(ped, componentId, component, 0, 0)
            end
        end
    end
    
    if data.props then
        for propId, prop in pairs(data.props) do
            if type(prop) == "table" then
                if prop.clear then
                    ClearPedProp(ped, propId)
                else
                    SetPedPropIndex(ped, propId, prop.drawable or 0, prop.texture or 0, true)
                end
            else
                SetPedPropIndex(ped, propId, prop, 0, true)
            end
        end
    end
    
    if data.headBlend then
        SetPedHeadBlendData(ped, 
            data.headBlend.shapeFirst or 0,
            data.headBlend.shapeSecond or 0,
            data.headBlend.shapeThird or 0,
            data.headBlend.skinFirst or 0,
            data.headBlend.skinSecond or 0,
            data.headBlend.skinThird or 0,
            data.headBlend.shapeMix or 0.0,
            data.headBlend.skinMix or 0.0,
            data.headBlend.thirdMix or 0.0
        )
    end
    
    if data.headOverlays then
        for overlayId, overlay in pairs(data.headOverlays) do
            overlayId = type(overlayId) == "string" and HEAD_OVERLAY[overlayId] or overlayId
            if type(overlay) == "table" then
                SetPedHeadOverlay(ped, overlayId, overlay.index or 0, overlay.opacity or 1.0)
                if overlay.color then
                    SetPedHeadOverlayColor(ped, overlayId, overlay.colorType or 0, overlay.color or 0, overlay.secondColor or 0)
                end
            end
        end
    end
    
    if data.faceFeatures then
        for featureId, scale in pairs(data.faceFeatures) do
            featureId = type(featureId) == "string" and FACE_FEATURE[featureId] or featureId
            SetPedFaceFeature(ped, featureId, scale or 0.0)
        end
    end
    
    if data.hair.style then
        SetPedComponentVariation(ped, 2, data.hair.style, data.hair.texture or 0, data.hair.palette or 2)
    end
    
    if data.hair.color then
        SetPedHairColor(ped, data.hair.color, data.hair.highlight or 0)
    end
    
    if data.eyeColor then
        SetPedEyeColor(ped, data.eyeColor)
    end
    
    return true
end

function zutils.ped.setScale(ped, scale_width, scale_height)
    if not DoesEntityExist(ped) then return false end
    if IsPedInAnyVehicle(ped, false) then return false end
    
    scale_height = scale_height or scale_width
    scale_width = scale_width or 1.0
    
    local forward, right, up_vector, position = GetEntityMatrix(ped)
    
    local function normalize(vec)
        local length = math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z)
        return vector3(vec.x / length, vec.y / length, vec.z / length)
    end
    
    local forward_norm = normalize(forward) * scale_width
    local right_norm = normalize(right) * scale_width
    local up_norm = normalize(up_vector) * scale_height
    
    local entity_speed = GetEntitySpeed(ped)
    local entity_height_above_ground = GetEntityHeightAboveGround(ped)
    local adjusted_z = (entity_speed <= 0 and entity_height_above_ground < 2) 
        and (entity_height_above_ground - scale_height) 
        or (GetEntityUprightValue(ped) - scale_height)
    
    SetEntityMatrix(ped,
        forward_norm.x, forward_norm.y, forward_norm.z,
        right_norm.x, right_norm.y, right_norm.z,
        up_norm.x, up_norm.y, up_norm.z,
        position.x, position.y, position.z - adjusted_z
    )
    
    return true
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for _, data in pairs(peds) do
            if DoesEntityExist(data.ped) then
                DeleteEntity(data.ped)
            end
        end
    end
end)

return zutils.ped
