local inventory = {}

function inventory.getPlayerInventory(src)
    local PlayerInv = exports["core_inventory"]:getInventory(src)
    if not PlayerInv then
        return {}
    end
    return PlayerInv
end

function inventory.hasItem(src, item, count, metadata)
    local PlayerInv = inventory.getPlayerInventory(src)
    local required = count or 1
    local found = 0

    for _, v in pairs(PlayerInv) do
        if v.name == item and (not metadata or v.metadata == metadata) then
            found = found + (v.count or v.amount or 1)
        end
    end

    if found >= required then
        return true
    else
        return false, ("You do not have enough: %s"):format(item)
    end
end

function inventory.createUseableItem(itemName, cb)
    return printwarn("CreateUseableItem is not supported in core_inventory bridge at this moment")
end


return inventory