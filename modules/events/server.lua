zutils.events = {}

function zutils.events.onPlayerLoaded(cb)
    local players = GetPlayers()
    if #players > 0 then
        CreateThread(function()
            for _, src in ipairs(players) do
                cb(tonumber(src))
            end
        end)
    end
    if not zutils.isResourceMissing("qb-core") then
        RegisterNetEvent("QBCore:Server:OnPlayerLoaded", function()
            local src = source
            cb(src)
        end)
    end
end


return zutils.events