local camera = nil
local isRenderingCamera = false
local currentEntityBeingViewed = nil
local highlightedEntities = {}
local HIGHLIGHTLIMIT = 20

local function cleanupCamera()
    if camera then
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(camera, false)
        camera = nil
    end
    
    for _, entityId in ipairs(highlightedEntities) do
        if DoesEntityExist(entityId) then
            SetEntityDrawOutline(entityId, false)
        end
    end
    highlightedEntities = {}
    
    isRenderingCamera = false
    currentEntityBeingViewed = nil
    
    ClearFocus()
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    
end

local function createEntityCamera(entityId, coords, groupEntities)
    cleanupCamera()
    
    if groupEntities then
        for _, entity in ipairs(groupEntities) do
            local entityIdStr = tostring(entity.id)
            local id = tonumber(entityIdStr:match("^(%d+)")) or tonumber(entityIdStr)
            
            if entity.type == "object" and id and DoesEntityExist(id) then
                SetEntityDrawOutline(id, true)
                SetEntityDrawOutlineColor(137, 180, 250, 255) -- Primary blue color
                SetEntityDrawOutlineShader(1)
                table.insert(highlightedEntities, id)
                if(#highlightedEntities > HIGHLIGHTLIMIT) then
                    printwarn("Warning: Highlighted entities limit exceeded, some entities may not be highlighted.")
                    break
                end
            end
        end
    end
    
    local offsetX, offsetY, offsetZ = 8.0, 8.0, 3.0
    local camCoords = vector3(coords.x + offsetX, coords.y + offsetY, coords.z + offsetZ)
    
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z)
    SetCamRot(camera, -20.0, 0.0, 225.0, 2)
    SetCamFov(camera, 60.0)
    SetCamActive(camera, true)
    
    PointCamAtCoord(camera, coords.x, coords.y, coords.z)
    
    RenderScriptCams(true, false, 500, true, false)
    
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    
    isRenderingCamera = true
    currentEntityBeingViewed = entityId
    
    return true
end

local function getCameraScreenshot()
    if not camera then return nil end
    return {
        active = isRenderingCamera,
        entityId = currentEntityBeingViewed,
        cameraExists = DoesEntityExist(camera)
    }
end

RegisterNuiCallback("createEntityCamera", function(data, cb)
    local coords = data.coords
    local entityId = data.entityId
    local groupEntities = data.groupEntities
    
    printtable(data)
    
    if entityId and not DoesEntityExist(entityId) then
        cb({result = false, error = "Entity does not exist"})
        return
    end
    
    local success = createEntityCamera(entityId, coords, groupEntities)
    SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
    cb({result = success})
end)

RegisterNuiCallback("closeEntityCamera", function(data, cb)
    cleanupCamera()
    cb({result = true})
end)

RegisterNuiCallback("getCameraStatus", function(data, cb)
    local status = getCameraScreenshot()
    cb({result = true, data = status})
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        cleanupCamera()
    end
end)

local moveSpeed = 0.3
local mouseMoveSpeed = 0.3

CreateThread(function()
    while true do
        if isRenderingCamera and camera then
            local coords = GetCamCoord(camera)
            local rot = GetCamRot(camera, 2)
            
            local forwardX = -math.sin(math.rad(rot.z)) * math.cos(math.rad(rot.x))
            local forwardY = math.cos(math.rad(rot.z)) * math.cos(math.rad(rot.x))
            local forwardZ = math.sin(math.rad(rot.x))
            
            local rightX = math.cos(math.rad(rot.z))
            local rightY = math.sin(math.rad(rot.z))
            
            local newCoords = coords
            
            if IsControlPressed(0, 32) then -- W - Forward
                newCoords = vector3(
                    coords.x + forwardX * moveSpeed,
                    coords.y + forwardY * moveSpeed,
                    coords.z + forwardZ * moveSpeed
                )
            end
            if IsControlPressed(0, 33) then -- S - Backward
                newCoords = vector3(
                    coords.x - forwardX * moveSpeed,
                    coords.y - forwardY * moveSpeed,
                    coords.z - forwardZ * moveSpeed
                )
            end
            if IsControlPressed(0, 34) then -- A - Left
                newCoords = vector3(
                    coords.x - rightX * moveSpeed,
                    coords.y - rightY * moveSpeed,
                    coords.z
                )
            end
            if IsControlPressed(0, 35) then -- D - Right
                newCoords = vector3(
                    coords.x + rightX * moveSpeed,
                    coords.y + rightY * moveSpeed,
                    coords.z
                )
            end
            
            if IsControlPressed(0, 44) then -- Q - Down
                newCoords = vector3(coords.x, coords.y, coords.z - moveSpeed)
            end
            if IsControlPressed(0, 38) then -- E - Up
                newCoords = vector3(coords.x, coords.y, coords.z + moveSpeed)
            end
            
            -- MOUSE MOVEMENT
            local leftMousePressed = IsControlPressed(0, 24)   -- Left Mouse Button
            
            if leftMousePressed then
                DisableControlAction(0, 1, true)  -- Mouse X
                DisableControlAction(0, 2, true)  -- Mouse Y
                DisableControlAction(0, 24, true) -- Left Mouse (prevent attacks)
                
                local mouseX = GetDisabledControlNormal(0, 1) * 15.0
                local mouseY = GetDisabledControlNormal(0, 2) * 15.0
                
                if math.abs(mouseX) > 0.01 or math.abs(mouseY) > 0.01 then
                    newCoords = vector3(
                        coords.x - (rightX * mouseX * mouseMoveSpeed),
                        coords.y - (rightY * mouseX * mouseMoveSpeed),
                        coords.z + (mouseY * mouseMoveSpeed)
                    )
                end
            end
            
            if newCoords ~= coords then
                SetCamCoord(camera, newCoords.x, newCoords.y, newCoords.z)
            end
            
            -- ESC to close camera
            DisableControlAction(0, 200, true) -- Stopping Pause menu. dont touch
            if IsControlJustPressed(0, 322) then -- ESC
                cleanupCamera()
                SendNUIMessage({ action = "closeEntityCamera" })
            end
        end
        Wait(0)
    end
end)