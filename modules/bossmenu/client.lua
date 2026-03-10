local bossmenu = zutils.bridge_loader("bossmenu")
if not bossmenu then return end

zutils.bossmenu = {}

function zutils.bossmenu.open(type)
    bossmenu.open(type)
end

return zutils.bossmenu