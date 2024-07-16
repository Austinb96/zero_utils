function Assert(item, checkType)
    if type(checkType) == "table" then
        for _, check in ipairs(checkType) do
            if type(item) == check then return end
        end
        PrintUtils.PrintError("Expected %s, got %s", table.concat(checkType, " or "), type(item))
    else
        if type(item) ~= checkType then PrintUtils.PrintError("Expected %s, got %s", checkType, type(item)) end
    end
end

function Await(fn, errmsg, timeout)
    timeout = timeout or 10000
    local start = GetGameTimer()
    while not fn() do
        if GetGameTimer() - start > timeout then
            printerr(errmsg[1] or errmsg or "Await timed out", errmsg[2])
        end
        Wait(0)
    end
    return true
end

function AssertBridgeResource(config, check, resource)
    if config then
        printdb("AssertBridgeResource(%s, %s, %s)", config, check, resource)
        if not string.lower(config) == string.lower(check) then printerr("failed?") return false end
    end
    if not GetResourceState(resource):find("start") then
        printerr("Resource [%s] is not started: Config = %s", resource, config)
        return false
    end
    printdb("Resource found and started")
    return true
end

function FailedSetup(import) printerr("Failed Setup. Please check config for Config.Bridge.%s", import) end

local function GetForwardVectorFromRot(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

function clamp(min, value, max)
    return math.max(min, math.min(value, max))
end

function RayCastFromPlayCam(distance, ignoreObj, rayIgnoreWorld, raycastWater)
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(0)
    local forwardVector = GetForwardVectorFromRot(camRot)
    local targetCoords = camCoords + forwardVector * distance
    local _, hit, endCoords, _, entityHit
    if raycastWater then
        hit, endCoords = TestProbeAgainstWater(camCoords.x,camCoords.y,camCoords.z, targetCoords.x,targetCoords.y,targetCoords.z)
    else
        local traceFlag = rayIgnoreWorld and 1 or 4294967295
        local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, traceFlag, ignoreObj, 0)
        _, hit, endCoords, _, entityHit = GetShapeTestResult(rayHandle)
    end
    return hit, endCoords, entityHit
end

function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    EndTextCommandDisplayText(x, y)
end