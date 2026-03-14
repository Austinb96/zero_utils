local bossmenu = {}

function bossmenu.open(_, group)

    TriggerEvent('esx_society:openBossMenu', group, function() end, { wash = false })
end

return bossmenu