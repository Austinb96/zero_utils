if not QBCore then QBCore = zutils.core_loader("QBCore") end

local core = {}

function core.getPlayerData()
    local player_data = QBCore.Functions.GetPlayerData()
    if not player_data then return false, "Player Data not found" end
    return player_data
end

function core.getJob()
    local player_data, err = core.getPlayerData()
    if not player_data then return false, err end
    local job = player_data.job
    if not job then return false, "Job not found" end
    return job
end

function core.getGang()
    local player_data, err = core.getPlayerData()
    if not player_data then return false, err end
    local gang = player_data.gang
    if not gang then return false, "Gang not found" end
    return gang
end

function core.getJobData(jobName)
    local job_data = QBCore.Shared.Jobs[jobName]
    if not job_data then return false, "Job not found" end
    return job_data
end

function core.getVehicleProperties(vehicle)
    local properties = QBCore.Functions.GetVehicleProperties(vehicle)
    if not properties then return false, "Failed to get vehicle properties" end
    return properties
end

return core