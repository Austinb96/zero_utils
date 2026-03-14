zutils.draw = {}

local _DrawRect = DrawRect

local rendering = {
    text = {},
    running = false
}
local function start_draw_text_loop()
    if rendering.running then return end
    rendering.running = true
    CreateThread(function()
        while rendering.running do
            Wait(0)
            local cam_coord = GetGameplayCamCoords()
            local cam_fov = GetGameplayCamFov()
            for drawing, _ in pairs(rendering.text) do
                local distance = #(drawing.coords - cam_coord)
                local on_screen, _, _ = World3dToScreen2d(drawing.coords.x, drawing.coords.y, drawing.coords.z)
                if on_screen then
                    local fovScale = (1 / cam_fov) * 75
                    local scale = (1 / distance) * 4 * fovScale * (drawing.scale or 0.3)

                    SetTextFont(drawing.font or 0)
                    SetTextScale(scale, scale)
                    SetTextColour(drawing.color.r, drawing.color.g, drawing.color.b, drawing.color.a)
                    SetTextEntry("STRING")
                    SetTextCentre(true)
                    AddTextComponentString(drawing.text or "")
                    SetDrawOrigin(drawing.coords.x, drawing.coords.y, drawing.coords.z, 0)
                    EndTextCommandDisplayText(0, 0)
                    ClearDrawOrigin()
                end
            end
        end
    end)
end

local function add_render_text(drawing)
    rendering.text[drawing] = true
    start_draw_text_loop()
end

local function remove_render_text(drawing)
    rendering.text[drawing] = nil
    if table.isEmpty(rendering.text) then
        rendering.running = false
    end
end

function zutils.draw.text3D(coords, text, options)
    options = options or {}
    local drawing = {
        running = false,
        font = options.font or 0,
        text = text,
        color = (type(options.color) == "string" and zutils.color.rgbaFromHex(options.color)) or options.color or
            { r = 255, g = 255, b = 255, a = 255 },
        scale = options.scale or 0.3,
        coords = coords,
        distance = options.distance,
        point = nil

    }

    function drawing:draw()
        if self.running then return end
        self.running = true
        add_render_text(self)
    end

    function drawing:stop()
        if not self.running then return end
        self.running = false
        remove_render_text(self)
    end

    function drawing:updateText(newText)
        self.text = newText
    end

    function drawing:delete()
        self:stop()
        if drawing.point then
            zutils.points.removePoint(drawing.point)
        end
    end

    function drawing:updateCoords(new_coords, update_point)
        if update_point and drawing.point then
            zutils.points.updateCoords(drawing.point, new_coords)
        end
        self.coords = new_coords
    end

    if options.distance then
        drawing.point = zutils.points.addPoint(coords.xyz, {
            distance = options.distance,
            onEnter = function()
                --TODO find a better way to handle this. should work in most cases atm tho
                if options.bucket and zutils.bucket.get() ~= options.bucket then
                    return
                end
                drawing:draw()
                if options.onEnter then options.onEnter() end
            end,
            onExit = function()
                drawing:stop()
            end
        })
    else
        drawing:draw()
    end

    return drawing
end

function zutils.draw.textBox(items, options)
    options = options or {}
    
    local buttonBox = {
        running = false,
        items = items or {},
        position = options.position or { x = 0.88, y = 0.40 },
        lineHeight = options.lineHeight or 0.028,
        bgPadding = options.bgPadding or 0.008,
        keyBoxWidth = options.keyBoxWidth or 0.055,
        keyBoxHeight = options.keyBoxHeight or 0.022,
        totalWidth = options.totalWidth or 0.145,
        keyFont = options.keyFont or 4,
        keyScale = options.keyScale or 0.30,
        descFont = options.descFont or 4,
        descScale = options.descScale or 0.32,
        keyColor = options.keyColor or { r = 255, g = 255, b = 255, a = 255 },
        descColor = options.descColor or { r = 200, g = 200, b = 200, a = 255 },
        keyBoxColor = options.keyBoxColor or { r = 50, g = 50, b = 50, a = 200 },
        bgColor = options.bgColor or { r = 0, g = 0, b = 0, a = 180 },
        showKeys = options.showKeys == nil and true or options.showKeys,
        thread = nil
    }
    
    function buttonBox:draw()
        if self.running then return end
        self.running = true
        
        self.thread = CreateThread(function()
            while self.running do
                Wait(0)
                
                if not self.items or #self.items == 0 then
                    goto continue
                end
                
                local startX = self.position.x
                local startY = self.position.y
                
                local actualWidth = self.showKeys and self.totalWidth or (self.totalWidth - 0.04)
                local bgCenterX = self.showKeys and (startX + 0.065) or (startX + 0.045)
                
                _DrawRect(
                    bgCenterX, 
                    startY + (self.lineHeight * #self.items / 2) + self.bgPadding, 
                    actualWidth, 
                    self.lineHeight * #self.items + (self.bgPadding * 2), 
                    self.bgColor.r, self.bgColor.g, self.bgColor.b, self.bgColor.a
                )
                
                for i, item in ipairs(self.items) do
                    local yPos = startY + (self.lineHeight * (i - 1))
                    
                    local key, desc
                    if type(item) == "table" then
                        key = item.key or item[1]
                        desc = item.desc or item[2]
                    else
                        desc = tostring(item)
                    end
                    
                    if self.showKeys and key then
                        _DrawRect(
                            startX + 0.02, 
                            yPos + 0.012, 
                            self.keyBoxWidth, 
                            self.keyBoxHeight, 
                            self.keyBoxColor.r, self.keyBoxColor.g, self.keyBoxColor.b, self.keyBoxColor.a
                        )
                        
                        SetTextScale(self.keyScale, self.keyScale)
                        SetTextFont(self.keyFont)
                        SetTextProportional(1)
                        SetTextColour(self.keyColor.r, self.keyColor.g, self.keyColor.b, self.keyColor.a)
                        SetTextEntry("STRING")
                        SetTextCentre(true)
                        AddTextComponentString(tostring(key))
                        DrawText(startX + 0.02, yPos + 0.003)
                    end
                    
                    if desc then
                        SetTextScale(self.descScale, self.descScale)
                        SetTextFont(self.descFont)
                        SetTextProportional(1)
                        SetTextColour(self.descColor.r, self.descColor.g, self.descColor.b, self.descColor.a)
                        SetTextEntry("STRING")
                        SetTextCentre(not self.showKeys)
                        AddTextComponentString(tostring(desc))
                        local textX = self.showKeys and (startX + 0.05) or bgCenterX
                        DrawText(textX, yPos + 0.003)
                    end
                end
                
                ::continue::
            end
        end)
    end
    
    function buttonBox:stop()
        self.running = false
        if self.thread then
            self.thread = nil
        end
    end
    
    function buttonBox:updateItems(newItems)
        self.items = newItems
    end
    
    function buttonBox:delete()
        self:stop()
    end
    
    if options.autoStart then
        buttonBox:draw()
    end
    
    return buttonBox
end

return zutils.draw
