local inventory = {}


function inventory.getPlayerInventory(src)
    local PlayerInv = QBCore.Functions.GetPlayer(src).PlayerData.items
    if not PlayerInv then
        return {}
    end
    return PlayerInv
end


return inventory