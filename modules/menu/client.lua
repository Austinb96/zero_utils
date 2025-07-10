local menu = zutils.bridge_loader("menu", "client")
if not menu then return end

zutils.menu = {}

zutils.menu.registerContext = function(id, menuData)
    assert(id, "Menu ID must be specified")
    assert(menuData, "Menu data must be specified")
    menu.registerContext(id, menuData)
end

zutils.menu.openMenu = function(id, menuData)
    assert(id, "Menu ID must be specified")
    if menuData then
        zutils.menu.registerContext(id, menuData)
    end
    menu.openMenu(id, menuData)
end

zutils.menu.inputDialog = function(header, inputs)
    assert(header, "Header must be specified")
    assert(inputs, "Inputs must be specified")
    return menu.inputDialog(header, inputs)
end

return zutils.menu