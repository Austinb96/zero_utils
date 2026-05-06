local bossmenu = zutils.bridge_loader("bossmenu")
if not bossmenu then return end

zutils.bossmenu = {}

function zutils.bossmenu.open(group_type, group)
    bossmenu.open(group_type, group)
end

return zutils.bossmenu