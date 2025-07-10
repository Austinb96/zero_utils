function zutils.getClosestPlayers(src, max_distance)
    src = src or -1
    max_distance = max_distance or math.huge
    local close_players = {}
    local player_ped = GetPlayerPed(src)
    local player_coords = GetEntityCoords(player_ped)
    local players = zutils.context == 'server' and GetPlayers() or GetActivePlayers()
    for _, player in ipairs(players) do
        if player ~= src then
            local ped = GetPlayerPed(player)
            local coords = GetEntityCoords(ped)
            local distance = #(player_coords - coords)

            if distance < max_distance then
                close_players[#close_players + 1] = {
                    player = player,
                    ped = ped,
                    coords = coords,
                    distance = distance
                }
            end
        end
    end
    return close_players
end

return zutils.getClosestPlayers