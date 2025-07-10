zutils.events = {}

function zutils.events.onPlayerLoaded(cb)
    if LocalPlayer.state.isLoggedIn then
        Wait(500)
        printdb("Player was already loaded")
        cb()
    end
    if not zutils.isResourceMissing("qb-core") then
        AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
            Wait(500)
            while not LocalPlayer.state.isLoggedIn do Wait(1000) end
            printdb("Player loaded")
            cb()
        end)
    end
end

zutils.events.onPlayerUnload = function(cb)
    if not zutils.isResourceMissing("qb-core") then
        AddEventHandler("QBCore:Client:OnPlayerUnload", function()
            printdb("Player unloaded")
            cb()
        end)
    end
end

function zutils.events.onVehicleEntered(cb)
    RegisterNetEvent('baseevents:enteredVehicle', function(veh,seat,modelName)
        cb(veh, seat, modelName)
    end)
end

function zutils.events.onEnteringVehicle(cb)
    RegisterNetEvent('baseevents:enteringVehicle', function(veh,seat,modelName)
        cb(veh, seat, modelName)
    end)
end

function zutils.events.onLeftVehicle(cb)
    RegisterNetEvent('baseevents:leftVehicle', function(veh,seat,modelName)
        cb(veh, seat, modelName)
    end)
end

function zutils.events.onVehicleEnterAborted(cb)
    RegisterNetEvent('baseevents:enteringAborted', function()
        cb()
    end)
end

return zutils.events