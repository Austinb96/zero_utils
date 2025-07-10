local progressbar = zutils.bridge_loader("progressbar", "client")
if not progressbar then return end

zutils.progressBar = progressbar

return zutils.progressBar