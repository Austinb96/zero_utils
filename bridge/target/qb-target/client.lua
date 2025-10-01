local qb_target = exports['qb-target']

local target = {}

local function formatOptions(options)
    if not options then
        return {}
    end

    for _, option in pairs(options) do
        if option.onSelect then
            option.action = option.onSelect
            option.onSelect = nil
        end

        if option.group and not option.job and not option.gang then
            option.job = {}
            option.gang = {}

            for key, v in pairs(option.group) do
                if type(v) == "string" then
                    option.job[#option.job + 1] = v
                    option.gang[#option.gang + 1] = v
                else
                    option.job[key] = v
                    option.gang[key] = v
                end
            end
        end
    end

    return {
        options = options,
        distance = options.distance or options[1] and options[1].distance or 2.5,
    }
end

target.addEntityTarget = function(entities, options)
    qb_target:AddTargetEntity(entities, formatOptions(options))
    return {
        remove = function()
            target.removeEntityTarget(entities, options)
        end
    }
end

target.addNetIDTarget = function(netID, options)
    qb_target:AddTargetEntity(netID, formatOptions(options))
    return {
        remove = function()
            target.removeNetIDTarget(netID, options)
        end
    }
end

target.addBoxZoneTarget = function(id, coords, size, options)
    printdb("Adding box zone target %s, %s, %s, %s", id, coords, size, options)
    qb_target:AddBoxZone(id, coords.xyz, size.y, size.x, {
        name = id,
        heading = coords.w or 0,
        debugPoly = options.debug or false,
        minZ = coords.z - (size.z / 2),
        maxZ = coords.z + (size.z / 2),
    }, formatOptions(options.options))

    return {
        remove = function()
            target.removeZoneTarget(id)
        end
    }
end

target.addGlobalPed = function(name, options)
    local formatted = formatOptions(options)
    exports['qb-target']:AddGlobalPed({ options = formatted, distance = options.distance or 2.5 })
    return {
        remove = function()
            target.removeGlobalPed(name)
        end
    }
end

target.addModelTarget = function(model, options)
    qb_target:AddTargetModel(model, formatOptions(options))
    return {
        remove = function()
            target.RemoveTargetModel(model, options)
        end
    }
end

target.addGlobalObject = function(name, options)
    local formatted = formatOptions(options)
    exports['qb-target']:AddGlobalObject({ options = formatted, distance = options.distance or 2.5 })
    return {
        remove = function()
            target.RemoveGlobalObject(name)
        end
    }
end

target.addGlobalVehicle = function(name, options)
    local formatted = formatOptions(options)
    exports['qb-target']:AddGlobalVehicle({ options = formatted, distance = options.distance or 2.5 })
    return {
        remove = function()
            target.RemoveGlobalVehicle(name)
        end
    }
end

return target