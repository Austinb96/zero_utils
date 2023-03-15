function MultiplyVec3Vec2(v1, v2, YbyX)
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
    return vector3(vec3.x * vec2.x, vec3.y * y_multiplier, vec3.z)
end