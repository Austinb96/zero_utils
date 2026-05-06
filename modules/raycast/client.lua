zutils.raycast = {}

local activeRaycasts = {}

local _GetShapeTestResultIncludingMaterial = GetShapeTestResultIncludingMaterial
local _StartExpensiveSynchronousShapeTestLosProbe = StartExpensiveSynchronousShapeTestLosProbe
local _DrawMarker = DrawMarker

local function handle_prop_controls(raycast, controlOptions)
    if not controlOptions then return end
    
    local rotationSpeed = controlOptions.rotationSpeed or 3
    local fastRotationSpeed = controlOptions.fastRotationSpeed or 10
    local zOffsetSpeed = controlOptions.zOffsetSpeed or 0.01
    local fastZOffsetSpeed = controlOptions.fastZOffsetSpeed or 0.05
    local maxZOffset = controlOptions.maxZOffset or 5.0
    local minZOffset = controlOptions.minZOffset or -5.0
    
    local isFast = IsControlPressed(0, 21) -- Shift
    
    if not controlOptions.lockHeading then
        if IsControlJustReleased(0, 241) then -- Scroll Up
            local speed = isFast and fastRotationSpeed or rotationSpeed
            controlOptions.currentRotation = controlOptions.currentRotation + speed
            if controlOptions.currentRotation >= 360 then 
                controlOptions.currentRotation = controlOptions.currentRotation - 360 
            end
        end
        
        if IsControlJustReleased(0, 242) then -- Scroll Down
            local speed = isFast and fastRotationSpeed or rotationSpeed
            controlOptions.currentRotation = controlOptions.currentRotation - speed
            if controlOptions.currentRotation < 0 then 
                controlOptions.currentRotation = controlOptions.currentRotation + 360 
            end
        end
    else
        controlOptions.currentRotation = GetGameplayCamRot(2).z
    end
    
    if IsControlPressed(0, 10) then -- Page Up
        local speed = isFast and fastZOffsetSpeed or zOffsetSpeed
        controlOptions.zOffset = math.min(controlOptions.zOffset + speed, maxZOffset)
        if raycast.propMarker then
            raycast.propMarker.offset = vector3(0, 0, controlOptions.zOffset)
        end
    end
    
    if IsControlPressed(0, 11) then -- Page Down
        local speed = isFast and fastZOffsetSpeed or zOffsetSpeed
        controlOptions.zOffset = math.max(controlOptions.zOffset - speed, minZOffset)
        if raycast.propMarker then
            raycast.propMarker.offset = vector3(0, 0, controlOptions.zOffset)
        end
    end
    
    if IsControlJustReleased(0, 58) then -- G key
        controlOptions.zOffset = 0
        if raycast.propMarker then
            raycast.propMarker.offset = vector3(0, 0, 0)
        end
    end
    
    if controlOptions.onConfirm then
        if IsControlJustReleased(0, 38) then -- E
            controlOptions.onConfirm()
        end
    end
    
    if controlOptions.onCancel then
        if IsControlJustReleased(0, 177) or IsControlJustReleased(0, 194) then -- Backspace or Right Click
            controlOptions.onCancel()
        end
    end
    
    if controlOptions.disableFiring then
        DisablePlayerFiring(PlayerPedId(), true)
    end
end


local function perform_raycast(startCoords, endCoords, flags, ignoreEntity)
    local rayHandle = _StartExpensiveSynchronousShapeTestLosProbe(
        startCoords.x, startCoords.y, startCoords.z,
        endCoords.x, endCoords.y, endCoords.z,
        flags or 511,
        ignoreEntity or zutils.cache.ped,
        0
    )
    while rayHandle == 1 do
        Wait(0)
    end
    local _, hit, hitCoords, surfaceNormal, materialHash, entityHit = _GetShapeTestResultIncludingMaterial(rayHandle)
    return {
        hit = hit,
        material = materialHash,
        coords = hitCoords and vector3(hitCoords.x, hitCoords.y, hitCoords.z) or nil,
        entity = entityHit,
        surfaceNormal = surfaceNormal and vector3(surfaceNormal.x, surfaceNormal.y, surfaceNormal.z) or nil,
        startCoords = startCoords,
        endCoords = endCoords
    }
end

local function get_camera_dir()
    local camRot = GetGameplayCamRot(2)
    
    local pitch = camRot.x * math.pi / 180.0
    local heading = camRot.z * math.pi / 180.0
    
    local x = -math.sin(heading) * math.abs(math.cos(pitch))
    local y = math.cos(heading) * math.abs(math.cos(pitch))
    local z = math.sin(pitch)
    
    return vector3(x, y, z)
end

local function draw_hit_marker(coords, color, size)
    color = color or { r = 255, g = 0, b = 0, a = 200 }
    size = size or 0.1
    _DrawMarker(
        28,
        coords.x, coords.y, coords.z,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        size, size, size,
        color.r, color.g, color.b, color.a,
        false, false, 2, false, nil, nil, false
    )
end

