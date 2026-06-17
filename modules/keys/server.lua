local keys = zutils.bridge_loader("keys")
if not keys then return end

zutils.keys = {}

function zutils.keys.giveKeys(plate, src)
    if not plate or not src then return false end

    return keys.giveKeys(plate, src)
end

function zutils.keys.removeKeys(plate, src)
    if not plate or not src then return false end

    return keys.removeKeys(plate, src)
end

function zutils.keys.transferKeys(plate, from, to)
    return keys.transferKeys(plate, from, to)
end

return zutils.keys