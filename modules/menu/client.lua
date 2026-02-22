local menu = zutils.bridge_loader("menu")
if not menu then return end

zutils.menu = {}

zutils.menu.registerMenu = function(id, menuData)
    assert(id, "Menu ID must be specified")
    assert(menuData, "Menu data must be specified")
    menu.registerMenu(id, menuData)
end
zutils.menu.registerContext = zutils.menu.registerMenu

zutils.menu.openMenu = function(id, menuData)
    assert(id, "Menu ID must be specified")
    if menuData then
        zutils.menu.registerMenu(id, menuData)
    end
    menu.openMenu(id)
end

zutils.menu.inputDialog = function(header, inputs)
    assert(header, "Header must be specified")
    assert(inputs, "Inputs must be specified")
    return menu.inputDialog(header, inputs)
end

function zutils.menu.close(trigger_exit)
    menu.close(trigger_exit)
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    menu.close()
end)

return zutils.menu