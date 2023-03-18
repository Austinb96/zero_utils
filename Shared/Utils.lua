Utils = {}

function MultiplyVec3Vec2(v1, v2, YbyX, ZbyY)
    YbyX = YbyX or false
    local v1_is_vec3 = type(v1) == "vector3"
    local v2_is_vec3 = type(v2) == "vector3"
    local v1_is_vec2 = type(v1) == "vector2"
    local v2_is_vec2 = type(v2) == "vector2"
    local vec3, vec2

    if v1_is_vec3 and v2_is_vec2 then vec3,vec2 = v1,v2
    elseif v1_is_vec2 and v2_is_vec3 then vec3,vec2 = v2,v1
    elseif (v1_is_vec3 and v2_is_vec3) or (v1_is_vec2 and v2_is_vec2) then return v1*v2
    else PrintUtils.PrintError("Trying to Multiply non-V3V2 Vectors: " .. tostring(v1) .. " " .. tostring(v2)) return nil end

    local y_multiplier = YbyX and vec2.x or vec2.y
    local z_multiplier = ZbyY and vec2.y or 1
    return vector3(vec3.x * vec2.x, vec3.y * y_multiplier, vec3.z * z_multiplier)
end

local function GetForwardVector(heading)
    local radians = math.rad(heading)
    local forwardVector = vector3(-math.sin(radians),math.cos(radians),0)
    return forwardVector
end

function Utils.GetEntityForwardVector(entity)
    local heading = GetEntityHeading(entity)
    return GetForwardVector(heading)
end

function Utils.GetEntityRightVector(entity)
    local heading = GetEntityHeading(entity)
    return GetForwardVector(heading-90)
end


function Utils.GetEntityCoordsWithOffset(entity, offset)
    offset = offset or vector3(0,0,0)
    local entityPos = GetEntityCoords(entity)
    local forwardVector = Utils.GetEntityForwardVector(entity)
    local rightVector = Utils.GetEntityRightVector(entity)
    local pos = entityPos + ((forwardVector * offset.y) + (rightVector * offset.x) + vector3(0, 0, offset.z))
    local entityHeading = GetEntityHeading(entity)
    local coords = vector4(pos.x, pos.y, pos.z, entityHeading)
    return coords
end




