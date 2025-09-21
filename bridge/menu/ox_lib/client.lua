local menu = {}

function menu.registerMenu(id, menuData)
    menuData.id = id
    menuData.title = menuData.title or "Menu"
    lib.registerContext(menuData)
end

function menu.openMenu(id)
    lib.showContext(id)
end

function menu.inputDialog(header, inputs)
    local result = exports.ox_lib:inputDialog(header, inputs)
    return result
end

function menu.closeMenu()
    lib.hideContext()
end

return menu