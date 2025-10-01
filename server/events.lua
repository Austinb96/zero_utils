print('Loading events...')
AddEventHandler('gameEventTriggered', function(name, args)
    print('game event ' .. name .. ' (' .. json.encode(args) .. ')')
end)