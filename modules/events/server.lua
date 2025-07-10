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
        AddEventHandler("QBCore:Server:PlayerLoaded", function(player)
            local src = player and player.source or source
            cb(tonumber(src))
        end)
    end
end

return zutils.events