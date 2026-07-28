local active = nil
local highlighted = {}
local HIGHLIGHT_LIMIT = 20

local CameraObject = {}
CameraObject.__index = CameraObject

local function clearHighlights()
    for _, entity in ipairs(highlighted) do
        if DoesEntityExist(entity) then
            SetEntityDrawOutline(entity, false)
        end
    end

    highlighted = {}
end

local function highlightEntities(group, limit)
    if not group then return end

    limit = limit or HIGHLIGHT_LIMIT
    clearHighlights()

    for _, entry in ipairs(group) do
        if #highlighted >= limit then
            printwarn("highlight limit exceeded")
            break
        end

        local id = tonumber(tostring(entry.id):match("^(%d+)"))

        if id and DoesEntityExist(id) then
            SetEntityDrawOutline(id, true)
            SetEntityDrawOutlineColor(137, 180, 250, 255)
            SetEntityDrawOutlineShader(1)
            table.insert(highlighted, id)
        end
    end
end

local function vecSub(a, b)
    return vector3(a.x - b.x, a.y - b.y, a.z - b.z)
end

local function vecAdd(a, b)
    return vector3(a.x + b.x, a.y + b.y, a.z + b.z)
end

local function vecMul(v, s)
    return vector3(v.x * s, v.y * s, v.z * s)
end

local function vecLen(v)
    return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end

local function vecNorm(v)
    local len = vecLen(v)
    if len < 0.001 then
        return vector3(0.0, 1.0, 0.0)
    end

    return vector3(v.x / len, v.y / len, v.z / len)
end

local function vecCross(a, b)
    return vector3(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    )
end

local function clampDistance(from, to, minDist, maxDist)
    local dx, dy, dz = from.x - to.x, from.y - to.y, from.z - to.z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)

    if dist < 0.001 then return from end

    if dist < minDist then
        local scale = minDist / dist
        return vector3(to.x + dx * scale, to.y + dy * scale, to.z + dz * scale)
    end

    if dist > maxDist then
        local scale = maxDist / dist
        return vector3(to.x + dx * scale, to.y + dy * scale, to.z + dz * scale)
    end

    return from
end

local function clampZOffset(cameraZ, targetZ, maxOffset)
    if not maxOffset or maxOffset <= 0 then return cameraZ end

    local diff = math.abs(cameraZ - targetZ)

    if diff > maxOffset then
        return targetZ + (cameraZ > targetZ and maxOffset or -maxOffset)
    end

    return cameraZ
end

local function createCamAt(coords, rot, fov, smooth)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(cam, coords.x, coords.y, coords.z)
    SetCamRot(cam, rot.x, rot.y, rot.z, 2)
    SetCamFov(cam, fov)
    SetCamActive(cam, true)

    RenderScriptCams(true, smooth ~= false, 500, true, false)

    return cam
end

local function getMovementVectors(rot)
    local radX = math.rad(rot.x)
    local radZ = math.rad(rot.z)

    local forwardX = -math.sin(radZ) * math.cos(radX)
    local forwardY = math.cos(radZ) * math.cos(radX)
    local forwardZ = math.sin(radX)

    local rightX = math.cos(radZ)
    local rightY = math.sin(radZ)

    return forwardX, forwardY, forwardZ, rightX, rightY
end

local function getCameraBasisFromFocus(camCoords, focusPoint)
    local forward = vecNorm(vecSub(focusPoint, camCoords))
    local worldUp = vector3(0.0, 0.0, 1.0)

    local right = vecNorm(vecCross(forward, worldUp))

    if vecLen(right) < 0.001 then
        right = vector3(1.0, 0.0, 0.0)
    end

    local up = vecNorm(vecCross(right, forward))

    return forward, right, up
end

local function getFocusPoint(camera, targetCoords)
    return vector3(
        targetCoords.x + camera.focusOffset.x,
        targetCoords.y + camera.focusOffset.y,
        targetCoords.z + camera.focusOffset.z
    )
end

