printdb('Loading vehicles callbacks')
zutils.callback.register('zero_utils:client:GetVehicleType', function(model)
    return GetVehicleTypeFromModelOrHash(model)
end)