zutils.callback.register('zero_utils:server:getFormatedPlayerSelection', function(source, dist)
    local result = {}
    local players = zutils.getClosestPlayers(source, dist or 15.0)
    for _, data in ipairs(players) do
        local playerData, err = zutils.player.getPlayerData(data.player)
        if not playerData then
            printwarn("Failed to get player data for: %s (%s)", data.player, err or "Unknown error")
            goto continue
        end
        result[#result + 1] = {
            label = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname,
            value = data.player
        }
        
        ::continue::
    end
    return result
end)