local function getScreenAimPoint(camera, camCoords, focusPoint, fov)
    local opts = camera.options

    local screenOffset = opts.screenOffset or opts.aimOffset
    if not screenOffset then
        return focusPoint
    end

    local _, right, up = getCameraBasisFromFocus(camCoords, focusPoint)

    local dist = vecLen(vecSub(focusPoint, camCoords))
    local fovRad = math.rad(fov or 60.0)

    local screenW, screenH = GetActiveScreenResolution()
    local aspect = 16.0 / 9.0

    if screenW and screenH and screenH > 0 then
        aspect = screenW / screenH
    end

    local halfHeight = math.tan(fovRad * 0.5) * dist
    local halfWidth = halfHeight * aspect

    local x = screenOffset.x or screenOffset.right or 0.0
    local y = screenOffset.y or screenOffset.up or 0.0

    return vecAdd(
        focusPoint,
        vecAdd(
            vecMul(right, x * halfWidth),
            vecMul(up, y * halfHeight)
        )
    )
end

local function orbitSpherical(center, currentPos, deltaAzimuth, deltaElevation, minDist, maxDist)
    local dx = currentPos.x - center.x
    local dy = currentPos.y - center.y
    local dz = currentPos.z - center.z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)

    if dist < 0.001 then return currentPos end

    if deltaElevation == 0 then
        local cosA = math.cos(deltaAzimuth)
        local sinA = math.sin(deltaAzimuth)

        local newPos = vector3(
            center.x + dx * cosA - dy * sinA,
            center.y + dx * sinA + dy * cosA,
            currentPos.z
        )

        if minDist and maxDist then
            newPos = clampDistance(newPos, center, minDist, maxDist)
        end

        return newPos
    end

    local azimuth = math.atan2(dy, dx)
    local elevation = math.asin(math.max(-1.0, math.min(1.0, dz / dist)))

    local newElevation = elevation + deltaElevation
    local clamped = math.max(math.rad(-85.0), math.min(math.rad(85.0), newElevation))

    if math.abs(newElevation - clamped) > 0.0001 then
        return currentPos
    end

    azimuth = azimuth + deltaAzimuth
    elevation = clamped

    local newPos = vector3(
        center.x + dist * math.cos(elevation) * math.cos(azimuth),
        center.y + dist * math.cos(elevation) * math.sin(azimuth),
        center.z + dist * math.sin(elevation)
    )

    if minDist and maxDist then
        newPos = clampDistance(newPos, center, minDist, maxDist)
    end

    return newPos
end

local function drawDebugText(coords, text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)

    SetTextScale(0.0, 0.28)
    SetTextFont(0)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 220)
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)

    ClearDrawOrigin()
end

local function drawDebugPoint(coords, label, r, g, b, size)
    size = size or 0.06

    DrawMarker(
        28,
        coords.x, coords.y, coords.z,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        size, size, size,
        r or 255, g or 255, b or 255, 180,
        false, false, 2,
        false, nil, nil, false
    )

    if label then
        drawDebugText(vector3(coords.x, coords.y, coords.z + size + 0.05), label)
    end
end

local function drawCameraDebug(camera, camCoords, targetCoords, focusPoint, aimPoint)
    local debug = camera.options.debug
    if not debug then return end

    drawDebugPoint(targetCoords, "target", 255, 80, 80, 0.07)
    drawDebugPoint(focusPoint, "focus", 80, 255, 80, 0.07)
    drawDebugPoint(aimPoint, "aim", 80, 160, 255, 0.07)
    drawDebugPoint(camCoords, "cam", 255, 255, 80, 0.05)

    DrawLine(
        camCoords.x, camCoords.y, camCoords.z,
        focusPoint.x, focusPoint.y, focusPoint.z,
        80, 255, 80, 180
    )

    DrawLine(
        camCoords.x, camCoords.y, camCoords.z,
        aimPoint.x, aimPoint.y, aimPoint.z,
        80, 160, 255, 180
    )

    DrawLine(
        targetCoords.x, targetCoords.y, targetCoords.z,
        aimPoint.x, aimPoint.y, aimPoint.z,
        255, 255, 255, 120
    )
