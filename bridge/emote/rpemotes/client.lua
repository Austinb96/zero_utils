local emote = {}

function emote.start(name, texture_variation)
    exports["rpemotes"]:EmoteCommandStart(name, texture_variation or 0)
end

function emote.cancel()
    exports["rpemotes"]:EmoteCancel()
end

return emote