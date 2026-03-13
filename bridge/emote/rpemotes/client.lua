local emotes = {}

function emotes.play(emote, variation)
    printdb(true, "playing '%s' '%s'",emote, variation)
    exports.rpemotes:EmoteCommandStart(emote)
end

function emotes.stop(now)
    print("cancel")
    exports.rpemotes:EmoteCancel(now)
end

function emotes.isPlaying(emote)
    local current_emote = exports.rpemotes:getCurrentEmote()
    printtable("currnt_emote", current_emote)
    if not current_emote then return false end
    return current_emote.command == emote
end

return emotes