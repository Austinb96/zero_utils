local inventory = {}


function inventory.getPlayerInventory(src)
    local PlayerInv = exports["qs-inventory"]:getInventory(src)
    return PlayerInv or {}
end

function inventory.hasItem(src, item, count, metadata)
    local PlayerInv = inventory.getInv(src)
    local required = count or 1
    local found = 0

    for _, v in pairs(PlayerInv) do
        if v.name == item and (not metadata or v.metadata == metadata) then
            found = found + (v.count or v.amount or 1)
        end
    end

    return found >= required, (found >= required) and nil or ("You do not have enough: %s"):format(item)
end

return inventory