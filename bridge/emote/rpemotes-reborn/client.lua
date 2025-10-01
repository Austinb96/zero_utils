local emote = {}

function emote.start(name, texture_variation)
    exports["rpemotes-reborn"]:EmoteCommandStart(name, texture_variation or 0)
end

function emote.cancel()
    exports["rpemotes-reborn"]:EmoteCancel()
end

return emote