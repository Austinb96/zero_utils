function GetPlayerData(src)
	if src and RequireServer() then
		ZeroUtils.AssertType(src, "number")
		return QBCore.Functions.GetPlayer(src).PlayerData
	elseif RequireClient() then
		return QBCore.Functions.GetPlayerData()
	end
end

function ZeroUtils.GetCitizenID(src)
	local playerData = GetPlayerData(src)
	if playerData.citizenid then
		PrintUtils.PrintDebug("CitizenId found: %s",playerData.citizenid)
		return playerData.citizenid
	else
		local playerName = GetPlayerName(src or -1)
		PrintUtils.PrintWarning("citizenId Not found! Giving Player name instead: %s",playerName)
		return playerName
	end
end

function  ZeroUtils.MultiplyVec3Vec2(v1, v2, YbyX, ZbyY)
    YbyX = YbyX or false
    local v1_is_vec3 = type(v1) == "vector3"
    local v2_is_vec3 = type(v2) == "vector3"
    local v1_is_vec2 = type(v1) == "vector2"
    local v2_is_vec2 = type(v2) == "vector2"
    local vec3, vec2

    if v1_is_vec3 and v2_is_vec2 then vec3,vec2 = v1,v2
    elseif v1_is_vec2 and v2_is_vec3 then vec3,vec2 = v2,v1
    elseif (v1_is_vec3 and v2_is_vec3) or (v1_is_vec2 and v2_is_vec2) then return v1*v2
    else PrintUtils.PrintError("Trying to Multiply non-V3V2 Vectors: %s - %s" , v1, v2) return nil end

    local y_multiplier = YbyX and vec2.x or vec2.y
    local z_multiplier = ZbyY and vec2.y or 1
    return vector3(vec3.x * vec2.x, vec3.y * y_multiplier, vec3.z * z_multiplier)
end

local function GetForwardVector(heading)
    local radians = math.rad(heading)
    local forwardVector = vector3(-math.sin(radians),math.cos(radians),0)
    return forwardVector
end

function ZeroUtils.GetEntityForwardVector(entity)
    local heading = GetEntityHeading(entity)
    return GetForwardVector(heading)
end

function ZeroUtils.GetEntityRightVector(entity)
    local heading = GetEntityHeading(entity)
    return GetForwardVector(heading-90)
end

function ZeroUtils.GetEntityDistance(entity1, entity2,offset,AsV3)
	local pos1 = GetEntityCoords(entity1)
	local pos2
	if offset then
		pos2 = ZeroUtils.GetEntityCoordsWithOffset(entity2, offset, true)
	else
		pos2 = GetEntityCoords(entity2)
	end


	if AsV3 then
		return pos1-pos2
	end
	return #(pos1 - pos2)
end

function ZeroUtils.GetEntityCoordsWithOffset(entity, offset, returnV3)
    offset = offset or vector3(0,0,0)
    local entityPos = GetEntityCoords(entity)
    local forwardVector = ZeroUtils.GetEntityForwardVector(entity)
    local rightVector = ZeroUtils.GetEntityRightVector(entity)
    local pos = entityPos + ((forwardVector * offset.y) + (rightVector * offset.x) + vector3(0, 0, offset.z))
	if returnV3 then
		return pos
	end

    local entityHeading = GetEntityHeading(entity)
    local coords = vector4(pos.x, pos.y, pos.z, entityHeading)
    return coords
end

function ZeroUtils.CheckEntityDistance(entity1, entity2, max,offset, dir)
	max = max or 0
	local distance = ZeroUtils.GetEntityDistance(entity1, entity2, offset)

	if not dir then
		return max > distance
	end

	if string.upper(dir) == "RIGHT" then
		local v3Distance = ZeroUtils.GetEntityDistance(entity1, entity2,offset, true)
		local entity2RightVector = ZeroUtils.GetEntityRightVector(entity2)
		local dotProduct = (v3Distance.x * entity2RightVector.x) + (v3Distance.y * entity2RightVector.y)
		return dotProduct > 0 and max > distance
	end
end

function ZeroUtils.LoadModel(model)
	if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

function ZeroUtils.AssertType(value, types)
    local valueType = type(value)
    if valueType == types then
        return
    end
    if type(types) == "table" then
        for _, v in ipairs(types) do
            if valueType == v then
                return
            end
        end
		types = table.concat(types, "/")
    end
    error(string.format("Expected %s, but got %s", types, valueType))
end