local function create_prop_marker(propModel, offset)
    local model = zutils.joaat(propModel)
    local prop = nil
    local loaded = false
    
    local success = zutils.loadModel(model, true)
    if success then
        prop = CreateObject(model, 0, 0, 0, false, false, false)
        SetEntityAlpha(prop, 200, false)
        SetEntityCollision(prop, false, false)
        SetEntityCompletelyDisableCollision(prop, false, false)
        SetEntityAsMissionEntity(prop, true, true)
        FreezeEntityPosition(prop, true)
        loaded = true
    end
    
    return {
        entity = prop,
        loaded = loaded,
        offset = offset or vector3(0, 0, 0),
        
        update = function(self, coords, heading)
            if self.entity and DoesEntityExist(self.entity) then
                local finalCoords = coords + self.offset
                SetEntityCoords(self.entity, finalCoords.x, finalCoords.y, finalCoords.z, false, false, false, false)
                if heading then
                    SetEntityHeading(self.entity, heading)
                end
            end
        end,
        
        delete = function(self)
            if self.entity and DoesEntityExist(self.entity) then
                DeleteEntity(self.entity)
            end
            self.entity = nil
        end,
        
        setVisible = function(self, visible)
            if self.entity and DoesEntityExist(self.entity) then
                SetEntityVisible(self.entity, visible, false)
            end
        end,
        
        setAlpha = function(self, alpha)
            if self.entity and DoesEntityExist(self.entity) then
                SetEntityAlpha(self.entity, alpha, false)
            end
        end
    }
end

function zutils.raycast.cast(options)
    options = options or {}
    
    local startCoords = options.startCoords
    local endCoords = options.endCoords
    local distance = options.distance or 100.0
    local flags = options.flags or -1
    local ignoreEntity = options.ignoreEntity
    
    if not startCoords then
        startCoords = GetGameplayCamCoord()
    end
    
    if not endCoords then
        local direction = get_camera_dir()
        endCoords = startCoords + (direction * distance)
    end
    
    local result = perform_raycast(startCoords, endCoords, flags, ignoreEntity)
    
    return result
end