end

function CameraObject:new(target, options)
    local obj = {
        entity = target and DoesEntityExist(target) and target or nil,
        options = options or {},
        handle = nil,
        thread = nil,
        resource = GetInvokingResource(),
        freeLook = false,
        focusOffset = vector3(0.0, 0.0, 0.0),
        zoomDistance = nil,
    }

    return setmetatable(obj, self)
end

function CameraObject:isActive()
    return active == self and self.handle ~= nil
end

function CameraObject:getState()
    if not self:isActive() then return nil end

    local coords = GetCamCoord(self.handle)
    local rot = GetCamRot(self.handle, 2)
    local targetCoords = self.entity and DoesEntityExist(self.entity) and GetEntityCoords(self.entity) or nil
    local focusPoint = targetCoords and getFocusPoint(self, targetCoords) or nil
    local aimPoint = focusPoint and getScreenAimPoint(self, coords, focusPoint, GetCamFov(self.handle)) or nil

    return {
        position = vector3(coords.x, coords.y, coords.z),
        rotation = vector3(rot.x, rot.y, rot.z),
        fov = GetCamFov(self.handle),
        target = targetCoords,
        focus = focusPoint,
        aim = aimPoint,
    }
end

function CameraObject:exit(saved)
    local entity = self.entity
    local state = self:getState()

    if self.options.onExit then
        self.options.onExit(saved == true, entity, state)
    end

    if self.handle then
        RenderScriptCams(false, self.options.smooth ~= false, 500, true, false)
        DestroyCam(self.handle, false)
        self.handle = nil
    end

    self.entity = nil
    self.freeLook = false
    self.focusOffset = vector3(0.0, 0.0, 0.0)

    clearHighlights()

    if active == self then
        active = nil
    end
end

local cameraLock = false

