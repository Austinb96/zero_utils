local bossmenu = {}

function bossmenu.open(groupType, group)

    TriggerEvent('esx_society:openBossMenu', group, function() end, { wash = false })
end

return bossmenu