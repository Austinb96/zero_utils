local target = zutils.bridge_loader("target")
if not target then return end

--TODO rewrite how targets are save an passed back so we can do more with targets after they are made
local targets = {}
zutils.target = {}

function zutils.target.addBoxZoneTarget(id, coords, size, options)
    if targets[id] then return printwarn("target with id %s allready exists", id) end
    targets[id] = target.addBoxZoneTarget(id, coords, size, options)
end

zutils.target.AddBoxZoneTarget = zutils.target.addBoxZoneTarget -- Alias for compatibility

function zutils.target.addEntityTarget(entities, options)
    targets[#targets + 1] = target.addEntityTarget(entities, options)
end

zutils.target.AddEntityTargets = zutils.target.addEntityTarget -- Alias for compatibility

function zutils.target.addNetIDTarget(netID, options)
    targets[#targets + 1] = target.addNetIDTarget(netID, options)
end

zutils.target.AddNetIDTarget = zutils.target.addNetIDTarget -- Alias for compatibility

function zutils.target.removeNetIDTarget(netId, options)
    targets[#targets + 1] = target.removeNetIDTarget(netId, options)
end

zutils.target.RemoveEntityTarget = zutils.target.removeNetIDTarget -- Alias for compatibility

function zutils.target.addModelTarget(mode, options)
    targets[#targets + 1] = target.addModelTarget(mode, options)
end

zutils.target.AddModelTarget = zutils.target.addModelTarget -- Alias for compatibility

function zutils.target.removeModelTarget(model, options)
    targets[#targets + 1] = target.removeModelTarget(model, options)
end

zutils.target.RemoveModelTarget = zutils.target.removeModelTarget -- Alias for compatibility

function zutils.target.removeTarget(id)
    local _target = targets[id]
    if not _target then return false, "target not found" end
    if _target.remove then _target:remove() end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, t in pairs(targets) do
        if t and t.remove then
            t:remove()
        end
    end
end)

return zutils.target