local function runLoop(camera)
    if camera.thread then return end

    local opts = camera.options
    local speed = opts.moveSpeed or 0.05
    local mouseSpeed = opts.mouseSpeed or 0.05
    local fovMin = opts.fovMin or 10.0
    local fovMax = opts.fovMax or 120.0
    local maxZ = opts.maxZOffset or 2.0
    local minZoom = opts.minZoom or 0.5
    local maxZoom = opts.maxZoom or 2.5
    local trackTarget = opts.trackTarget ~= false
    local target = camera.entity

    cameraLock = false

    camera.thread = CreateThread(function()
        while camera:isActive() do
            while cameraLock and camera.handle do
                if not camera:isActive() then break end
                Wait(0)
            end

            if not camera.handle then break end

            DisableAllControlActions(1)

            local camCoords = GetCamCoord(camera.handle)
            local camRot = GetCamRot(camera.handle, 2)
            local targetCoords = target and DoesEntityExist(target) and GetEntityCoords(target) or nil
            local focusPoint = targetCoords and getFocusPoint(camera, targetCoords) or nil

            local newCoords = camCoords
            local newRot = camRot
            local newFov = GetCamFov(camera.handle)
            local dirty = false

            local currentSpeed = IsDisabledControlPressed(0, 21) and speed * 2.0 or speed

            local forwardX, forwardY, forwardZ, rightX, rightY = getMovementVectors(camRot)

            if IsDisabledControlPressed(0, 32) then -- W
                newCoords = vector3(
                    newCoords.x + forwardX * currentSpeed,
                    newCoords.y + forwardY * currentSpeed,
                    newCoords.z + forwardZ * currentSpeed
                )
                dirty = true
            end

            if IsDisabledControlPressed(0, 33) then -- S
                newCoords = vector3(
                    newCoords.x - forwardX * currentSpeed,
                    newCoords.y - forwardY * currentSpeed,
                    newCoords.z - forwardZ * currentSpeed
                )
                dirty = true
            end

            if IsDisabledControlPressed(0, 34) then -- A
                newCoords = vector3(
                    newCoords.x - rightX * currentSpeed,
                    newCoords.y - rightY * currentSpeed,
                    newCoords.z
                )
                dirty = true
            end

            if IsDisabledControlPressed(0, 35) then -- D
                newCoords = vector3(
                    newCoords.x + rightX * currentSpeed,
                    newCoords.y + rightY * currentSpeed,
                    newCoords.z
                )
                dirty = true
            end

            if IsDisabledControlPressed(0, 44) then -- Q down
                newCoords = vector3(newCoords.x, newCoords.y, newCoords.z - currentSpeed)
                dirty = true
            end

            if IsDisabledControlPressed(0, 38) then -- E up
                newCoords = vector3(newCoords.x, newCoords.y, newCoords.z + currentSpeed)
                dirty = true
            end

            local leftMouse = IsDisabledControlPressed(0, 24)
            if leftMouse and focusPoint then
                local mouseX = GetDisabledControlNormal(0, 1)
                local mouseY = GetDisabledControlNormal(0, 2)

                if math.abs(mouseX) > 0.001 or math.abs(mouseY) > 0.001 then
                    local sensitivity = math.rad(mouseSpeed * 200.0)

                    newCoords = orbitSpherical(
                        focusPoint,
                        newCoords,
                        -mouseX * sensitivity,
                        mouseY * sensitivity,
                        minZoom,
                        maxZoom
                    )

                    dirty = true
                end
            end

            local rightMouse = IsDisabledControlPressed(0, 25)
            if rightMouse then
                local mouseX = GetDisabledControlNormal(0, 1)
                local mouseY = GetDisabledControlNormal(0, 2) * 1.1

                if targetCoords and focusPoint then
                    if math.abs(mouseY) > 0.01 then
                        local deltaZ = mouseY * mouseSpeed

                        local rawCamZ = newCoords.z + deltaZ
                        local clampedCamZ = maxZ and clampZOffset(rawCamZ, targetCoords.z, maxZ) or rawCamZ
                        local actualDelta = clampedCamZ - newCoords.z

                        newCoords = vector3(
                            newCoords.x,
                            newCoords.y,
                            clampedCamZ
                        )

                        camera.focusOffset = vector3(
                            camera.focusOffset.x,
                            camera.focusOffset.y,
                            camera.focusOffset.z + actualDelta
                        )

                        focusPoint = getFocusPoint(camera, targetCoords)
                        dirty = true
                    end

                    if math.abs(mouseX) > 0.001 then
                        local sensitivity = math.rad(mouseSpeed * 200.0)

                        newCoords = orbitSpherical(
                            focusPoint,
                            newCoords,
                            -mouseX * sensitivity,
                            0,
                            minZoom,
                            maxZoom
                        )

                        dirty = true
                    end
                else
                    local rawMouseX = GetDisabledControlNormal(0, 1)
                    local rawMouseY = GetDisabledControlNormal(0, 2)

                    if math.abs(rawMouseX) > 0.001 or math.abs(rawMouseY) > 0.001 then
                        local newX = camRot.x - rawMouseY * mouseSpeed * 10.0
                        local newZ = camRot.z - rawMouseX * mouseSpeed * 10.0

                        newRot = vector3(
                            math.max(-89.0, math.min(89.0, newX)),
                            camRot.y,
                            newZ
                        )

                        camera.freeLook = true
                        dirty = true
                    end
                end
            else
                camera.freeLook = false
            end

            local scroll = GetDisabledControlNormal(0, 16) - GetDisabledControlNormal(0, 17)
            if math.abs(scroll) > 0.001 then
                if IsDisabledControlPressed(0, 21) then
                    newFov = math.max(fovMin, math.min(fovMax, newFov + scroll * 2.0))
                elseif focusPoint then
                    local toCam = vector3(
                        newCoords.x - focusPoint.x,
                        newCoords.y - focusPoint.y,
                        newCoords.z - focusPoint.z
                    )

                    local dist = vecLen(toCam)

                    if dist > 0.001 then
                        camera.zoomDistance = camera.zoomDistance or dist
                        camera.zoomDistance = math.max(
                            minZoom,
                            math.min(maxZoom, camera.zoomDistance + scroll * mouseSpeed * 2.0)
                        )
                    end
                end

                dirty = true
            end

            if focusPoint and camera.zoomDistance then
                local toCam = vector3(
                    newCoords.x - focusPoint.x,
                    newCoords.y - focusPoint.y,
                    newCoords.z - focusPoint.z
                )

                local dist = vecLen(toCam)

                if dist > 0.001 then
                    local dir = vecMul(toCam, 1.0 / dist)

                    local zoomSmooth = opts.zoomSmooth or 0.18
                    local smoothedDist = dist + (camera.zoomDistance - dist) * zoomSmooth

                    if math.abs(camera.zoomDistance - smoothedDist) < 0.001 then
                        smoothedDist = camera.zoomDistance
                    end

                    newCoords = vector3(
                        focusPoint.x + dir.x * smoothedDist,
                        focusPoint.y + dir.y * smoothedDist,
                        focusPoint.z + dir.z * smoothedDist
                    )

                    dirty = true
                end
            end

            if focusPoint then
                newCoords = clampDistance(newCoords, focusPoint, minZoom, maxZoom)
            end

            if maxZ and targetCoords then
                newCoords = vector3(
                    newCoords.x,
                    newCoords.y,
                    clampZOffset(newCoords.z, targetCoords.z, maxZ)
                )
            end

            if dirty then
                SetCamCoord(camera.handle, newCoords.x, newCoords.y, newCoords.z)
                SetCamRot(camera.handle, newRot.x, newRot.y, newRot.z, 2)
                SetCamFov(camera.handle, newFov)

                if opts.onMove then
                    opts.onMove(camera:getState())
                end
            end

            if trackTarget and targetCoords and not camera.freeLook then
                local finalCamCoords = GetCamCoord(camera.handle)
                local finalFov = GetCamFov(camera.handle)

                local finalFocusPoint = getFocusPoint(camera, targetCoords)
                local aimPoint = getScreenAimPoint(camera, finalCamCoords, finalFocusPoint, finalFov)

                PointCamAtCoord(camera.handle, aimPoint.x, aimPoint.y, aimPoint.z)

                drawCameraDebug(camera, finalCamCoords, targetCoords, finalFocusPoint, aimPoint)
            elseif targetCoords then
                local finalCamCoords = GetCamCoord(camera.handle)
                local finalFocusPoint = getFocusPoint(camera, targetCoords)
                local aimPoint = getScreenAimPoint(camera, finalCamCoords, finalFocusPoint, GetCamFov(camera.handle))

                drawCameraDebug(camera, finalCamCoords, targetCoords, finalFocusPoint, aimPoint)
            end

            if IsDisabledControlJustPressed(0, 322) then -- ESC
                camera:exit(false)
                break
            end

            Wait(0)
        end

        camera.thread = nil
    end)
