local menu = {}

function menu.registerContext(id, menuData)
    menuData.id = id
    menuData.title = menuData.title or "Menu"
    lib.registerContext(menuData)
end

function menu.openMenu(id, menuData)
    if menuData then
        menu.registerContext(id, menuData)
    end
    lib.showContext(id)
end

function menu.inputDialog(header, inputs)
    local result = exports.ox_lib:inputDialog(header, inputs)
    return result
end

return menu