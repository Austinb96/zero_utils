zutils.vector = {}

function zutils.vector.getForwardVectorFromRotation(rot, isRad)
    local z = isRad and rot.z or math.rad(rot.z)
    return vector3(-math.sin(z), math.cos(z), rot.z)
end

function zutils.vector.getForwardVectorFromEntity(entity)
    local rot = GetEntityRotation(entity)
    return zutils.vector.getForwardVectorFromRotation(rot)
end

function zutils.vector.findClosest(v1, vectors)
    local closest = nil
    local closest_dist = math.huge
    for _, v2 in pairs(vectors) do
        local dist = #(v1 - v2)
        if dist < closest_dist then
            closest = v2
            closest_dist = dist
        end
    end
    
    return closest
end

return zutils.vector
