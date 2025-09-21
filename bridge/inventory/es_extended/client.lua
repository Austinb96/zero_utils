local inventory = {}

function inventory.getPlayerInventory()
    local Player  = ESX.GetPlayerData()
    return Player and Player.inventory or {}
end

function inventory.hasItem(item, count, metadata)
    local PlayerInv = inventory.getInv()
    local required = count or 1
    local found = 0

    for _, v in pairs(PlayerInv) do
        if v.name == item and (not metadata or v.metadata == metadata) then
            found = found + (v.count or v.amount or v.quantity or 1)
        end
    end

    return found >= required, (found >= required) and nil or ("You do not have enough: %s"):format(item)
end

function inventory.getItemImage(item)
    return 'https://cfx-nui-qb-inventory/html/images/'..item..'.png'
end

return inventory