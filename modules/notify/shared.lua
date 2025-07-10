local notify = zutils.bridge_loader("notify", "shared")
if not notify then return end

zutils.notify = notify

return zutils.notify