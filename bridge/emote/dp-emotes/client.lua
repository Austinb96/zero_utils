local emote = {}

function emote.start(name, texture_variation)
    TriggerEvent('animations:client:EmoteCommandStart', {name})
end

function emote.cancel()
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end

return emote