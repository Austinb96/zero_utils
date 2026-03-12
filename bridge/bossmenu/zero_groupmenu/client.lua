{   name = "esx_society",
        openBossMenu = function(isGang, group)
            TriggerServerEvent(getScript()..":registerESXSociety", isGang, group)
            TriggerEvent('esx_society:openBossMenu', group, function() end, { wash = false })
        end,
    },

    {   name = "tss-bossmenu",
        openBossMenu = function(isGang, group)
            TriggerEvent("tss-bossmenu:client:OpenMenu")
        end,
    },

    {   name = "okokBossMenu",
        openBossMenu = function(isGang, group)
            ExecuteCommand('openbossmenu')
        end,
    },