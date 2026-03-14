AddStateBagChangeHandler('grabable_item', nil, function(bagName, key, value, reserved, replicated)
    if not value then return end
    
    local netId = tonumber(bagName:match("entity:(%d+)"))
    if not netId then return end
    
    print("Grabable item entity created:", netId, json.encode(value))
    
    zutils.target.addNetIDTarget(netId, {
        {
            label = "Pick up " .. value.label,
            icon = "fas fa-hand-paper",
            onSelect = function()
                zutils.animation.playAnim(zutils.cache.ped, "pickup_object","pickup_low", {
                    flags = 64
                })
                Wait(500)
                TriggerServerEvent('zero_utils:server:pickupItem', value.id)
            end
        }
    })
end)