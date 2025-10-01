local emote = {}

function emote.start(name, texture_variation)
    exports.scully_emotemenu:playEmoteByCommand(name)
end

function emote.cancel()
    exports.scully_emotemenu:cancelEmote()
end


return emote