end

---Creates a scripted camera viewing a target entity or coords.
---@param target number|vector3 Entity handle or position to view.
---@param options? table Optional configuration.
---   `offset`         number[]   Default entity {4.0, 0.0, 1.5}. Spawn offset from target.
---                               Format: {forwardDistance, rightOffset, zOffset}.
---   `distance`       number     Override forward distance.
---   `fov`            number     Default 60.0. Initial field of view.
---   `fovMin`         number     Default 10.0. Scroll wheel FOV lower bound.
---   `fovMax`         number     Default 120.0. Scroll wheel FOV upper bound.
---   `moveSpeed`      number     Default 0.05. Base WASD speed.
---   `mouseSpeed`     number     Default 0.05. Mouse drag speed multiplier.
---   `trackTarget`    boolean    Default true. Camera always faces target.
---   `smooth`         boolean    Default true. Smooth transition on create/destroy.
---   `maxZOffset`     number     Default 2.0. Max camera Z distance from target.
---   `minZoom`        number     Default 0.5. Minimum camera distance from focus.
---   `maxZoom`        number     Default 2.5. Maximum camera distance from focus.
---   `highlightGroup` table      Entities to outline. Optional.
---   `highlightLimit` number     Default 20. Max highlighted entities.
---   `screenOffset`   table      Composition offset {x=0.0, y=0.0}.
---                               x/right is horizontal screen offset.
---                               y/up is vertical screen offset.
---                               Positive x aims right of the target,
---                               making the target appear left on screen.
---   `aimOffset`      table      Backward-compatible alias for screenOffset.
---   `debug`          boolean    Draw camera, target, focus, and aim points.
---   `onMove`         function   Callback(state) on camera position change.
---   `onExit`         function   Callback(saved, entity, state) on exit.
local function setCameraTarget(target, options)
    options = options or {}

    if active then
        active:exit(false)
    end

    local entity = target
    local coords

    if type(target) == "vector3" then
        coords = target
        entity = nil
    elseif DoesEntityExist(target) then
        coords = GetEntityCoords(target)
    else
        printerr("invalid camera target")
        return nil
    end

    local fov = options.fov or 60.0
    local camCoords

    if entity then
        local heading = GetEntityHeading(entity)
        local rad = math.rad(heading)

        local forwardX = -math.sin(rad)
        local forwardY = math.cos(rad)
        local rightX = math.cos(rad)
        local rightY = math.sin(rad)

        local offset = options.offset or { 4.0, 0.0, 1.5 }
        local dist = options.distance or offset[1]

        camCoords = vector3(
            coords.x + forwardX * dist + rightX * offset[2],
            coords.y + forwardY * dist + rightY * offset[2],
            coords.z + offset[3]
        )
    else
        local offset = options.offset or { 0.5, 0.5, 1.0 }

        if options.distance then
            local angle = math.rad(45.0)

            offset = {
                options.distance * math.cos(angle),
                options.distance * math.sin(angle),
                options.distance * 0.75,
            }
        end

        camCoords = vector3(
            coords.x + offset[1],
            coords.y + offset[2],
            coords.z + offset[3]
        )
    end

    local camRot = vector3(-20.0, 0.0, 225.0)

    local camera = CameraObject:new(entity, options)
    camera.handle = createCamAt(camCoords, camRot, fov, options.smooth)

    if options.highlightGroup then
        highlightEntities(options.highlightGroup, options.highlightLimit)
    end

    if entity then
        local focusPoint = getFocusPoint(camera, coords)
        local aimPoint = getScreenAimPoint(camera, camCoords, focusPoint, fov)

        PointCamAtCoord(camera.handle, aimPoint.x, aimPoint.y, aimPoint.z)
    end

    active = camera
    runLoop(camera)

    return camera
end

AddEventHandler("onResourceStop", function(resource)
    if not active then return end

    if active.resource == resource then
        active:exit(false, true)
    end
end)

zutils.nui.registerCallback("camera-set-lock", function(bool)
    cameraLock = bool
end)

zutils.camera = {}

---Set camera to view an entity.
---@param entity number Entity handle.
---@param options? table See setCameraTarget options.
---@return table|nil CameraObject
function zutils.camera.setEntityCamera(entity, options)
    return setCameraTarget(entity, options)
end

---Set camera to view coords.
---@param coords vector3 Position.
---@param options? table See setCameraTarget options.
---@return table|nil CameraObject
function zutils.camera.setCameraAtCoords(coords, options)
    if type(coords) ~= "vector3" then
        printerr("coords must be vector3")
        return nil
    end

    return setCameraTarget(coords, options)
end

---Get active camera state.
---@return table|nil CameraObject or nil.
function zutils.camera.getCamera()
    if not active or not active:isActive() then return nil end
    return active
end

---Force exit active camera.
function zutils.camera.exitCamera()
    if active then
        active:exit(false)
    end
end

return zutils.camera
