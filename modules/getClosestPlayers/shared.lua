function zutils.getClosestPlayers(src, max_distance)
    src = src or -1
    max_distance = max_distance or math.huge
    local close_players = {}
    local coords = nil
    if type(src) == "vector3" then
        coords = src
    else
        local player_ped = GetPlayerPed(src)
        coords = GetEntityCoords(player_ped)
    end
    local players = zutils.context == 'server' and GetPlayers() or GetActivePlayers()
    for _, player in ipairs(players) do
        if player ~= src then
            local ped = GetPlayerPed(player)
            local other_coords = GetEntityCoords(ped)
            local distance = #(coords - other_coords)

            if distance < max_distance then
                close_players[#close_players + 1] = {
                    player = player,
                    ped = ped,
                    coords = other_coords,
                    distance = distance
                }
            end
        end
    end
    return close_players
end

return zutils.getClosestPlayers