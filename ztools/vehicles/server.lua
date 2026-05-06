zutils.callback.register("ztool:server:getVehicles", function(source, searchTerm)
    if not zutils.perms.hasPerm(source, "group.mod") then
        return nil
    end
    if not searchTerm or searchTerm == "" then
        return {}
    end

    local result = MySQL.query.await([[
        SELECT
            pv.*,
            p.charinfo,
            p.name as player_name
        FROM player_vehicles pv
        LEFT JOIN players p ON p.citizenid = pv.citizenid
        WHERE pv.plate LIKE ?
           OR pv.citizenid LIKE ?
           OR pv.license LIKE ?
           OR JSON_EXTRACT(p.charinfo, '$.firstname') LIKE ?
           OR JSON_EXTRACT(p.charinfo, '$.lastname') LIKE ?
    ]], {
        '%' .. searchTerm .. '%',
        '%' .. searchTerm .. '%',
        '%' .. searchTerm .. '%',
        '%' .. searchTerm .. '%',
        '%' .. searchTerm .. '%'
    })
    return result or {}
end)

zutils.callback.register("ztool:server:updateVehicle", function(source, vehicleId, updates)
    if not zutils.perms.hasPerm(source, "group.mod") then
        return false
    end

    if not vehicleId or not updates then
        return false
    end

    local setClauses = {}
    local params = {}

    if updates.citizenid then
        table.insert(setClauses, "citizenid = ?")
        table.insert(params, updates.citizenid)
    end

    if updates.state then
        table.insert(setClauses, "state = ?")
        table.insert(params, updates.state)
    end

    if updates.garage then
        table.insert(setClauses, "garage = ?")
        table.insert(params, updates.garage)
    end

    if #setClauses == 0 then
        return { success = false, error = "No updates provided" }
    end

    table.insert(params, vehicleId)

    local success = MySQL.query.await(
        "UPDATE player_vehicles SET " .. table.concat(setClauses, ", ") .. " WHERE id = ?",
        params
    )

    if success then
        return true
    else
        return false, "Database Error"
    end
end)
