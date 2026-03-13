local emotes = {}

function emotes.start(name, texture_variation)
    exports.scully_emotemenu:playEmoteByCommand(name)
end

function emotes.cancel()
    exports.scully_emotemenu:cancelEmote()
end


return emotes