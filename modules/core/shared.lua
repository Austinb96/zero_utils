local core = zutils.bridge_loader("core")
if not core then return end

zutils.core = {}

function zutils.core.getJobData(jobName)
    local data = core.getJobData(jobName)
    if not jobName then return data end
    local max_rank = 0
    for rank, _ in pairs(data.grades) do
        rank = tonumber(rank)
        if rank and  max_rank < rank then
            max_rank = rank
        end
    end
    data.maxRank = max_rank
    return data
end

return zutils.core