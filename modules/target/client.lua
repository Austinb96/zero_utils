local target = zutils.bridge_loader("target", "client")
if not target then return end

zutils.target = {}

function zutils.target.addBoxZoneTarget(id, coords, size, options)
    target.addBoxZoneTarget(id, coords, size, options)
end
zutils.target.AddBoxZoneTarget = zutils.target.addBoxZoneTarget -- Alias for compatibility

function zutils.target.addEntityTarget(entities, options)
    target.addEntityTarget(entities, options)
end
zutils.target.AddEntityTargets = zutils.target.addEntityTarget -- Alias for compatibility

function zutils.target.addNetIDTarget(netID, options)
    target.addNetIDTarget(netID, options)
end
zutils.target.AddNetIDTarget = zutils.target.addNetIDTarget -- Alias for compatibility

function zutils.target.removeNetIDTarget(netId, options)
    target.removeNetIDTarget(netId, options)
end
zutils.target.RemoveEntityTarget = zutils.target.removeNetIDTarget -- Alias for compatibility

function zutils.target.addModelTarget(mode, options)
    target.addModelTarget(mode, options)
end
zutils.target.AddModelTarget = zutils.target.addModelTarget -- Alias for compatibility

function zutils.target.removeModelTarget(model, options)
    target.removeModelTarget(model, options)
end
zutils.target.RemoveModelTarget = zutils.target.removeModelTarget -- Alias for compatibility

return zutils.target
