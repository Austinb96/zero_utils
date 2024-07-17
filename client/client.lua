local function startDespawnLoop()
    CreateThread(function()
        local playerCoords
        local Peds = Config.Despawn.Peds
        local sleep = 0
        while true do
            sleep = 5000
            playerCoords = GetEntityCoords(PlayerPedId())
            for _, v in pairs(Peds) do
                if (#(playerCoords - v.coords)) < 100.0 then
                    ClearAreaOfPeds(v.coords.x, v.coords.y, v.coords.z, v.dist, true)
                    sleep = 500
                end
            end
            Wait(sleep)
        end
    end)
end


CreateThread(function()
    startDespawnLoop()
end)
