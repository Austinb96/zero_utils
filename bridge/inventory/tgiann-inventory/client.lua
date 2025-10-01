local inventory = {}

function inventory.getItemInfo(item)
    local tg_item = exports["tgiann-inventory"]:Items(item)
    if not tg_item then
        return false, "Item does not exist: " .. item
    end
    return {
        name = item,
        label = tg_item.label,
        image = tg_item.client and tg_item.client.image or tg_item.name .. ".png",
        description = tg_item.description,
        weight = tg_item.weight,
        stackable = tg_item.stack,
        metadata = tg_item.metadata or {},
    }
end

function inventory.getInv()
    local PlayerInv = exports["tgiann-inventory"]:GetPlayerItems()
    if not PlayerInv then
        return {}
    end
    return PlayerInv
end

function inventory.hasItem(item, count, metadata)
    local result = exports["tgiann-inventory"]:HasItem(item, count)
    if result then
        return true
    end

    return false, "You do not have enough: " .. item
end

function inventory.openInventory(inv_type, id)
    exports["tgiann-inventory"]:OpenInventory(inv_type, id)
end

function inventory.Image(item)
    return 'https://cfx-nui-tgiann_inventory/html/images/'..item..'.png'
end

return inventory