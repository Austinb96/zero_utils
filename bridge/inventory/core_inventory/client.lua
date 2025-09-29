local inventory = {}

function inventory.getPlayerInventory()
    local PlayerInv = exports["core_inventory"]:getInventory()
    if not PlayerInv then
        return {}
    end
    return PlayerInv
end

function inventory.hasItem(item, count, metadata)
    local PlayerInv = inventory.getPlayerInventory()
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


return inventory