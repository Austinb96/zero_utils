local points = {}
zutils.Points = {
    AddPoint = function(coords, options)
        local id = #points + 1
        points[id] = {
            id = id,
            inside = true,
            coords = coords,
            distance = options.distance,
            onEnter = options.onEnter,
            onExit = options.onExit,
        }
        return id
    end,
    RemovePoint = function(id)
        points[id] = nil
    end
}

CreateThread(function()
    local playerCoords
    while true do
        playerCoords = GetEntityCoords(PlayerPedId())
        for _, point in pairs(points) do
            local dist = #(playerCoords - point.coords.xyz)
            if dist <= point.distance then
                if not point.inside then
                    point.inside = true
                    if point.onEnter then
                        point.onEnter()
                    end
                end
            elseif point.inside then
                point.inside = false
                if point.onExit then
                    point.onExit()
                end
            end
        end
        Wait(500)
    end
end)

return zutils.Points