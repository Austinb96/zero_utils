RegisterNetEvent('zero_utils:client:syncTargets', function(netId, targetOptions)
    printdb(true, "Adding Target for %s", netId)
    zutils.target.AddNetIDTarget(netId, targetOptions)
end)