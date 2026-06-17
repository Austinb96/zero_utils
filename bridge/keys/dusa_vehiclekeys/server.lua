local keys = {}

function keys.giveKeys(plate, source)
    if not plate or not source then
        return false, "Invalid vehicle or player."
    end

    exports["dusa_vehiclekeys"]:GiveKeys(tonumber(source), plate)
    return true
end

function keys.removeKeys(plate, source)
    if not plate or not source then
        return false, "Invalid vehicle or player."
    end

    exports["dusa_vehiclekeys"]:RemoveKeys(tonumber(source), plate)
end

function keys.transferKeys(plate, from, to)
    keys.removeKeys(plate, from)
    Wait(100)
    keys.giveKeys(plate, to)
    return true
end

return keys