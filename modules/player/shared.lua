local player = zutils.bridge_loader("core", "shared")
if not player then return end

zutils.player = {}
function zutils.player.getPlayerId(src)
    local player_data = player.getPlayerData(src)
    if not player_data then
        return false, "Player data not found"
    end
    return player_data.citizenid
end

function zutils.player.getPlayer(src)
    return player.getPlayer(src)
end

function zutils.player.getPlayerData(src)
    return player.getPlayerData(src)
end

function zutils.player.getJob(src)
    return player.getJob(src)
end

function zutils.player.getGang(src)
    return player.getGang(src)
end

function zutils.player.getJobData(src, jobName)
    return player.getJobData(src, jobName)
end
function zutils.player.getGender(src)
    return player.getGender(src)
end

function zutils.player.getMoney(moneyType, src)
    local player_data = player.getPlayerData(src)
    if not player_data then
        return 0
    end
    return player_data.money[moneyType] or 0
end

function zutils.player.removeMoney(src, amount, payment_method, reason)
    if zutils.context == "client" then
        printwarn("zutils.player.removeMoney should not be called from the client!")
        return false
    end

    return player.removeMoney(src, amount, payment_method or "cash", reason)
end

function zutils.player.addMoney(src, amount, payment_method, reason)
    if zutils.context == "client" then
        printwarn("zutils.player.addMoney should not be called from the client!")
        return false
    end
    
    return player.addMoney(src, amount, payment_method or "cash", reason)
end

function zutils.player.setHunger(src, hunger)
    return player.setHunger(src, hunger)
end

function zutils.player.setThirst(src, thirst)
    return player.setThirst(src, thirst)
end

return zutils.player
