if not AssertBridgeResource(Config.Bridge.Target, "ox", "ox_target") then return end
local target = {}

local function formatOptions(options)
    local distance
    if options.distance then
        distance = options.distance
        options = options.options or options[1]
    end
    for _, option in pairs(options) do
        option.distance = option.distance or distance
        if option.action then
            option.onSelect = option.action
        end
        
        if option.item then
            option.items = option.item
        end
        if option.job or option.gang then
            local group = {}
            if type(option.job) == "string" then
                group[#group+1] = option.job
            else
                for key, v in pairs(option.job or {}) do
                    if type(v) =="string" then
                        group[#group+1] = v
                    else
                        group[key] = v
                    end
                end
            end
            
            if type(option.gang) == "string" then
                group[#group+1] = option.gang
            else
                for key, v in pairs(option.gang or {}) do
                    if type(v) =="string" then
                        group[#group+1] = v
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

target.AddEntityTarget = function(entities, options)
    exports.ox_target:addLocalEntity(entities, formatOptions(options))
end

target.AddNetIDTarget = function(netID, options)
    exports.ox_target:addEntity(netID, formatOptions(options))
end

target.RemoveNetIDTarget = function(netId, options)
    exports.ox_target:removeEntity(netId, options)
end

return target
