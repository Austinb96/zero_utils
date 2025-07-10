local player = zutils.bridge_loader("core", "shared")

zutils.player = {}

function zutils.player.getPlayer(src)
    return player.getPlayer(src)
end

function zutils.player.getPlayerData(src)
    return player.getPlayerData(src)
end

function zutils.player.getJob(src)
    return player.getJob(src)
end

return zutils.player