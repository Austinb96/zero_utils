zutils.blip = {}
local blips = {}
local BlipObject = {}
BlipObject.__index = BlipObject

setmetatable(zutils.blip, {
    __index = function(self, key)
        if rawget(self, key) then
            return rawget(self, key)
        end
        if not blips[key] then
            printwarn("blip with id(%s) does not exist", key)
        end
        return blips[key]
    end
})

BlipObject.__call = function(self)
    return self.handle
end

BlipObject.__eq = function(self, other)
    if type(other) == "number" then
        return self.handle == other
    elseif type(other) == "table" and other.handle then
        return self.handle == other.handle
    end
    return false
end

BlipObject.__tostring = function(self)
    return tonumber(self.handle)
end

function BlipObject:new(handle, name)
    local obj = {
        handle = handle,
        name = name,
        hidden = false,
    }
    setmetatable(obj, self)
    return obj
end

function BlipObject:remove()
    if DoesBlipExist(self.handle) then
        RemoveBlip(self.handle)
    end
    if blips[self.id] then
        blips[self.id] = nil
    end
end

function BlipObject:hide(exclude_from_all)
    if DoesBlipExist(self.handle) then
        SetBlipDisplay(self.handle, 0)
        self.hidden = true
        if exclude_from_all then
            self.exclude_from_all = true
        end
    end
end

function BlipObject:show(exclude_from_all)
    if DoesBlipExist(self.handle) then
        SetBlipDisplay(self.handle, 6)
        self.hidden = false
        if exclude_from_all then
            self.exclude_from_all = false
        end
    end
end

function BlipObject:toggle()
    if DoesBlipExist(self.handle) then
        if self.hidden then
            self:show()
        else
            self:hide()
        end
    end
end

function BlipObject:updateName(newName)
    if DoesBlipExist(self.handle) then
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(tostring(newName))
        EndTextCommandSetBlipName(self.handle)
    end
end

function BlipObject:setSprite(sprite)
    if DoesBlipExist(self.handle) then
        SetBlipSprite(self.handle, sprite)
    end
end

function BlipObject:setColor(color)
    if DoesBlipExist(self.handle) then
        SetBlipColour(self.handle, color)
    end
end

function BlipObject:setScale(scale)
    if DoesBlipExist(self.handle) then
        SetBlipScale(self.handle, scale)
    end
end

function BlipObject:exists()
    return DoesBlipExist(self.handle)
end

function zutils.blip.createBlip(name, coords, options)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, options.sprite or 106)
    SetBlipColour(blip, options.color or options.colour or 5)
    SetBlipScale(blip, options.scale or 0.7)
    SetBlipDisplay(blip, (options.disp or 6))
    if options.shortRange then SetBlipAsShortRange(blip, true) end
    if options.category then SetBlipCategory(blip, options.category) end
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(tostring(name))
    EndTextCommandSetBlipName(blip)

    local blipObject = BlipObject:new(blip, name)
    blipObject.id = options.id or tostring(blipObject)
    blips[blipObject.id] = blipObject
    if options.startHidden then blipObject:hide() end
    return blipObject
end

function zutils.blip.removeBlip(blip)
    if type(blip) == "table" and blip.remove then
        blip:remove()
    elseif DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

function zutils.blip.hideAll()
    for _, blip in pairs(blips) do
        blip:hide()
    end
end

function zutils.blip.showAll()
    for _, blip in pairs(blips) do
        if not blip.exclude_from_all then
            blip:show()
        end
    end
end

function zutils.blip.getById(id)
    return blips[id]
end

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, blip in pairs(blips) do
        blip:remove()
    end
end)

return zutils.blip
