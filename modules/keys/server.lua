local keys = zutils.bridge_loader("keys", "server")
if not keys then return end

zutils.keys = {}

function zutils.keys.giveKeys(plate, target)
    if not plate or not target then return false end

    return keys.giveKeys(plate, target)
end

return zutils.keys
