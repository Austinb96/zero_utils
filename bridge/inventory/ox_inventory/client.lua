local ox_inventory = exports.ox_inventory
local inventory = {}

function inventory.getItemInfo(item)
    local ox_item = ox_inventory:Items(item)
    if not ox_item then
        return false, "Item does not exist: " .. item
    end
    return {
        name = ox_item.name,
        label = ox_item.label,
        description = ox_item.description,
        weight = ox_item.weight,
        stackable = ox_item.stackable,
        metadata = ox_item.metadata or {},
    }
end

function inventory.hasItem(item, count, metadata)
    local result = ox_inventory:Search("count", item, metadata)
    if result >= (count or 1) then
        return true
    end
    
    return false, "You do not have enough: " .. item
end

function inventory.openInventory(inv_type, id)
    ox_inventory:openInventory(inv_type, id)
end

return inventory