local core = {}

function core.getPlayerData()
    local player_data = ESX.GetPlayerData()
    if not player_data then return false, "Player Data not found" end
    return player_data
end

function core.getJob()
    local player_data, err = core.getPlayerData()
    if not player_data then return false, err end
    local job = player_data.job
    if not job then return false, "Job not found" end
    return job
end

function core.setThirst(thirst)
    TriggerEvent('esx_status:add', 'thirst', thirst)
    return true
end

function core.setHunger(hunger)
    TriggerEvent('esx_status:add', 'hunger', hunger)
    return true
end
function core.toggleDuty(duty, src)
    if not duty then
        TriggerServerEvent("zero_utils:server:esx_toggleDuty")
    else
        local player = core.getPlayerData(src)
        if not player then return false, "Player Data not found" end
        player.Functions.SetJobDuty(duty)
    end
end

function core.onJobUpdate(cb)
    RegisterNetEvent("esx:setJob", cb)
end

return core