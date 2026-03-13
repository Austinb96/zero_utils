local emotes = {}

function emotes.play(name, texture_variation)
    TriggerEvent('animations:client:EmoteCommandStart', {name})
end

function emotes.stop()
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end

return emotes