local qb_inventory = exports['qb-inventory']

local inventory = {}

function inventory.getItemInfo(item)
    local qb_item = QBCore.Shared.Items[item]
    if not qb_item then
        return false, "Item does not exist: " .. item
    end
    return {
        name = qb_item.name,
        label = qb_item.label,
        image = qb_item.image,
        description = qb_item.description,
        weight = qb_item.weight,
        stackable = qb_item.stackable,
        metadata = qb_item.metadata or {},
    }
end

function inventory.openInventory(inv_type, id)
    TriggerServerEvent("zero_utils:server:qb-inventory:OpenInventory", inv_type, id)
end

return inventory