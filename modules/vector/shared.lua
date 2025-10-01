zutils.vector = {}

function zutils.vector.getForwardVectorFromRotation(rot, isRad)
    local z = isRad and rot.z or math.rad(rot.z)
    return vector3(-math.sin(z), math.cos(z), rot.z)
end

function zutils.vector.getForwardVectorFromEntity(entity)
    local rot = GetEntityRotation(entity)
    return zutils.math.getForwardVectorFromRotation(rot)
end

return zutils.vector
