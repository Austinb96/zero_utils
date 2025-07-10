local inventory = zutils.bridge_loader("inventory", "client")
if not inventory then return end

zutils.inventory = {}

function zutils.inventory.openInventory(inv_type, id)
    assert(inv_type, "Inventory must be specified")
    assert(id, "Inventory ID must be specified")
    inventory.openInventory(inv_type, id)
end
zutils.inventory.OpenInventory = zutils.inventory.openInventory -- Alias for compatibility

function zutils.inventory.hasItem(item, count, metadata)
    return inventory.hasItem(item, count, metadata)
end
zutils.inventory.HasItem = zutils.inventory.hasItem -- Alias for compatibility

return zutils.inventory