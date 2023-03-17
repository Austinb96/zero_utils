function GetEntityForwardVectorServer(entity, yIsOne)
    local rotation = GetEntityRotation(entity)
    local radians = math.rad(rotation.z)
    local forwardVector = vector3(-math.sin(radians),math.cos(radians),0)
    if yIsOne then forwardVector = vector3(forwardVector.x,forwardVector.y,1) end
    return forwardVector
end

function GetEntityCoordsWithOffset(entity, offset)
    offset = offset or vector2(0,0)
    local entityPos = GetEntityCoords(entity)
    local entityHeading = GetEntityHeading(entity)
    local forwardVector = GetEntityForwardVectorServer(entity, true)
    local movePos = (entityPos + MultiplyVec3Vec2(forwardVector, offset, true, true))
    local coords = vector4(movePos.x, movePos.y, movePos.z, entityHeading)
    return coords
end