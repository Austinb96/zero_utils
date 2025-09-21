local keys = {}

function keys.giveKeys(plate, source)
    if not plate or not source then
        return false, "Invalid vehicle or player."
    end

    exports["dusa_vehiclekeys"]:GiveKeys(source, plate)
    return true
end

return keys