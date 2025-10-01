local core = {}

function core.getPlayerData()
    local player_data = exports.qbx_core:GetPlayerData()
    if not player_data then return false, "Player Data not found" end
    return player_data
end

function core.getJob()
    local player_data, err = exports.qbx_core:GetPlayerData()
    if not player_data then return false, err end
    local job = player_data.job
    if not job then return false, "Job not found" end
    return job
end

function core.getJobData(jobName)
    local Jobs = exports.qbx_core:GetJobs()
    local job_data = Jobs[jobName]
    if not job_data then return false, "Job not found" end
    return job_data
end

function core.getGroupInfo(isJob)
    local data = exports.qbx_core:GetPlayerData()
    local group = isJob and data?.job or data?.gang
    return {
        name = group.name,
        grade = group.grade.level,
        label = group.label,
        isBoss = group.grade.isboss or false,
    }
end

function core.getGender()
    local data = exports.qbx_core:GetPlayerData()
    return (data.charinfo.gender or 0) + 1 -- 1 = Male, 2 = Female
end

function core.getGang()
    local data, err = exports.qbx_core:GetPlayerData()
    return data and data.gang or false, err or "Gang not found"
end

function core.isDead()
    local data = exports.qbx_core:GetPlayerData()
    return data.metadata and data.metadata.isdead
end

function core.getVehicleProperties(vehicle)
    local properties = QBCore.Functions.GetVehicleProperties(vehicle)
    if not properties then return false, "Failed to get vehicle properties" end
    return properties
end

function core.toggleDuty(duty, src)
    if not duty then
        TriggerServerEvent("QBCore:ToggleDuty")
    else
        local player = core.getPlayerData(src)
        if not player then return false, "Player Data not found" end
        player.Functions.SetJobDuty(duty)
    end
end

function core.onJobUpdate(cb)
    RegisterNetEvent("QBCore:Client:OnJobUpdate", cb)
end


return core