local target = {}

local function formatOptions(options)
    if not options then
        local trace = debug.traceback()
        printerr("No options provided for target %s", trace)
        return
    end
    local distance
    if options.distance then
        distance = options.distance
        options = options.options or options[1]
    end
    for _, option in pairs(options) do
        option.distance = option.distance or distance or 2.5
        if option.action then
            option.onSelect = option.action
        end

        if option.item then
            option.items = option.item
        end
        if option.job or option.gang then
            local group = {}
            if type(option.job) == "string" then
                group[#group + 1] = option.job
            else
                for key, v in pairs(option.job or {}) do
                    if type(v) == "string" then
                        group[#group + 1] = v
                    else
                        group[key] = v
                    end
                end
            end

            if type(option.gang) == "string" then
                group[#group + 1] = option.gang
            else
                for key, v in pairs(option.gang or {}) do
                    if type(v) == "string" then
                        group[#group + 1] = v
                    else
                        group[key] = v
                    end
                end
            end
            option.groups = group
        end
    end
    return options
end

target.addEntityTarget = function(entities, options)
    exports.ox_target:addLocalEntity(entities, formatOptions(options))
    return {
        remove = function()
            target.removeEntityTarget(entities, options)
        end
    }
end

target.addNetIDTarget = function(netID, options)
    exports.ox_target:addEntity(netID, formatOptions(options))
    return {
        remove = function()
            target.removeNetIDTarget(netID, options)
        end
    }
end

target.addBoxZoneTarget = function(id, coords, size, options)
    exports.ox_target:addBoxZone({
        name = id,
        coords = coords.xyz,
        rotation = coords.w or 0,
        size = size,
        options = formatOptions(options.options),
        debug = options.debug or false
    })

    return {
        remove = function()
            target.removeZoneTarget(id)
        end
    }
end

target.addModelTarget = function(model, options)
    exports.ox_target:addModel(model, formatOptions(options))
    return {
        remove = function()
            target.removeModel(model, options)
        end
    }
end

target.addGlobalPed = function(name, options)
    exports.ox_target:addGlobalPed(formatOptions(options))
    return {
        remove = function()
            target.removeGlobalPed(name)
        end
    }
end

target.addGlobalObject = function(name, options)
    exports.ox_target:addGlobalObject(formatOptions(options))
    return {
        remove = function()
            target.removeGlobalObject(name)
        end
    }
end

target.addGlobalVehicle = function(name, options)
    exports.ox_target:addGlobalVehicle(formatOptions(options))
    return {
        remove = function()
            target.removeGlobalVehicle(name)
        end
    }
end

return target