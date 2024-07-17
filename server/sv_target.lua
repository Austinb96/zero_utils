RegisterNetEvent('zero_utils:server:syncTargets', function(netId, targetOptions)
    if targetOptions then
        TriggerClientEvent('zero_utils:client:syncTargets', -1, netId, targetOptions)
    end
end)