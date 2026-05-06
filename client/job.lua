local core = zutils.bridge_loader("core")
if not core then return end

zutils.cache.job = {
    name = "",
    onduty = false,
    grade = 0,
    gradename = "",
    isboss = false,
    label = "",
    type = ""
}
zutils.cache.onduty = false

zutils.events.onPlayerLoaded(function()
    local job = zutils.player.getJob()
    zutils.cache.job = job
    zutils.cache.onduty  = job.onduty
end)

core.onJobUpdate(function(job)
    zutils.cache.job = job
    zutils.cache.onduty  = job.onduty
end)
