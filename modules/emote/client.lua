local emotes = zutils.bridge_loader("emote")
print("loading emotes", emotes)
if not emotes then return end

zutils.emote = {}

function zutils.emote.play(emote, variation)
    emotes.play(emote, variation)
end

function zutils.emote.stop()
    emotes.stop()
end

function zutils.emote.isPlaying(emote)
    return emotes.isPlaying(emote)
end

return zutils.emote