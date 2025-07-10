local props = {}
zutils.prop = {}

function zutils.prop.deleteProp(id)
    if not id then return end
    local prop = props[id] or id
    if DoesEntityExist(prop) then
        DeleteEntity(prop)
    end
    
    if props[id] then
        props[id] = nil
    end
end

function zutils.prop.createEntityProp (entity, model, bone, offset, rotation)
    offset = offset or vector3(0, 0, 0)
    rotation = rotation or vector3(0, 0, 0)
    model = zutils.joaat(model)
    local id = zutils.uuid()
    local prop = CreateObject(model, 0, 0, 0, true, true, false)
    AttachEntityToEntity(prop, entity, GetPedBoneIndex(entity, bone), offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, true, true, false, true, 1, true)
    props[id] = prop
    return id, prop
end

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end        
    for id, prop in pairs(props) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
end)

return zutils.prop
