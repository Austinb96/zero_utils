local emotes = {}

function emotes.play(name, texture_variation)
    exports["rpemotes-reborn"]:EmoteCommandStart(name, texture_variation or 0)
end

function emotes.stop()
    exports["rpemotes-reborn"]:EmoteCancel()
end

return emotes