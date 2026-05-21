local core = {}

function core.getOfflinePlayer(cid)
    local player = QBCore.Player.GetOfflinePlayer(cid)
    if not player then return false, "player does not exist" end
    
    return player
end

function core.getPlayer(src_or_cid)
    local player = QBCore.Functions.GetPlayer(tonumber(src_or_cid) or src_or_cid)
    if not player then
        player = QBCore.Functions.GetPlayerByCitizenId(src_or_cid)
        
        if not player then player = core.getOfflinePlayer(src_or_cid) end
    end
    
    if not player then return false, "Player not found" end
    return player
end

function core.getPlayerData(src_or_cid)
    local player, err = QBCore.Functions.GetPlayer(tonumber(src_or_cid))
    if not player then return false, err end
    local player_data = player.PlayerData
    if not player_data then return false, "Player Data not found" end
    return player_data
end

function core.getJob(src_or_cid)
    local player_data, err = core.getPlayerData(src_or_cid)
    if not player_data then return false, err end
    local job = player_data.job
    if not job then return false, "Job not found" end
    return job
end

function core.setJob(src_or_cid, job, rank, on_duty)
    local player, err = core.getPlayer(src_or_cid)
    if not player then return false, err end

    local result = player.Functions.SetJob(job, rank)
    if not result then return false, "failed to give job" end

    if type(on_duty) == "boolean" then
        player.Functions.SetJobDuty(on_duty)
    end

    player.Functions.Save()
    return true
end

function core.getGang(src_or_cid)
    local player_data, err = core.getPlayerData(src_or_cid)
    if not player_data then return false, err end
    local gang = player_data.gang
    if not gang then return false, "Gang not found" end
    return gang
end

function core.setGang(src_or_cid, gang, rank)
    local player, err = core.getPlayer(src_or_cid)
    if not player then return false, err end

    local result = player.Functions.SetGang(gang, rank)
    if not result then return false, "failed to give gang" end

    player.Functions.Save()
    return true
end

function core.getJobData(jobName)
    local jobs = QBCore.Shared.Jobs
    if not jobName then return jobs end
    local job_data = jobs[jobName]
    if not job_data then return false, "Job not found" end
    return job_data
end

function core.addThirst(src, thirst)
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    player.Functions.SetMetaData("thirst", player.PlayerData.metadata["thirst"] + thirst)
    TriggerClientEvent("hud:client:UpdateNeeds", src, player.PlayerData.metadata.hunger, thirst)
    return true
end

function core.setThirst(src, thirst)
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    player.Functions.SetMetaData("thirst", thirst)
    TriggerClientEvent("hud:client:UpdateNeeds", src, player.PlayerData.metadata.hunger, thirst)
    return true
end

function core.addHunger(src, hunger)
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    player.Functions.SetMetaData("hunger", player.PlayerData.metadata["hunger"] + hunger)
    TriggerClientEvent("hud:client:UpdateNeeds", src, player.PlayerData.metadata.hunger, player.PlayerData.metadata.thirst)
    return true
end

function core.setHunger(src, hunger)
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    player.Functions.SetMetaData("hunger", hunger)
    TriggerClientEvent("hud:client:UpdateNeeds", src, hunger, player.PlayerData.metadata.thirst)
    return true
end

function core.updateStress(src, stress)
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    player.Functions.SetMetaData('stress', player.PlayerData.metadata["stress"] + stress)
    TriggerClientEvent('hud:client:UpdateStress', src, stress)
end

function core.relieveStress(src, stress)
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    player.Functions.SetMetaData('stress', player.PlayerData.metadata["stress"] - stress)
    TriggerClientEvent('hud:client:UpdateStress', src, stress)
end

function core.setStress(src, stress)
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    player.Functions.SetMetaData('stress', player.PlayerData.metadata["stress"] + stress)
    TriggerClientEvent('hud:client:UpdateStress', src, stress)
end

function core.addHealth(src, health)
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    local entity = GetPlayerPed(src)
    local max_health = GetEntityMaxHealth(entity)
    local current_health = GetEntityHealth(entity)
    if current_health <= 0 then return end
    local new_health = math.clamp(100, current_health + health, max_health)
    Entity(entity).state:set('sv_health', new_health, true)
end

function core.setHealth(src, health)
    if not src then return end
    local player, err = core.getPlayer(src)
    if not player then return false, err end
    local entity = GetPlayerPed(src)
    local max_health = GetEntityMaxHealth(entity)
    local new_health = math.clamp(100, health, max_health)
    Entity(entity).state:set('sv_health', new_health, true)
end

function core.addArmour(src, armour)
    local currArmour = GetPedArmour(src)
    if currArmour >= 100 then return end
    SetPedArmour(src, math.min(100, math.floor(currArmour + armour)))
end

function core.setArmour(src, armour)
    SetPedArmour(src, armour)
end

function core.removeMoney(src_or_cid, amount, method, reason)
    local player, err = core.getPlayer(src_or_cid)
    if not player then return false, err end
    return player.Functions.RemoveMoney(method, amount, reason)
end

function core.addMoney(src_or_cid, amount, method, reason)
    local player, err = core.getPlayer(src_or_cid)
    if not player then return false, err end
    return player.Functions.AddMoney(method, amount, reason)
end

return core
