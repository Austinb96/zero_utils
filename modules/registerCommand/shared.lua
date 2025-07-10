zutils.registerCommand = function(name, cb, admin, desc, args)
    print("Registering command: "..name)
    RegisterCommand(name, function(source, args)
        cb(source, args)
    end, admin)
    TriggerEvent("chat:addSuggestion", "/"..name, desc, args)
end

return zutils.registerCommand
