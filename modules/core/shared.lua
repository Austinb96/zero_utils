local core = zutils.bridge_loader("core", "shared")
if not core then return end

zutils.core = {}

function zutils.core.getJobData(jobName)
    return core.getJobData(jobName)
end

return zutils.core