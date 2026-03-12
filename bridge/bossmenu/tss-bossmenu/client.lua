local bossmenu = {}

function bossmenu.open(groupType, group)
    TriggerEvent("tss-bossmenu:client:OpenMenu")
end

return bossmenu