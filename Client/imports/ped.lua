local peds = {}
zutils.ped = {}
function zutils.ped.createPed(model, coords, options, pedId)
    options = options or {}
    model = type(model) == 'string' and GetHashKey(model) or model
    Assert(model,"number")
    Assert(coords, {"vector3", "vector4"})
    LoadModel(model)
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w or 0, false, false)
    local id = pedId or #peds + 1
    if not peds[id] then
        peds[id] = {}
    end
    peds[id].id = id
    peds[id].ped = ped
    if options.freeze then
        FreezeEntityPosition(ped, true)
    end
    
    if options.targetOptions then
        zutils.target.AddEntityTarget(ped, options.targetOptions)
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
    
    if not options.igoreGroundCheck then
        SetEntityCoords(ped, GetGroundAt(coords))
    end
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    SetPedCanLosePropsOnDamage(ped, false, 0)
    
    if (options.distance or options.usePoint) and not peds[id].pointID then
        local pointID = zutils.Points.AddPoint(coords, {
            distance = options.distance or 150.0,
            onEnter = function()
                if DoesEntityExist(peds[id].ped) then return end
                local newped = zutils.ped.createPed(model, coords, options, id)
                if options.onSpawn then options.onSpawn(newped, id) end
            end,
            onExit = function()
                if DoesEntityExist(peds[id].ped) then
                    DeleteEntity(peds[id].ped)
                    if options.onDespawn then options.onDespawn() end
                end
            end
        })
        peds[id].pointID = pointID
    end
    if options.onSpawn then options.onSpawn(ped, id) end
    UnloadModel(model)
    return ped, id
end

function zutils.ped.RemovePed(pedid)
    local ped = peds[pedid]
    if not ped then printerr("Ped not found for id %s", pedid) return end
    if DoesEntityExist(ped.ped) then
        DeleteEntity(ped.ped)
    end
    if ped.pointID then
        zutils.Points.RemovePoint(ped.pointID)
    end
    peds[pedid] = nil
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