function zutils.raycast.create(options)
    options = options or {}
    
    local raycast = {
        id = math.random(1000000, 9999999),
        running = false,
        drawing = false,
        options = options,
        lastResult = {},
        heading = nil,
        propMarker = nil,
        thread = nil,
        outOfRange = nil
    }
    
    if options.marker and options.marker.prop then
        raycast.propMarker = create_prop_marker(
            options.marker.prop,
            options.marker.offset
        )
        if options.marker.alpha then
            raycast.propMarker:setAlpha(options.marker.alpha)
        end
    end
    
    function raycast:update()
        local startCoords = self.options.startCoords
        local endCoords = self.options.endCoords
        local distance = self.options.distance or 100.0
        
        if self.options.fromPlayer then
            startCoords = GetGameplayCamCoord()
            local direction = get_camera_dir()
            endCoords = startCoords + (direction * distance)
        end
        
        if not endCoords and not self.options.fromPlayer then
            local direction = self.options.direction or vector3(0, 1, 0)
            endCoords = startCoords + (direction * distance)
        end
        
        local ignoreEntity = self.options.ignoreEntity
        if self.propMarker and self.propMarker.entity then
            ignoreEntity = self.propMarker.entity
        end
        
        self.lastResult = perform_raycast(
            startCoords, 
            endCoords, 
            self.options.flags or -1,
            ignoreEntity
        )
        
        if self.lastResult.hit and self.lastResult.coords then
            
            if self.lastResult.surfaceNormal and self.options.marker and self.options.marker.alignToSurface then
                local normal = self.lastResult.surfaceNormal
                local heading = math.deg(math.atan2(normal.y, normal.x))
                
                if self.heading then
                    local smoothing = self.options.smoothing or 0.3
                    local diff = heading - self.heading
                    if diff > 180 then diff = diff - 360 end
                    if diff < -180 then diff = diff + 360 end
                    self.heading = self.heading + diff * smoothing
                else
                    self.heading = heading
                end
            else
                if self.options.controls and self.options.controls.currentRotation then
                    self.heading = self.options.controls.currentRotation
                elseif self.options.fromPlayer and not self.options.controls then
                    local camHeading = GetGameplayCamRot(2).z
                    if self.heading then
                        local smoothing = self.options.smoothing or 0.3
                        local diff = camHeading - self.heading
                        if diff > 180 then diff = diff - 360 end
                        if diff < -180 then diff = diff + 360 end
                        self.heading = self.heading + diff * smoothing
                    else
                        self.heading = camHeading
                    end
                else
                    self.heading = self.options.marker and self.options.marker.heading or 0.0
                end
            end
        end
        
        if self.options.marker and self.options.marker.distance and self.lastResult.coords and self.propMarker and self.propMarker.entity and DoesEntityExist(self.propMarker.entity) then
            local dist = #(startCoords - self.lastResult.coords)
            local maxDist = self.options.marker.distance.distance or 10.0
            local wasOutOfRange = self.outOfRange
            self.outOfRange = dist > maxDist
            
            if self.outOfRange ~= wasOutOfRange or wasOutOfRange == nil then
                local color = self.outOfRange and self.options.marker.distance.outOfRange or self.options.marker.distance.inRange
                if color then
                    SetEntityDrawOutlineColor(math.floor(color.x), math.floor(color.y), math.floor(color.z), math.floor(color.w))
                    SetEntityDrawOutlineShader(1)
                    SetEntityDrawOutline(self.propMarker.entity, true)
                end
            end
        else
            self.outOfRange = true
        end
        
        return self.lastResult
    end

    function raycast:start()
        if self.running then return end
        self.running = true
        
        if self.options.marker and (self.options.marker.prop or self.options.marker.entity) then
            self.instructionBox = zutils.draw.textBox({
                { key = "E", desc = "Place" },
                { key = "G", desc = "Snap to ground" },
                { key = "Scroll", desc = "Rotate" },
                { key = "PgUp/Dn", desc = "Raise/Lower" },
                { key = "Backspace/RMouse", desc = "Cancel" }
            })
        end
        
        self.thread = CreateThread(function()
            while self.running do
                Wait(0)
                self:update()
                
                if self.drawing and self.lastResult then
                    local hitCoords = self.lastResult.coords
                    
                    if hitCoords and self.propMarker and self.propMarker.loaded then
                        self.propMarker:update(hitCoords, self.heading)
                        self.propMarker:setVisible(true)
                    elseif self.propMarker and self.propMarker.loaded then
                        self.propMarker:setVisible(false)
                    end
                    
                    if not self.propMarker and self.lastResult.hit and hitCoords then
                        draw_hit_marker(hitCoords, self.options.hitColor, self.options.markerSize)
                    end
                    
                    if self.instructionBox and not self.instructionBox.running then
                        self.instructionBox:draw()
                    end
                end
                
                if self.options.controls then
                    handle_prop_controls(self, self.options.controls)
                end
                
                if self.options.onUpdate then
                    self.options.onUpdate(self.lastResult)
                end
            end
        end)
    end
        
    function raycast:stop()
        self.running = false
        self.drawing = false
        self.heading = nil
        if self.propMarker then
            self.propMarker:setVisible(false)
        end
        if self.instructionBox then
            self.instructionBox:delete()
            self.instructionBox = nil
        end
    end
        
    function raycast:enableDrawing(lineColor, hitColor)
        self.drawing = true
        self.options.lineColor = lineColor or self.options.lineColor or { r = 255, g = 0, b = 0, a = 255 }
        self.options.hitColor = hitColor or self.options.hitColor or { r = 0, g = 255, b = 0, a = 200 }
    end
        
    function raycast:disableDrawing()
        self.drawing = false
        if self.propMarker then
            self.propMarker:setVisible(false)
        end
    end
        
    function raycast:result()
        if not self.lastResult or not self.lastResult.hit then
            return self.lastResult
        end
        
        local coords = self.lastResult.coords
        local rotation, offset = self:transform()
        
        local finalCoords = coords + vector3(0, 0, offset)
        
        local markerCoords = vector4(finalCoords.x, finalCoords.y, finalCoords.z, rotation)
        
        return {
            hit = self.lastResult.hit,
            coords = self.lastResult.coords,
            entity = self.lastResult.entity,
            surfaceNormal = self.lastResult.surfaceNormal,
            startCoords = self.lastResult.startCoords,
            endCoords = self.lastResult.endCoords,
            markerCoords = markerCoords,
            rotation = rotation,
            offset = offset,
            outOfRange = self.outOfRange
        }
    end
        
    function raycast:getEntity()
        return self.propMarker and self.propMarker.entity
    end
        
    function raycast:transform()
        local rotation = self.options.controls and self.options.controls.currentRotation or self.heading or 0
        local offset = self.options.controls and self.options.controls.zOffset or 0
        return rotation, offset
    end
        
    function raycast:isOutOfRange()
        return self.outOfRange
    end
        
    function raycast:updateMarkerProp(prop, offset, alpha)
        if self.propMarker then
            self.propMarker:delete()
        end
        
        self.propMarker = create_prop_marker(prop, offset)
        if alpha then
            self.propMarker:setAlpha(alpha)
        end
        self.options.marker = self.options.marker or {}
        self.options.marker.prop = prop
        self.options.marker.offset = offset
        self.options.marker.alpha = alpha
    end
        
    function raycast:delete()
        self:stop()
        if self.propMarker then
            self.propMarker:delete()
            self.propMarker = nil
        end
        if self.instructionBox then
            self.instructionBox:delete()
            self.instructionBox = nil
        end
        activeRaycasts[self.id] = nil
    end
    
    if options.autoStart then
        raycast:start()
    end
    
    if options.draw then
        raycast:enableDrawing(options.lineColor, options.hitColor)
    end
    
    activeRaycasts[raycast.id] = raycast
    return raycast
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, raycast in pairs(activeRaycasts) do
        raycast:delete()
    end
end)

return zutils.raycast